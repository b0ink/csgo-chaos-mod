#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <multicolors>
#include <cstrike>

#undef REQUIRE_PLUGIN
#include <DynamicChannels>
#include <smac> // Protection for SMAC users (SM Aimbot).
#define REQUIRE_PLUGIN

#pragma newdecls required
#pragma semicolon 1

#define PLUGIN_NAME "CS:GO Chaos Mod"
#define PLUGIN_DESCRIPTION "Spawn from over 100+ random effects every 15 seconds to ensue chaos towards you and your enemies"
#define PLUGIN_VERSION "0.2.4"

// #define TWITCH_ENABLED



// #define GetRandomMapSpawn(%1) for(int %1 = 0; %1 < )

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = "BOINK",
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = "https://github.com/b0ink/csgo-chaos-mod"
};

char mapName[64];

char 	g_Prefix[] = "[{lime}CHAOS{default}]";
char 	g_Prefix_HasTimerEnded[] = "<<{darkred}Ended{default}>>";
char 	g_Prefix_MegaChaos[] = "\n<<{orange}C H A O S{default}>>";


// StringMap	Chaos_Effects;

#define SOUND_BELL "buttons/bell1.wav"
#define SOUND_BLIP "buttons/blip1.wav"
#define SOUND_COUNTDOWN "ui/beep07.wav"

#define DISTORTION "explosion_child_distort01b"
#define FLASH "explosion_child_core04b"
#define SMOKE "impact_dirt_child_smoke_puff"
#define DIRT "impact_dirt_child_clumps"
#define EXPLOSION_HE "weapons/hegrenade/explode5.wav"

// #define LoopAllEntities(%1,%2) for(int %1 = 0; %1 < %2;%1++)
// 								if(IsValidEntity(%1) && IsValidEdict(%1))

#define LoopAllEntities(%1,%2,%3) for(int %1 = 0; %1 < %2;%1++)\
		if(IsValidEntity(%1) && IsValidEdict(%1))\
		if(GetEdictClassname(%1, %3, 64))

// If i revert on the 2nd param being the index, index/i is accessible in the loop as its a define, but for clarity ill leave it..
#define LoopAllEffects(%1,%2) for(int %2 = 0; %2 < 999; %2++)\
		if(%2 < ChaosEffects.Length)\
		if(ChaosEffects.GetArray(%2, %1, sizeof(%1)))

#define LoopAllMetaEffects(%1,%2) for(int %2 = 0; %2 < 999; %2++)\
		if(%2 < ChaosEffects.Length)\
		if(ChaosEffects.GetArray(%2, %1, sizeof(%1)))\
		if(%1.IsMetaEffect)

		

// Already checks if they are on a valid team
#define LoopAllClients(%1) 		for(int %1 = 0; %1 <= MaxClients; %1++)
#define LoopValidPlayers(%1) 	for(int %1 = 0; %1 <= MaxClients; %1++) if(IsValidClient(%1) && (GetClientTeam(%1) == CS_TEAM_T || GetClientTeam(%1) == CS_TEAM_CT))
#define LoopAlivePlayers(%1) 	for(int %1 = 0; %1 <= MaxClients; %1++) if(ValidAndAlive(%1))



char g_sWeapons[][64] = {"weapon_glock", "weapon_p250", "weapon_fiveseven", "weapon_deagle", "weapon_elite",
    "weapon_hkp2000", "weapon_tec9", "weapon_nova", "weapon_xm1014", "weapon_sawedoff",
    "weapon_m249", "weapon_negev", "weapon_mag7",
    "weapon_mp7", "weapon_ump45", "weapon_p90", "weapon_bizon", "weapon_mp9", "weapon_mac10",
    "weapon_famas", "weapon_m4a1", "weapon_aug", "weapon_galilar", "weapon_ak47", "weapon_sg556",
    "weapon_ssg08", "weapon_awp", "weapon_scar20", "weapon_g3sg1",
};


