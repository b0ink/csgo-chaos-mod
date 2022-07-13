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
#define PLUGIN_VERSION "0.1.0"


//TODO:..
#define LoopMapPoints(%1) for(int %1 = 0; %1 < GetArraySize(g_MapCoordinates); %1++)
// #define GetRandomMapSpawn(%1) for(int %1 = 0; %1 < )

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = "BOINK",
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = "https://github.com/b0ink/csgo-chaos-mod"
};

char mapName[64];

char 	g_Prefix[] = "[{lime}C H A O S{default}]";
char 	g_Prefix_EndChaos[] = "<<{darkred}Ended{default}>>";
char 	g_Prefix_MegaChaos[] = "\n<<{orange}C H A O S{default}>>";


// StringMap	Chaos_Effects;

#define SOUND_BELL "buttons/bell1.wav"
#define SOUND_BLIP "buttons/blip1.wav"
#define SOUND_COUNTDOWN "ui/beep07.wav"
#define SOUND_MONEY "survival/money_collect_04.wav"

#define DISTORTION "explosion_child_distort01b"
#define FLASH "explosion_child_core04b"
#define SMOKE "impact_dirt_child_smoke_puff"
#define DIRT "impact_dirt_child_clumps"
#define EXPLOSION_HE "weapons/hegrenade/explode5.wav"

#include "Data.sp"

Handle 	g_MapCoordinates = INVALID_HANDLE;
Handle 	g_UnusedCoordinates = INVALID_HANDLE;
Handle 	bombSiteA = INVALID_HANDLE;
Handle 	bombSiteB = INVALID_HANDLE;
bool 	g_bBombPlanted = false;

bool 	g_bCanSpawnChickens = true;
bool 	g_bPlayersCanDropWeapon = true;

float 	g_PlayerDeathLocations[MAXPLAYERS+1][3];

bool 	g_bCanSpawnEffect = true;

int 	g_iChaos_Round_Count = 0;
int 	g_iChaos_Round_Time = 0;

bool 	g_bMegaChaos = false;
char 	g_sSelectedChaosEffect[64] = "";
char 	g_sCustomEffect[64] = ""; //overrides g_sSelectedChaosEffect
char 	g_sLastPlayedEffect[64] = "";

bool 	g_bClearChaos = false;

Handle 	g_NewEffect_Timer = INVALID_HANDLE;
bool 	g_bPlaySound_Debounce = false;
bool 	g_bDisableRetryEffect = false;

Handle 	Effect_History = INVALID_HANDLE;
float 	g_OriginalSpawnVec[MAXPLAYERS+1][3];

bool 	g_DynamicChannel = false;

int ChaosMapCount = 0;


// Any variables shared by multiple plugins can be listed here
int g_bKnifeFight = 0;
int g_bNoStrafe = 0;
int g_AutoBunnyhop = 0;
int g_bNoForwardBack = 0;
int g_NoFallDamage = 0;
int g_iC4ChickenEnt = -1;

// Shared by multiple effects
#include "Global/InstantWeaponSwitch.sp"
#include "Global/WeaponJump.sp"
#include "Global/Fog.sp"
#include "Global/ColorCorrection.sp"
#include "Global/Weather.sp"

#include "Effects/EffectsList.sp"
#include "Effects/HookedEvents.sp"

#include "ConVars.sp"


int global_id_count = 0;
ArrayList alleffects;

enum struct effect{
	char 		title[64]; // 0th index for ease of sorting in configs.sp
	
	int 		id;

	char 		config_name[64];
	char 		description[64];
	
	int 		duration;
	bool		force_no_duration;
	bool		enabled;

	char 		function_name_start[64];
	char 		function_name_reset[64];
	
	Handle 		timer;