char g_sSkyboxes[][] = {
	"cs_baggage_skybox_", "cs_tibet", "embassy", "italy", "jungle", "office", "sky_cs15_daylight01_hdr",
	"sky_cs15_daylight02_hdr", "sky_cs15_daylight03_hdr", "sky_cs15_daylight04_hdr", "sky_day02_05",
	"nukeblank", "sky_venice", "sky_csgo_cloudy01", "sky_csgo_night02", "sky_csgo_night02b", "vertigo", "vertigoblue_hdr",
	"sky_dust", "vietnam"
};


bool 	g_bCanSpawnChickens = true;
bool 	g_bCanSpawnEffect = true;

int 	g_iTotalEffectsRanThisRound = 0;
int		g_iTotalRoundsThisMap = 0;
int		g_iEffectsSinceMeta = 0;
int 	g_iChaosRoundTime = 0; // starts counting from round start, including freeze time


bool 	g_bMegaChaosIsActive = false;

char 	g_sSelectedChaosEffect[64] = "";
char 	g_sForceCustomEffect[64] = ""; //overrides g_sSelectedChaosEffect
char 	g_sLastPlayedEffect[64] = "";

bool 	g_bPlaySound_Debounce = false;
bool 	g_bDisableRetryEffect = false;


bool 	g_bDynamicChannelsEnabled = false;

int 	ChaosMapCount = 0;


// Any variables shared by multiple plugins can be listed here
int 	g_bNoStrafe = 0;
int 	g_AutoBunnyhop = 0;
int 	g_bNoForwardBack = 0;
int 	g_NoFallDamage = 0;
int 	g_iC4ChickenEnt = -1;


#include "ConVars.sp"

Handle 		g_NewEffect_Timer = INVALID_HANDLE;
ArrayList 	ChaosEffects;
ArrayList 	PossibleChaosEffects;

Handle 		EffectsHistory = INVALID_HANDLE;

ArrayList 	PossibleMetaEffects;
ArrayList	MetaEffectsHistory;

enum struct effect_data{
	char 		Title[64]; // 0th index for ease of sorting in configs.sp
	int 		ID;
	char 		FunctionName[64];
	
	int 		Duration;
	bool 		HasNoDuration;
	bool		HasCustomAnnouncement;
	bool		Enabled;
	bool		IsMetaEffect;

	Handle		IncompatibleEffects;
	Handle		Aliases;
	Handle 		Timer;

	void Run(){
		Function func = GetFunctionByName(GetMyHandle(), this.function_name_start);
		char function_name_start[64];
		Format(function_name_start, sizeof(function_name_start), "%s_START", this.FunctionName);

		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish();

			float duration = this.GetDuration(); 
			if(duration > 0) this.Timer = CreateTimer(duration, Effect_Reset, this.ID);
			
			if(!this.HasCustomAnnouncement){
				AnnounceChaos(this.Title, this.GetDuration(), _, this.IsMetaEffect);
			}
			g_sLastPlayedEffect = this.FunctionName;
			ChaosMapCount++;
			ChaosEffects.SetArray(this.ID, this); // save timer
		}
	}

	void Reset(bool HasTimerEnded = false){
		Function func = GetFunctionByName(GetMyHandle(), this.function_name_reset);
		char function_name_reset[64];
		Format(function_name_reset, sizeof(function_name_reset), "%_RESET", this.FunctionName);

		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(HasTimerEnded);
			Call_Finish();
			this.Timer = INVALID_HANDLE;
			ChaosEffects.SetArray(this.ID, this);
		}
	}

	bool CanRunEffect(){
		//TODO: slowly remove conditions and check .IsCompatible
		bool response = true;
		char condition_check[64];
		FormatEx(condition_check, sizeof(condition_check), "%s_Conditions", this.FunctionName);
		Function func = GetFunctionByName(GetMyHandle(), condition_check);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish(response);
		}
		return response;
	}
	float GetDuration(bool raw = false){
		if(this.HasNoDuration){
			return -1.0;
		}
		float OverwriteDuration = g_fChaos_OverwriteDuration;
		float duration = float(this.Duration);
		if(raw){
			return duration;
		}
		//TODO: change announcechaos to only take the config name, automatically get the duration
		// no need for defaults anymore as config is the only default

		if(OverwriteDuration < -1.0){
			Log("Cvar 'OverwriteEffectDuration' set Out Of Bounds in Chaos_Settings.cfg, effects will use their durations in Chaos_Effects.cfg");
			OverwriteDuration = - 1.0;
		}
		if(OverwriteDuration != -1.0){
			duration = OverwriteDuration;
		}else{
			if(duration == -1.0){
				return -1.0;
			}
			if(duration < 0 ){
				duration = SanitizeTime(duration);
			}else{
				if(duration != SanitizeTime(duration)){
					Log("Incorrect duration set for %s. You set: %f, defaulting to: %f", this.FunctionName, duration, SanitizeTime(duration));
					duration = SanitizeTime(duration);
				}
			}
		}


		return duration;
	}
	void IncompatibleWith(char[] effectName){
		if(this.IncompatibleEffects == INVALID_HANDLE){
			this.IncompatibleEffects = CreateArray(255);
		}
		PushArrayString(this.IncompatibleEffects, effectName);
	}
	bool IsCompatible(){
		if(this.IncompatibleEffects == INVALID_HANDLE) return true;
		
		char effectName[255];
		for(int i = 0; i < GetArraySize(this.IncompatibleEffects); i++){
			GetArrayString(this.IncompatibleEffects, i, effectName, sizeof(effectName));
			if(IsEffectRunning(effectName)){
				return false;
			}
		}
		effect_data effect;

		LoopAllEffects(effect, index){
			if(effect.Timer != INVALID_HANDLE){
				for(int i = 0; i < GetArraySize(effect.IncompatibleEffects); i++){
					GetArrayString(effect.IncompatibleEffects, i, effectName, sizeof(effectName));
					if(StrEqual(effect.FunctionName, effectName)){
						return false;
					}
				}
			}
		}

		return true;
	}
	void AddAlias(char[] effectName){
		if(this.Aliases == INVALID_HANDLE){
			this.Aliases = CreateArray(255);
		}
		PushArrayString(this.Aliases, effectName);
	}
}

bool IsEffectRunning(char[] effectName){
	effect_data effect;
	LoopAllEffects(effect, index){
		if(effect.Timer != INVALID_HANDLE && StrEqual(effect.FunctionName, effectName, false)){
			return true;
		}
	}
	return false;
}

public Action Effect_Reset(Handle timer, int effect_id){
	effect_data effect;
	LoopAllEffects(effect, index){
		if(effect.ID == effect_id){
			effect.Reset(true);
			ChaosEffects.SetArray(index, effect);
			break;
		}
	}
}


// Shared by multiple effects
#include "Global/InstantWeaponSwitch.sp"
#include "Global/WeaponJump.sp"
#include "Global/Fog.sp"
#include "Global/ColorCorrection.sp"
#include "Global/Weather.sp"
#include "Global/Players.sp"
#include "Spawns.sp"


#include "Effects/EffectsList.sp"

char EffectNames[][] = {
	#include "Effects/EffectNames.sp"
};

float BellVolume[MAXPLAYERS+1] = {0.5, ...};

#include "Commands.sp"
#include "Hud.sp"
#include "Configs.sp"
#include "Menu.sp"
#include "Twitch.sp"