	void run_effect(){
		// PrintToChatAll("attempting to run!: %s for %i seconds", this.function_name_start, this.duration);
		Log("Running effect: %s", this.function_name_start);
		Function func = GetFunctionByName(GetMyHandle(), this.function_name_start);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish();

			float duration = this.Get_Duration(); 
			if(duration > 0) this.timer = CreateTimer(duration, Effect_Reset, this.id);
			

			char function_no_announce_check[64];
			Format(function_no_announce_check, sizeof(function_no_announce_check), "%s_CustomAnnouncement", this.config_name);
			Function announce = GetFunctionByName(GetMyHandle(), function_no_announce_check);

			bool custom_announce = false;
			if(announce != INVALID_FUNCTION){
				Call_StartFunction(GetMyHandle(), announce);
				Call_Finish(custom_announce);
			}

			if(!custom_announce){
				AnnounceChaos(this.title, this.Get_Duration());
			}
			g_sLastPlayedEffect = this.config_name;
			ChaosMapCount++;
		}
	}

	void reset_effect(bool EndChaos = false){
		// PrintToChatAll("attempting to emd!: %s ", this.function_name_reset);

		Function func = GetFunctionByName(GetMyHandle(), this.function_name_reset);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(EndChaos);
			Call_Finish();
		}
	}

	bool can_run_effect(){
		bool response = true;
		char condition_check[64];
		FormatEx(condition_check, sizeof(condition_check), "%s_Conditions", this.config_name);
		Function func = GetFunctionByName(GetMyHandle(), condition_check);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish(response);
		}
		return response;
	}

	void SET_NAME(char effect_name[64]){
		this.title = effect_name;
	}
	void SET_CONFIG_NAME(char effect_name[64]){
		this.config_name = effect_name;
	}
	void SET_DESCRIPTION(char effect_name[64]){
		this.description = effect_name;
	}
	void SET_DEFAULT_DURATION(int time){
		this.duration = time;
	}
	void SET_START_FUNCTION(char start_function[64]){
		this.function_name_start = start_function;
	}
	void SET_RESET_FUNCTION(char reset_function[64]){
		this.function_name_reset = reset_function;
	}
	float Get_Duration(bool raw = false){
		if(this.force_no_duration){
			return -1.0;
		}
		float OverwriteDuration = g_fChaos_OverwriteDuration;
		float duration = float(this.duration);
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
					Log("Incorrect duration set for %s. You set: %f, defaulting to: %f", this.config_name, duration, SanitizeTime(duration));
					duration = SanitizeTime(duration);
				}
			}
		}


		return duration;
	}
}


public Action Effect_Reset(Handle timer, int effect_id){
	effect foo;
	for(int i = 0; i < alleffects.Length; i++){
		alleffects.GetArray(i, foo, sizeof(foo));
		if(foo.id == effect_id){
			foo.reset_effect(true);
			break;
		}
	}
}



#include "Commands.sp"
#include "Hud.sp"
#include "Configs.sp"
#include "Menu.sp"


public void OnPluginStart(){
	
	LoadTranslations("chaos.phrases");
	
	CreateConVars();
	
	RegisterCommands();

	HookEvent("round_start", 	Event_RoundStart);
	HookEvent("round_end", 		Event_RoundEnd);	
	HookEvent("player_death", 	Event_PlayerDeath);	
	HookEvent("bomb_planted", 	Event_BombPlanted);
	HookEvent("server_cvar", 	Event_Cvar, 			EventHookMode_Pre);

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			OnClientPutInServer(i);
		}
	}

	Possible_Chaos_Effects = new ArrayList(1024);
	Effect_History = CreateArray(64);

	g_SavedConvars  = CreateArray(64);

	alleffects = new ArrayList(1024);

	HookEvents();
}




public void OnPluginEnd(){
	ResetCvar();
	ResetChaos();
}

public void OnMapStart(){
	UpdateCvars();

	CheckHostageMap();
	CreateTimer(1.0, Timer_DisplayEffects, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);

	UpdateCvars();

	GetCurrentMap(mapName, sizeof(mapName));
	Log("New Map/Plugin Restart - Map: %s", mapName);
	
	PrecacheSound(SOUND_BELL);
	PrecacheSound(SOUND_COUNTDOWN);
	PrecacheSound(SOUND_MONEY);
	PrecacheSound(SOUND_BLIP);

	PrecacheTextures();


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
	Overlay_INIT();

	Run_Init_Functions();

	cvar("sv_fade_player_visibility_farz", "1");

	StopTimer(g_NewEffect_Timer);
	g_NewEffect_Timer = INVALID_HANDLE;

	if(Effect_History != INVALID_HANDLE) ClearArray(Effect_History);

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
	g_DynamicChannel = LibraryExists("DynamicChannels");
	if(!g_DynamicChannel){
		Log("Could not find plugin 'DynamicChannels.smx'. To enable HUD text for Chaos effects and timers, install the 'DynamicChannels.smx' plugin from https://github.com/Vauff/DynamicChannels");
	}
}
 
public void OnLibraryRemoved(const char[] name){
    if (StrEqual(name, "DynamicChannels")){
        g_DynamicChannel = false;
    }
}
 
public void OnLibraryAdded(const char[] name){
    if (StrEqual(name, "DynamicChannels")){
        g_DynamicChannel = true;
    }
}