public void OnPluginStart(){
	LoadTranslations("chaos.phrases");
	
	CreateConVars();
	
	RegisterCommands();

	HookEvent("round_start", 	Event_RoundStart);
	HookEvent("round_end", 		Event_RoundEnd);	
	HookEvent("bomb_planted", 	Event_BombPlanted);
	HookEvent("server_cvar", 	Event_Cvar, 			EventHookMode_Pre);

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			OnClientPutInServer(i);
		}
	}

	PossibleChaosEffects = new ArrayList(sizeof(effect_data));
	EffectsHistory = CreateArray(64);

	PossibleMetaEffects = new ArrayList(sizeof(effect_data));
	MetaEffectsHistory = new ArrayList(sizeof(effect_data));

	g_SavedConvars  = CreateArray(64);

	ChaosEffects = new ArrayList(sizeof(effect_data));

	ParseChaosEffects();

	TWITCH_INIT();
	Overlay_INIT()l

}


public void OnPluginEnd(){
	ResetCvar();
	ResetChaos();
}

public void OnMapStart(){
	
	MetaEffectsHistory.Clear();
	if(EffectsHistory != INVALID_HANDLE){
		ClearArray(EffectsHistory);
	}
	UpdateCvars();

	CheckHostageMap();
	CreateTimer(1.0, Timer_DisplayEffects, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);

	GetCurrentMap(mapName, sizeof(mapName));
	Log("New Map/Plugin Restart - Map: %s", mapName);
	
	PrecacheSound(SOUND_BELL);
	PrecacheSound(SOUND_COUNTDOWN);
	PrecacheSound(SOUND_BLIP);

	// ParseChaosConfigEffects();


	if(g_MapCoordinates != 	INVALID_HANDLE) ClearArray(g_MapCoordinates);
	if(bombSiteA != 		INVALID_HANDLE) ClearArray(bombSiteA);
	if(bombSiteB != 		INVALID_HANDLE) ClearArray(bombSiteB);

	g_MapCoordinates = 		INVALID_HANDLE;
	bombSiteA = 			INVALID_HANDLE;
	bombSiteB = 			INVALID_HANDLE;

	Find_Fog();
	
	CLEAR_CC();
	HUD_INIT();

	COORD_INIT();
	WEATHER_INIT();

	// Run_OnMapStart_Functions();

	cvar("sv_fade_player_visibility_farz", "1");

	StopTimer(g_NewEffect_Timer);
	g_NewEffect_Timer = INVALID_HANDLE;

	if(EffectsHistory != INVALID_HANDLE) ClearArray(EffectsHistory);

	RemoveChickens();
	
	ChaosMapCount = 0;


}


public void OnMapEnd(){
	if(!g_bChaos_Enabled) return;

	Log("Map has ended.");
	StopTimer(g_NewEffect_Timer);
	ResetCvar();
}


public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max){
    MarkNativeAsOptional("GetDynamicChannel");
    return APLRes_Success;
}

public void OnAllPluginsLoaded(){
	g_bDynamicChannelsEnabled = LibraryExists("DynamicChannels");
	if(!g_bDynamicChannelsEnabled){
		Log("Could not find plugin 'DynamicChannels.smx'. To enable HUD text for Chaos effects and timers, install the 'DynamicChannels.smx' plugin from https://github.com/Vauff/DynamicChannels");
	}
}
 
public void OnLibraryRemoved(const char[] name){
    if (StrEqual(name, "DynamicChannels")){
        g_bDynamicChannelsEnabled = false;
    }
}
 
public void OnLibraryAdded(const char[] name){
    if (StrEqual(name, "DynamicChannels")){
        g_bDynamicChannelsEnabled = true;
    }
}

public void OnClientPutInServer(int client){
	BellVolume[client] = 0.5;
	WeaponJumpConnect_Handler(client);

	SDKHook(client, SDKHook_PreThinkPost, Chaos_DisableStrafe_Hook_PreThinkPost);
	SDKHook(client, SDKHook_PreThinkPost, Chaos_DisableForwardBack_Hook_PreThinkPost);
}

public void OnClientDisconnect(int client){
	ToggleAim(client, false);
	WeaponJumpDisconnect_Handler(client);
}