public void OnClientPutInServer(int client){
	WeaponJumpConnect_Handler(client);

	SDKHook(client, SDKHook_WeaponDrop, 		Hook_WeaponDrop);
	SDKHook(client, SDKHook_WeaponSwitch, 		Hook_WeaponSwitch);
	SDKHook(client, SDKHook_PreThink, 			Hook_OnPreThink);
	SDKHook(client, SDKHook_OnTakeDamage, 		Hook_OnTakeDamage);

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
	if(FindStringInArray(Effect_History, effect_name) != -1){
		found = true;
	}
	return found;
}

Action ChooseEffect(Handle timer = null, bool CustomRun = false){
	if(!CustomRun) g_NewEffect_Timer = INVALID_HANDLE;
	if(!g_bCanSpawnEffect) return;
	if(!g_bChaos_Enabled && !CustomRun) return;

	char Random_Effect[64] = "-";
	int randomEffect = -1;
	int attempts = 0;
	g_sLastPlayedEffect = "";

	g_bClearChaos = false;
	PoolChaosEffects();

	if(g_sCustomEffect[0]){ //run from menu
		// FormatEx(g_sSelectedChaosEffect, sizeof(g_sSelectedChaosEffect), "%s", g_sCustomEffect);
		effect foo;
		for(int i = 0; i < alleffects.Length; i++){
			alleffects.GetArray(i, foo, sizeof(foo));
			if(StrEqual(foo.config_name, g_sCustomEffect, false)){
				foo.run_effect();
				break;
			}
		}
	}else{
		effect new_effect;
		int totalEffects = alleffects.Length;
		
		while(!g_sLastPlayedEffect[0]){ // no longer
			attempts++;
			do{
				randomEffect = GetRandomInt(0, totalEffects - 1);
				alleffects.GetArray(randomEffect, new_effect, sizeof(new_effect));
				if(new_effect.enabled && new_effect.can_run_effect() && (!Effect_Recently_Played(new_effect.config_name) || CustomRun) && new_effect.timer == INVALID_HANDLE){
					Random_Effect = new_effect.config_name;
					new_effect.run_effect();
					PushArrayString(Effect_History, new_effect.config_name);

					float average = float((Possible_Chaos_Effects.Length / 4) * 3); //idk
					if(GetArraySize(Effect_History) > average) RemoveFromArray(Effect_History, 0);
				}

			}while(!Random_Effect[0]);
			if(attempts > 900){
				LogError("Clearing effect history");
				ClearArray(Effect_History); //fail safe
				break;
			}
		}
	}

	LogEffect(g_sLastPlayedEffect);

	PrintEffects();
	g_sCustomEffect  = "";
	if(g_bPlaySound_Debounce == false){
		//Prevent overlapping sounds
		g_bPlaySound_Debounce = true;
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				EmitSoundToClient(i, SOUND_BELL, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
			}
		}
		CreateTimer(0.2, Timer_ResetPlaySound);
	}

	if(CustomRun) return;

	StopTimer(g_NewEffect_Timer);
	bool Chaos_Repeating = g_bChaos_Repeating;

	if(Chaos_Repeating){
		float Effect_Interval = g_fChaos_EffectInterval;
		if(Effect_Interval > 60 || Effect_Interval < 5){
			Log("Cvar 'EffectInterval' Out Of Bounds. Resetting to 15 seconds - Chaos_Settings.cfg");
			Effect_Interval = 15.0;
		}
		g_NewEffect_Timer = CreateTimer(Effect_Interval, ChooseEffect);
		if(g_DynamicChannel){
			Timer_Display(null, RoundToFloor(Effect_Interval));
		}
		g_iChaos_Round_Count++;
	}
}

public Action Timer_ResetPlaySound(Handle timer){
	g_bPlaySound_Debounce = false;
}

//Used if there's no map data found for the map that renders the event useless
public void RetryEffect(){
	Log("RETRYING EVENT..");
	if(g_bDisableRetryEffect){
		Log("Retries are currently disabled.");
		return;
	}
	StopTimer(g_NewEffect_Timer);
	g_sCustomEffect = "";
	g_sSelectedChaosEffect = "";
	ChooseEffect(INVALID_HANDLE);
}

public Action ResetRoundChaos(Handle timer){
	RemoveChickens(false);
	Fog_OFF();

	effect foo;
	for(int i = 0; i < alleffects.Length; i++){
		alleffects.GetArray(i, foo, sizeof(foo));
		foo.reset_effect(false);
	}
}




#include "Events.sp"
#include "Hooks.sp"
#include "Helpers.sp"