public Action Timer_CreateHostage(Handle timer){
	CreateHostageRescue();
}

bool Effect_Recently_Played(char[] effect_name){
	bool found = false;
	if(FindStringInArray(EffectsHistory, effect_name) != -1){
		found = true;
	}
	return found;
}

bool PoolChaosEffects(char[] effectName = ""){

	char alias[64];
	PossibleChaosEffects.Clear();
	effect_data effect;
	LoopAllEffects(effect, index){
		if(effectName[0]){ //* if keyword was provided
			bool containsAlias = false;
			if(effect.Aliases != INVALID_HANDLE){
				for(int i = 0; i < GetArraySize(effect.Aliases); i++){
					GetArrayString(effect.Aliases, i, alias, sizeof(alias));
					if(StrContains(alias, effectName, false) != -1){
						containsAlias = true;
					}
				}
			}

		
			if(
				StrContains(effect.FunctionName, effectName, false) != -1 ||
				StrContains(effect.Title, effectName, false) != -1 ||
				containsAlias
			){
				PossibleChaosEffects.PushArray(effect, sizeof(effect));
			}
		}else{
			PossibleChaosEffects.PushArray(effect, sizeof(effect)); //* Show all but may be disabled in menu
		}
	}

	Log("Size of pooled chaos effects: %i", PossibleChaosEffects.Length);
}


Action ChooseEffect(Handle timer = null, bool CustomRun = false){
	if(!CustomRun) g_NewEffect_Timer = INVALID_HANDLE;
	if(!g_bCanSpawnEffect) return;
	if(!g_bChaos_Enabled && !CustomRun) return;

	char Random_Effect[64] = "-";
	int randomEffect = -1;
	int attempts = 0;
	g_sLastPlayedEffect = "";

	PoolChaosEffects();

	if(g_MapCoordinates == INVALID_HANDLE){
		ParseMapCoordinates("Chaos_Locations");
	}

	if(g_bChaos_TwitchEnabled && !g_bMegaChaosIsActive && !CustomRun){
			if(Twitch_Votes.Length != 0){
				effect_data effect;
				if(GetHighestVotedEffect(effect)){
					g_sForceCustomEffect = effect.FunctionName;
				}

				if(!effect.CanRunEffect()){
					g_sForceCustomEffect = "";
				}
			}
	}


	if(g_sForceCustomEffect[0]){ //run from menu
		// FormatEx(g_sSelectedChaosEffect, sizeof(g_sSelectedChaosEffect), "%s", g_sForceCustomEffect);
		effect_data effect;
		LoopAllEffects(effect, index){
			//TODO: test conditions, return error to user?
			if(StrEqual(effect.FunctionName, g_sForceCustomEffect, false)){
				effect.Run();
				break;
			}
		}
	}else{
		effect_data effect;
		int totalEffects = ChaosEffects.Length;



		
		while(!g_sLastPlayedEffect[0]){ // no longer
			attempts++;
			do{
				randomEffect = GetRandomInt(0, totalEffects - 1);
				ChaosEffects.GetArray(randomEffect, effect, sizeof(effect));
				if(
					effect.Enabled &&
					effect.CanRunEffect() &&
					(!Effect_Recently_Played(effect.FunctionName) || CustomRun) &&
					effect.Timer == INVALID_HANDLE &&
					effect.IsCompatible() &&
					!effect.IsMetaEffect
				){
					Random_Effect = effect.FunctionName;
					effect.Run();
					if(!g_bMegaChaosIsActive){ // just in case?
						g_iEffectsSinceMeta++;
					}
					PushArrayString(EffectsHistory, effect.FunctionName);

					float average = float((PossibleChaosEffects.Length / 4) * 3); //idk
					if(GetArraySize(EffectsHistory) > average) RemoveFromArray(EffectsHistory, 0);
				}

			}while(!Random_Effect[0]);
			if(attempts > 900){
				LogError("Clearing effect history");
				ClearArray(EffectsHistory); //fail safe
				break;
			}
		}
	}

	LogEffect(g_sLastPlayedEffect);

	PrintEffects();
	g_sForceCustomEffect  = "";
	if(g_bPlaySound_Debounce == false){
		//Prevent overlapping sounds
		g_bPlaySound_Debounce = true;
		LoopValidPlayers(i){
			EmitSoundToClient(i, SOUND_BELL, _, _, SNDLEVEL_RAIDSIREN, _, BellVolume[i]);
		}	
		CreateTimer(0.2, Timer_ResetPlaySound);
	}

	if(CustomRun) return;


	if(!CustomRun &&  (g_iTotalRoundsThisMap >= 5 && GetRandomInt(0, 100) <= 40 && g_iEffectsSinceMeta >= 20 && g_iChaosRoundTime < 30)){
		g_iEffectsSinceMeta = 0;
		effect_data metaEffect;
		bool metaAlreadyRunning = false;
		PossibleMetaEffects.Clear();
		LoopAllMetaEffects(metaEffect, index){
			// PrintToChatAll("%s s", metaEffect.Title);
			if(metaEffect.CanRunEffect()){
				PossibleMetaEffects.PushArray(metaEffect, sizeof(metaEffect));
			}
			if(metaEffect.Timer != INVALID_HANDLE){
				metaAlreadyRunning = true;
			}
		}
		if(!metaAlreadyRunning && PossibleMetaEffects.Length > 0) {
			int random = GetRandomInt(0, PossibleMetaEffects.Length - 1);
			PossibleMetaEffects.GetArray(random, metaEffect, sizeof(metaEffect));
			g_sForceCustomEffect = metaEffect.FunctionName;
			MetaEffectsHistory.PushArray(metaEffect);
			ChooseEffect(null, true);
		}
		// History too full, clear it to allow old ones to be spawned.
		if(MetaEffectsHistory.Length > PossibleMetaEffects.Length - 1){
			MetaEffectsHistory.Clear();
		}

	}


	StopTimer(g_NewEffect_Timer);
	bool Chaos_Repeating = g_bChaos_Repeating;

	if(Chaos_Repeating){
		if(g_bChaos_TwitchEnabled){
			Twitch_PoolNewVotingEffects(); // pull 4 effects, this WILL add them into the effect cooldown.
		}
		float Effect_Interval = g_fChaos_EffectInterval;
		if(Effect_Interval > 60 || Effect_Interval < 5){
			Log("Cvar 'EffectInterval' Out Of Bounds. Resetting to 15 seconds - Chaos_Settings.cfg | was set to %f", Effect_Interval);
			Effect_Interval = 15.0;
		}
		g_NewEffect_Timer = CreateTimer(Effect_Interval, ChooseEffect);
		if(g_bDynamicChannelsEnabled){
			Timer_Display(null, RoundToFloor(Effect_Interval));
		}
		g_iTotalEffectsRanThisRound++;
	}
}

public Action Timer_ResetPlaySound(Handle timer){
	g_bPlaySound_Debounce = false;
}

//Used if there's no map data found for the map that renders the event useless
//TODO: to be removed, some like AutoPlant still rely on it as its difficult to make those checks
public void RetryEffect(){
	Log("RETRYING EVENT..");
	if(g_bDisableRetryEffect){
		Log("Retries are currently disabled.");
		return;
	}
	StopTimer(g_NewEffect_Timer);
	g_sForceCustomEffect = "";
	g_sSelectedChaosEffect = "";
	ChooseEffect(INVALID_HANDLE);
}

public Action ResetRoundChaos(Handle timer){
	RemoveChickens(false);
	Fog_OFF();

	effect_data effect;
	LoopAllEffects(effect, index){
		effect.Reset(false);
	}
}




#include "Events.sp"
#include "Helpers.sp"