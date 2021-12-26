#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <multicolors>
#include <cstrike>


//BOOLS ARE ALL FUCKED SO THEY NEED TO BE FIXED.


// Protection for SMAC users (aimbot).
#undef REQUIRE_PLUGIN
#include <smac>

#pragma newdecls required
#pragma semicolon 1


public Plugin myinfo =
{
	name = "CSGO Chaos Mod",
	author = "BOINK",
	description = "Every 15 seconds a random effect is played",
	version = "1.0.0",
	url = "https://github.com/diddims/csgo-chaos-mod"
};


char g_Prefix[] = ">>{lime}C H A O S{default}<<";
// char g_Prefix_EndChaos[] = "<<{darkred}C H A O S{default}>>";
// char g_Prefix_EndChaos[] = "<<{darkred}Expired{default}>>";
char g_Prefix_EndChaos[] = "<<{darkred}Ended{default}>>";
char g_Prefix_MegaChaos[] = "\n<<{orange}C H A O S{default}>>";

// char LOGS[] = "chaos_logs.txt";
// bool g_bChaosLoggingEnabled = true;


bool g_bCanSpawnEffect = true;
#define SOUND_BELL "buttons/bell1.wav"

#define CONFIG_ENABLED 0
#define CONFIG_EXPIRE 1


Handle g_MapCoordinates = INVALID_HANDLE;
Handle g_UnusedCoordinates = INVALID_HANDLE;
Handle bombSiteA = INVALID_HANDLE;
Handle bombSiteB = INVALID_HANDLE;
bool g_bBombPlanted = false;

void COORD_INIT() {g_UnusedCoordinates = CreateArray(3); }

bool g_bCanSpawnChickens = true;

char g_sWeapons[][64] = {
	"weapon_glock",
    "weapon_p250",
    "weapon_fiveseven",
    "weapon_deagle",
    "weapon_elite",
    "weapon_hkp2000",
    "weapon_tec9",

    "weapon_nova",
    "weapon_xm1014",
    "weapon_sawedoff",

    "weapon_m249",
    "weapon_negev",
    "weapon_mag7",

    "weapon_mp7",
    "weapon_ump45",
    "weapon_p90",
    "weapon_bizon",
    "weapon_mp9",
    "weapon_mac10",

    "weapon_famas",
    "weapon_m4a1",
    "weapon_aug",
    "weapon_galilar",
    "weapon_ak47",
    "weapon_sg556",

    "weapon_ssg08",
    "weapon_awp",
    "weapon_scar20",
    "weapon_g3sg1",

    // "weapon_taser",
    // "weapon_molotov",
    // "weapon_hegrenade"
};


char g_sSkyboxes[][] = {
	"cs_baggage_skybox_",
	"cs_tibet",
	"embassy",
	"italy",
	"jungle",
	"office",
	"sky_cs15_daylight01_hdr",
	"sky_cs15_daylight02_hdr",
	"sky_cs15_daylight03_hdr",
	"sky_cs15_daylight04_hdr",
	"sky_day02_05",
	"nukeblank",
	"sky_venice",
	"sky_csgo_cloudy01",
	"sky_csgo_night02",
	"sky_csgo_night02b",
	"vertigo",
	"vertigoblue_hdr",
	"sky_dust",
	"vietnam"
};


char playerModel_Path[][] = {
	"models/player/custom_player/legacy/tm_leet_varianti.mdl",
	"models/player/custom_player/legacy/tm_leet_variantg.mdl",
	"models/player/custom_player/legacy/tm_leet_variantg.mdl",
	"models/player/custom_player/legacy/tm_leet_varianth.mdl",
	"models/player/custom_player/legacy/tm_leet_varianti.mdl",
	"models/player/custom_player/legacy/tm_leet_variantf.mdl",
	"models/player/custom_player/legacy/tm_leet_variantj.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_varianta.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantb.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantc.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantd.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variante.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantf.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantb2.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantf2.mdl",
	"models/player/custom_player/legacy/tm_phoenix_varianth.mdl",
	"models/player/custom_player/legacy/tm_phoenix_variantf.mdl",
	"models/player/custom_player/legacy/tm_phoenix_variantg.mdl",
	"models/player/custom_player/legacy/tm_phoenix_varianti.mdl",
	"models/player/custom_player/legacy/tm_professional_varf.mdl",
	"models/player/custom_player/legacy/tm_professional_varg.mdl",
	"models/player/custom_player/legacy/tm_professional_varh.mdl",
	"models/player/custom_player/legacy/tm_professional_varj.mdl"
};

#include "Externals/instantweaponswitch.sp"
#include "Externals/weaponjump.sp"
#include "Externals/esp.sp"
#include "Externals/aimbotfull.sp"
#include "Externals/autoplant.sp"
#include "Externals/teleport.sp"
#include "Externals/chickenmodels.sp"
#include "Externals/explosivebullets.sp"
#include "Externals/simonsays.sp"
#include "Externals/drugs.sp"
#include "Externals/c4chicken.sp"



bool g_bPlayersCanDropWeapon = true;


int g_Offset_Clip1 = -1;

float g_RollbackPositions[MAXPLAYERS+1][10][3];
float g_RollbackAngles[MAXPLAYERS+1][10][3];

float g_PlayerDeathLocations[MAXPLAYERS+1][3];

bool g_bRewind_logging_enabled = true;

StringMap	Chaos_Effects;

int Chaos_Round_Count = 0;
bool g_bMegaChaos = false;
int g_iChaos_Event_Count = 0;
char g_sSelectedChaosEffect[64] = "";

bool g_bClearChaos = false;
bool g_bDecidingChaos = false;
int g_iRandomEvent = 0;
bool g_bCountingChaos = false;

ConVar g_cvChaosEnabled; bool g_bChaos_Enabled = true;
ConVar g_cvChaosEffectInterval; float g_fChaos_EffectInterval = 15.0;
ConVar g_cvChaosRepeating; bool g_bChaos_Repeating = true;
ConVar g_cvChaosOverwriteDuration; float g_fChaos_OverwriteDuration = -1.0;

void UpdateCvars(){
	g_bChaos_Enabled = g_cvChaosEnabled.BoolValue;
	g_fChaos_EffectInterval = g_cvChaosEffectInterval.FloatValue;
	g_bChaos_Repeating = g_cvChaosRepeating.BoolValue;
	g_fChaos_OverwriteDuration = g_cvChaosOverwriteDuration.FloatValue;
}

//future todo: 	int iEntity = EntRefToEntIndex(iRef); EntIndexToEntRef for all entities
public void OnPluginStart(){
	
	g_cvChaosEnabled = CreateConVar("sm_chaos_enabled", "1", "Sets whether the Chaos plugin is enabled", _, true, 0.0, true, 1.0);
	g_cvChaosEffectInterval = CreateConVar("sm_chaos_interval", "15.0", "Sets the interval for Chaos effects to run", _, true, 5.0, true, 60.0);
	g_cvChaosRepeating = CreateConVar("sm_chaos_repeating", "1", "Sets whether effects will continue to spawn after the first one of the round", _, true, 0.0, true, 1.0);
	g_cvChaosOverwriteDuration = CreateConVar("sm_chaos_overwrite_duration", "-1", "Sets the duration for ALL effects, use -1 to use Chaos_Effects.cfg durations, use 0.0 for no expiration.", _, true, -1.0, true, 120.0);

	UpdateCvars();
	
	HookConVarChange(g_cvChaosEnabled, ConVarChanged);
	HookConVarChange(g_cvChaosEffectInterval, ConVarChanged);
	HookConVarChange(g_cvChaosRepeating, ConVarChanged);
	HookConVarChange(g_cvChaosOverwriteDuration, ConVarChanged);

	HookEvent("round_start", 	Event_RoundStart);
	HookEvent("round_end", 		Event_RoundEnd);	
	HookEvent("player_death", 	Event_PlayerDeath);	
	HookEvent("weapon_fire", 	Event_OnWeaponFirePost, EventHookMode_Post);
	HookEvent("bomb_planted", 	Event_BombPlanted);
	HookEvent("bullet_impact", 	Event_BulletImpact);

	AddTempEntHook("Shotgun Shot", Hook_BulletShot);

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			OnClientPutInServer(i);
		}
	}

	Chaos_Effects = new StringMap();

	ESP_INIT();
	TEAMMATESWAP_INIT();
	COORD_INIT();
	NOSCOPE_INIT();
	AUTOPLANT_INIT();
	EXPLOSIVEBULLETS_INIT();
	DRUGS_INIT();

	RegAdminCmd("chaos_refreshconfig", Command_RefreshConfig, ADMFLAG_BAN);
	RegAdminCmd("chaos_debug", Command_ChaosDebug, ADMFLAG_BAN);

	RegAdminCmd("sm_chaos", Command_NewChaosEffect, ADMFLAG_BAN);
	RegAdminCmd("sm_startchaos", Command_StartChaos, ADMFLAG_BAN);
	RegAdminCmd("sm_stopchaos", Command_StopChaos, ADMFLAG_BAN);


	g_Offset_Clip1 = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");

	CreateTimer(1.0, Rollback_Log, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);

}


Handle g_NewEvent_Timer = INVALID_HANDLE;
bool g_bPlaySound_Debounce = false;
bool g_bDisableRetryEvent = false;

public void ConVarChanged(ConVar convar, char[] oldValue, char[] newValue){
	if(convar == g_cvChaosEnabled){
		if(StringToInt(oldValue) == 0 && StringToInt(newValue) == 1){
			g_bChaos_Enabled = true;
			DecideEvent(null);
		}else if(StringToInt(newValue) == 0){
			g_bChaos_Enabled = false;
			StopTimer(g_NewEvent_Timer);
		}
	}else if(convar == g_cvChaosEffectInterval){
		g_fChaos_EffectInterval = StringToFloat(newValue);
		if(g_fChaos_EffectInterval < 5.0){
			PrintToChatAll("[SM] Convar \"chaos_interval\" Out Of Bounds. Min. 5.0.");
		}
	}else if(convar == g_cvChaosRepeating){
		if(StringToInt(oldValue) == 1 && StringToInt(newValue) == 0){
			g_bChaos_Repeating = false;
			StopTimer(g_NewEvent_Timer);
		}else if(StringToInt(newValue) == 1){
			g_bChaos_Repeating = true;
		}
	} else if(convar == g_cvChaosOverwriteDuration){
		g_fChaos_OverwriteDuration = StringToFloat(newValue); 
	}
}


public Action Command_NewChaosEffect(int client, int args){
	if(args > 1){
		ReplyToCommand(client, "Usage: sm_chaos <Effect Name (optional)>");
		return Plugin_Handled;
	}
	char effectName[64];
	GetCmdArg(1, effectName, sizeof(effectName));

	g_bDisableRetryEvent = true;
	if(g_bCanSpawnEffect){
		if(args == 1){
			if(strlen(effectName) >=3){
					g_sSelectedChaosEffect = effectName;
					g_bDecidingChaos = true;
					g_bClearChaos = false;
					Chaos();
				
			}else{
				ReplyToCommand(client, "Please provide atleast 3 characters."); //todo, filter around random characters (NOT UNDERSCORES)
				return Plugin_Handled;
			}
		}else{
			DecideEvent(null, true);
		}
	}else{
		ReplyToCommand(client, "You can't spawn new effects right now, please wait until the round starts.");
		return Plugin_Handled;
	}

	CreateTimer(1.0, Command_ReEnableRetries);
	g_sSelectedChaosEffect = "";
	return Plugin_Handled;
}
public Action Command_ReEnableRetries(Handle timer){
	g_bDisableRetryEvent = false;
}

public Action Command_StopChaos(int client, int args){
	g_bChaos_Enabled = false;
	StopTimer(g_NewEvent_Timer);
	g_bClearChaos = true;
	g_iChaos_Event_Count = 0;
	g_bDecidingChaos = false;
	g_bCountingChaos = false;
	Chaos(); //count and reset all chaos
	AnnounceChaos("Chaos is Disabled!", true);
	return Plugin_Handled;
}

public Action Command_StartChaos(int client, int args){

	if(g_NewEvent_Timer == INVALID_HANDLE){
		g_bClearChaos = true;
		g_iChaos_Event_Count = 0;
		g_bDecidingChaos = false;
		g_bCountingChaos = true;
		Chaos();
		CreateTimer(0.1, DecideEvent, _, TIMER_FLAG_NO_MAPCHANGE);
		AnnounceChaos("Chaos is Enabled!");
	}else{
		PrintToChat(client, "Chaos is already running!");
	}
	g_bChaos_Enabled = true;
	// StopTimer(g_NewEvent_Timer);
	return Plugin_Handled;
}

bool g_bChaos_Debug = false;
public Action Command_ChaosDebug(int client, int args){
	if(!g_bChaos_Debug){
		cvar("mp_freezetime", "2");
		cvar("mp_round_restart_delay", "2");
	}else{
		cvar("mp_freezetime", "15");
		cvar("mp_round_restart_delay", "7");
	}
	g_bChaos_Debug = !g_bChaos_Debug;
	return Plugin_Handled;
}

public void OnConfigsExecuted(){
	ParseMapCoordinates();
	ParseChaosEffects();
}



//TODO weapon jump disocnnect?

public void OnClientPutInServer(int client){
	WeaponJumpConnect_Handler(client);

	SDKHook(client, SDKHook_WeaponDrop, 		Hook_WeaponDrop);
	SDKHook(client, SDKHook_WeaponSwitch, 		Hook_WeaponSwitch);
	SDKHook(client, SDKHook_PreThink, 			Hook_OnPreThink);
	SDKHook(client, SDKHook_OnTakeDamage, 		Hook_OnTakeDamage);
	SDKHook(client, SDKHook_OnTakeDamagePost, 	Hook_OnTakeDamagePost);
}

public void OnClientDisconnect(int client){
	ToggleAim(client, false);
	WeaponJumpDisconnect_Handler(client);
}


//TODO move these into functions in another script that can be called on map start
int FogIndex = -1;
int g_randomCache[18];

float g_OriginalSpawnVec[MAXPLAYERS+1][3];


#include "EffectsHandler.sp"


public void OnMapStart(){

	UpdateCvars();

	char mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	char string[128];
	FormatEx(string, sizeof(string), "New Map/Plugin Restart - Map: %s", mapName);
	Log(string);
	PrecacheSound(SOUND_BELL);
	// PrecacheModel("props_c17/oildrum001_explosive.mdl");

	for(int i = 0; i < sizeof(g_randomCache); i++) g_randomCache[i] = -1;
	PrecacheTextures();
	if(g_MapCoordinates != INVALID_HANDLE) ClearArray(g_MapCoordinates);
	if(bombSiteA != INVALID_HANDLE) ClearArray(bombSiteA);
	if(bombSiteB != INVALID_HANDLE) ClearArray(bombSiteB);

	g_MapCoordinates = INVALID_HANDLE;
	bombSiteA = INVALID_HANDLE;
	bombSiteB = INVALID_HANDLE;

	

	//mamybe some chaos can have a g_mapstart shit to keep it all together
	findLight();

	//testing purposes

	cvar("sv_fade_player_visibility_farz", "1");

	//fixes an issue with shields not working in comp gamemode
	CreateTimer(5.0, Timer_CreateHostage);
	StopTimer(g_NewEvent_Timer);
	g_NewEvent_Timer = INVALID_HANDLE;
}
public void OnMapEnd(){
	Log("Map has ended.");
	StopTimer(g_NewEvent_Timer);
}
//Todo; shields still dont work
Action Timer_CreateHostage(Handle timer = null){
	if (FindEntityByClassname(-1, "func_hostage_rescue") == -1){
		CreateEntityByName("func_hostage_rescue");
    }
}





void CountChaos(bool Reset = false){
	if(Reset) g_bClearChaos = true;
	g_iChaos_Event_Count = 0;
	g_bDecidingChaos = false;
	g_bCountingChaos = true;
	Chaos();
}


//done maybe; hold a cache of the last 10 (or more) events, and continue to randomise it 100 times until its one is found thats not inside the cache
//during a round, each event can be saved to a cache
	//so a 1:55 minute round is about 7 chaos events, those 7 chaos events get saved to a cache that can't be used in the next round.
	//every few rounds reset the cache so the combinations can be re mixed
bool findInArray(int[] array, int target, int arraysize){
	bool found = false;
	for(int i = 0; i < arraysize; i++) if(array[i] == target) found = true;
	if(found) return true;
	return false;
}



Action DecideEvent(Handle timer, bool CustomRun = false){
	if(!CustomRun) g_NewEvent_Timer = INVALID_HANDLE;
	if(!g_bCanSpawnEffect) return;
	if(!g_bChaos_Enabled && !CustomRun) return;
	CountChaos();
	
	int index = sizeof(g_randomCache) - 1;
	while(index >= 1){
		g_randomCache[index] = g_randomCache[index - 1];
		index--;
	}


	g_iRandomEvent = GetRandomInt(1, g_iChaos_Event_Count);
	if(g_iChaos_Event_Count > sizeof(g_randomCache)-1){
		// while(g_iRandomEvent == g_Previous_Chaos_Event && findInArray(g_randomCache, g_iRandomEvent, sizeof(g_randomCache))){
		while(findInArray(g_randomCache, g_iRandomEvent, sizeof(g_randomCache))){
			g_iRandomEvent = GetRandomInt(1,g_iChaos_Event_Count);
		}
	}
	// g_Previous_Chaos_Event = g_iRandomEvent; //redundant, scheduled to be removed;
	g_randomCache[0] = g_iRandomEvent;
	// PrintToChatAll("The chaos event count is %i",g_iChaos_Event_Count);
	// PrintToConsoleAll("The chaos event count is %i",g_iChaos_Event_Count);
	// CPrintToChatAll("Event was %i", g_iRandomEvent);
	g_bDecidingChaos = true;
	g_bClearChaos = false;
	g_iChaos_Event_Count = 0;
	g_bCountingChaos = true;
	Chaos(); //run the chaos

	if(g_bPlaySound_Debounce == false){
		//sometimes this function runs 5 times at once to find a new chaos, this prevents it from being played more than once
		g_bPlaySound_Debounce = true;
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				EmitSoundToClient(i, SOUND_BELL, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
			}
		}
		CreateTimer(0.2, Timer_ResetPlaySound);
	}
	if(CustomRun) return;

	StopTimer(g_NewEvent_Timer);
	bool Chaos_Repeating = g_bChaos_Repeating;

	if(Chaos_Repeating){
		float Effect_Interval = g_fChaos_EffectInterval;
		if(Effect_Interval > 60 || Effect_Interval < 5){
			Log("Cvar 'EffectInterval' Out Of Bounds. Resetting to 15 seconds - Chaos_Settings.cfg");
			Effect_Interval = 15.0;
		}

		g_NewEvent_Timer = CreateTimer(Effect_Interval, DecideEvent);
		// g_NewEvent_Timer = CreateTimer(float(Effect_Interval), DecideEvent);
		Chaos_Round_Count++;
	}
}

public Action Timer_ResetPlaySound(Handle timer){
	g_bPlaySound_Debounce = false;
}

public void RetryEvent(){ //Used if there's no map data found for the map that renders the event useless
	Log("RETRYING EVENT..");
	if(g_bDisableRetryEvent) return;
	StopTimer(g_NewEvent_Timer);
	DecideEvent(INVALID_HANDLE);
}


public Action ResetRoundChaos(Handle timer){
	RemoveChickens(false);
	AcceptEntityInput(FogIndex, "TurnOff");

	g_bClearChaos = true;
	g_bDecidingChaos = false;
	g_bCountingChaos = false;
	Chaos();
}



//todo: dealing with players who joing after the round starts.
/*
	- this would affect the resetspawn chaos, where their initial spawn doesnt save.


*/


bool ValidMapPoints(){
	if(g_MapCoordinates == INVALID_HANDLE) return false;
	return true;
}

bool CountingCheckDecideChaos(){
	if(g_bCountingChaos) {	g_iChaos_Event_Count++;	if(!g_bDecidingChaos) {  return true;  }}
	return false;
}

bool DecidingChaos(char[] EffectName = ""){
	//if effectname was provided manually, 
	if(EffectName[0] && g_sSelectedChaosEffect[0]){
		if(!g_bDecidingChaos
					|| ((StrContains(g_sSelectedChaosEffect, EffectName, false) == -1) 
					&& (StrContains(EffectName, g_sSelectedChaosEffect, false) == -1))){
						return true;
					}else{
						CreateTimer(0.5, Timer_ResetCustomChaosSelection);
						return false;
					}
	}
	if(g_bClearChaos || !g_bDecidingChaos || (g_iChaos_Event_Count != g_iRandomEvent)) return true;
	return false;
}
//currently a hotfix but there is a bool value somewhere that handles the custom selection just fine.. todo for another time.
public Action Timer_ResetCustomChaosSelection(Handle timer){
	g_sSelectedChaosEffect = "";
}
bool ClearChaos(bool EndChaos = false){
	if(g_bClearChaos || EndChaos) return true;
	return false;
}



bool IsChaosEnabled(char[] EffectName, int defaultEnable = 1){
	if(g_bClearChaos) return true;
	int Chaos_Properties[2];
	int enabled = 0;
	if(Chaos_Effects.GetArray(EffectName, Chaos_Properties, 2)){
		enabled = Chaos_Properties[CONFIG_ENABLED];
	}else{
		Log("[CONFIG] Couldnt find Effect Configuration: %s", EffectName);
		enabled = defaultEnable;
	}
	if(enabled == 1) return true;
	return false;
}

float GetChaosTime(char[] EffectName, float defaultTime = 15.0){
	float OverwriteDuration = g_fChaos_OverwriteDuration;
	if(OverwriteDuration < -1.0){
		Log("Cvar 'OverwriteEffectDuration' set Out Of Bounds in Chaos_Settings.cfg, effects will use their durations in Chaos_Effects.cfg");
		OverwriteDuration = - 1.0;
	}

	int Chaos_Properties[2];
	float expire = defaultTime;
	if(Chaos_Effects.GetArray(EffectName, Chaos_Properties, 2)){
		if(OverwriteDuration == -1.0){
			expire = float(Chaos_Properties[CONFIG_EXPIRE]);
		}else{
			expire = OverwriteDuration;
		}
		if(expire < 0){
			//this should imply that per the config, it doesnt exist, lets provide it the plugins default time instead, just in case it does use it.
			expire = defaultTime;
			expire = SanitizeTime(expire);
		}else{
			if(expire != SanitizeTime(expire)){
				Log("Incorrect duration set for %s. You set: %f, defaulting to: %f", EffectName, expire, SanitizeTime(expire));
				expire = SanitizeTime(expire);
			}
		}
	
	}else{
		Log("[CONFIG] Could not find configuration for Effect: %s, using default of %f", EffectName, defaultTime);
	}

	return expire;
}

#include "Effects.sp"

public void OnGameFrame(){
	if(g_bLockPlayersAim_Active){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				TeleportEntity(i, NULL_VECTOR, g_LockPlayersAim_Angles[i], NULL_VECTOR);
			}
		}
	}
}

//use gameframe for rollbacklog?
public Action Rollback_Log(Handle Timer){
	if(g_bRewind_logging_enabled){
		for(int client = 0; client <= MaxClients; client++){
			if(ValidAndAlive(client)){
				// PrintToChatAll("saving log for %N", client);
				int count = 9;
				while(count >= 1){
					g_RollbackPositions[client][count] = g_RollbackPositions[client][count - 1];
					g_RollbackAngles[client][count] = g_RollbackAngles[client][count - 1];
					count--;
				}
				float location[3];
				GetClientAbsOrigin(client, location);
				float angles[3];
				GetClientEyeAngles(client, angles);
				// PrintToConsole(client, "LOGGING: setpos %f %f %f; setang %f %f %f",
				// 	location[0],location[1],location[2],
				// 	angles[0], angles[1], angles[2]);
				g_RollbackPositions[client][0] = location;
				g_RollbackAngles[client][0] = angles;
				// PrintToConsole(client, "CONFIRM:setpos %f %f %f; setangs %f %f %f;", g_RollbackPositions[client][0][0], g_RollbackPositions[client][0][1], g_RollbackPositions[client][0][2], g_RollbackAngles[client][0][0], g_RollbackAngles[client][0][1],g_RollbackAngles[client][0][2]);

				// PrintToChatAll("saving for: %N loc: %f %f %f, angles: %f %f %f", client, 
				// 	location[0],location[1],location[2],
				// 	angles[0], angles[1], angles[2]);
			}
		}
	}
}

Handle g_Chaos_Rewind_Timer = INVALID_HANDLE;
void Chaos_RewindTenSeconds(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
		g_bRewind_logging_enabled = true;
		StopTimer(g_Chaos_Rewind_Timer);
	}
	if(DecidingChaos("Chaos_RewindTenSeconds")) return;
	Log("[Chaos] Running: Chaos_RewindTenSeconds");
	g_bRewind_logging_enabled = false;
	AnnounceChaos("Rewind 10 seconds");
	int time = 0;
	g_Chaos_Rewind_Timer = CreateTimer(0.1, Rewind_Timer, time);
}

public Action Rewind_Timer(Handle timer, int time){
	if(time <= 9){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				float loc[3];
				float angles[3];
				loc = g_RollbackPositions[i][time];
				angles =  g_RollbackAngles[i][time];
				// PrintToConsole(i, "TIME: %i setpos %f %f %f; setangs %f %f %f;", time, g_RollbackPositions[i][time][0], g_RollbackPositions[i][time][1], g_RollbackPositions[i][time][2], g_RollbackAngles[i][time][0], g_RollbackAngles[i][time][1],g_RollbackAngles[i][time][2]);
				TeleportEntity(i, loc, angles, NULL_VECTOR);
			}
		}
	}

	if(time <  9){
		time++;
		StopTimer(g_Chaos_Rewind_Timer);
		g_Chaos_Rewind_Timer = CreateTimer(0.3, Rewind_Timer, time);
	}else{
		TeleportPlayersToClosestLocation(); //fail safe todo: this is still bugged (the rewind part not this <<--)
		g_bRewind_logging_enabled = true;
		StopTimer(g_Chaos_Rewind_Timer);
	}
}
// g_RollbackPositions[client][count] = g_RollbackPositions[client][count - 1];
				// g_RollbackAngles[client][count] = g_RollbackAngles[client][count - 1];


//todo: create reset timers in a function?
// public void ResetChaosTimer(Handle &timer, Function &chaosfunction, float duration){
//todo: this wont work just yet, but if i add custom effect player eg. "!chaos Chaos_DiscoPlayers",
//		then i might be able to reset all the specific chaos by passing through a string function name isntead of the function itself.
//		then a function to call chaos, passing through a clearchaos with the function name

// public void ResetChaosTimer(Handle &timer, any &chaosfunction, float duration){
// 	if(duration > 0) timer = CreateTimer(duration, chaosfunction, true, TIMER_FLAG_NO_MAPCHANGE);
// }
//
// ResetChaosTimer(DiscoPlayers_Timer, Chaos_DiscoPlayers, DiscoPlayers_Duration);
















//todo move sdkhooks into their own file








float g_AllPositions[MAXPLAYERS+1][3];


void  DoRandomTeleport(int client = -1){
	Log("[Chaos] Running: DoRandomTeleport (function, not chaos event)");

	// if(g_MapCoordinates == INVALID_HANDLE) return false;

	ClearArray(g_UnusedCoordinates);

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		float vec[3];
		GetArrayArray(g_MapCoordinates, i, vec);
		PushArrayArray(g_UnusedCoordinates, vec);
	}
	if(client == -1){
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i) && IsPlayerAlive(i) && GetArraySize(g_UnusedCoordinates) > 0){
				int randomCoord = GetRandomInt(0, GetArraySize(g_UnusedCoordinates)-1);
				float vec[3];
				GetArrayArray(g_UnusedCoordinates, randomCoord, vec);
				TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
				PrintToConsole(i, "%N to %f %f %f", i, vec[0], vec[1], vec[2]);
				RemoveFromArray(g_UnusedCoordinates, randomCoord);
			}
		}
	}else{
		int randomCoord = GetRandomInt(0, GetArraySize(g_UnusedCoordinates)-1);
		float vec[3];
		GetArrayArray(g_UnusedCoordinates, randomCoord, vec);
		TeleportEntity(client, vec, NULL_VECTOR, NULL_VECTOR);
		PrintToConsole(client, "%N to %f %f %f", client, vec[0], vec[1], vec[2]);
		RemoveFromArray(g_UnusedCoordinates, randomCoord);
	}
}


void StopTimer(Handle &timer){
	if(timer != INVALID_HANDLE){
		KillTimer(timer);
		timer = INVALID_HANDLE;
	}
}



// public void Chaos_BouncyAir(){ //? todo
// 	if(CountingCheckDecideChaos()) return;
// 	// if(g_bClearChaos){}
// 	if(DecidingChaos()) return;
// 	//every .1 second alternate the gravity
// }




float mapFogStart = 0.0;
float mapFogEnd = 0.0;
// float mapFogEnd = 175.0;
float mapFogDensity = 0.995;
void findLight(){
	int ent;
	ent = FindEntityByClassname(-1, "env_fog_controller");
	if (ent != -1) {
		FogIndex = ent;
		DispatchKeyValue(FogIndex, "fogblend", "0");
		DispatchKeyValue(FogIndex, "fogcolor", "255 255 255");
		// DispatchKeyValue(FogIndex, "fogcolor", "255 0 0");
		DispatchKeyValue(FogIndex, "fogcolor2", "0 0 0");
		DispatchKeyValueFloat(FogIndex, "fogstart", mapFogStart);
		DispatchKeyValueFloat(FogIndex, "fogend", mapFogEnd);
		DispatchKeyValueFloat(FogIndex, "fogmaxdensity", mapFogDensity);
		AcceptEntityInput(FogIndex, "TurnOff");
    }
	else{
        FogIndex = CreateEntityByName("env_fog_controller");
        DispatchSpawn(FogIndex);
    }
}








// void DoFog(){
//     if(FogIndex != -1){
//         // DispatchKeyValue(FogIndex, "fogblend", "0");
//         // DispatchKeyValue(FogIndex, "fogcolor", "0 0 0");
//         // DispatchKeyValue(FogIndex, "fogcolor2", "0 0 0");
//         // DispatchKeyValueFloat(FogIndex, "fogstart", mapFogStart);
//         // DispatchKeyValueFloat(FogIndex, "fogend", mapFogEnd);
//         // DispatchKeyValueFloat(FogIndex, "fogmaxdensity", mapFogDensity);
//         DispatchKeyValueFloat(FogIndex, "farz", 250.0);
//     }
// }





bool CreateParticle(char []particle, float[3] vec){
	int ent = CreateEntityByName("info_particle_system");
	DispatchKeyValue(ent , "start_active", "0");
	DispatchKeyValue(ent, "effect_name", particle);
	TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
	DispatchSpawn(ent);
	ActivateEntity(ent);
	AcceptEntityInput(ent, "Start");
	return true;
}





#include "Hooks.sp"
#include "Events.sp"





///stuff
void ParseMapCoordinates() {
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/Chaos_Locations.cfg");
	// if(!FileExists(path)) SetFailState("Config file %s is not found", path);
	if(!FileExists(path)) return;
	
	char MapName[128];
	GetCurrentMap(MapName, sizeof(MapName));

	KeyValues kv = new KeyValues("Maps");

	if(!kv.ImportFromFile(path)){
		Log("Unable to parse Key Values from %s", path);
		// SetFailState("Unable to parse Key Values from %s", path);
		return;
	}
	//jump to key of map name
	if(!kv.JumpToKey(MapName)){
		Log("Unable to find %s Key from %s", MapName, path);
		// SetFailState("Unable to find %s Key from %s", MapName, path);
		return;
	}

	if(!kv.GotoFirstSubKey(false)){
		Log("Unable to find sub keys %s", path);
		// SetFailState("Unable to find sub keys %s", path);
		return;
	}
	g_MapCoordinates = CreateArray(3);
	bombSiteA = CreateArray(3);
	bombSiteB = CreateArray(3);
	//all keys are fine to go in the all map coordinates, but we ALSO want to add bombA and bombB to respective handles; 
	do{
		float vec[3];
		kv.GetVector(NULL_STRING, vec);
		// PrintToChatAll("FLOAT: %f %f %f", vec[0], vec[1], vec[2]);
		char key[25];
		kv.GetSectionName(key, sizeof(key));
		// PrintToChatAll("Key name: %s", key);
		if(strcmp(key, "bombA", false) == 0) PushArrayArray(bombSiteA, vec);
		if(strcmp(key, "bombB", false) == 0) PushArrayArray(bombSiteB, vec);
		PushArrayArray(g_MapCoordinates, vec);
	} while(kv.GotoNextKey(false));

	delete kv;
}




//HELPERS
public void cvar(char[] cvarname, char[] value){
	ConVar hndl = FindConVar(cvarname);
	if (hndl != null) hndl.SetString(value, true);
}

void StripPlayer(int client, bool knife = true, bool keepBomb = true, bool stripGrenadesOnly = false, bool KeepGrenades = false)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		int iTempWeapon = -1;
		for (int j = 0; j < 5; j++)
			if ((iTempWeapon = GetPlayerWeaponSlot(client, j)) != -1)
			{
				if(!stripGrenadesOnly){
					if (j == 2 && knife) //keep knife
						continue;
					if(j == 4 && keepBomb) //keep bomb
						continue;
					if(j == 3 && KeepGrenades) continue;
					if (IsValidEntity(iTempWeapon))
						RemovePlayerItem(client, iTempWeapon);
				}
				if(stripGrenadesOnly && !KeepGrenades){
					if(j==3)
						RemovePlayerItem(client, iTempWeapon);
				}
			}
	}
}


//stocks
stock bool IsValidClient(int client, bool nobots = true)
{
    if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client))) {
        return false;
    }
    return IsClientInGame(client);
}
stock bool ValidAndAlive(int client){
	return (IsValidClient(client) && IsPlayerAlive(client) && (GetClientTeam(client) == CS_TEAM_CT || GetClientTeam(client) == CS_TEAM_T));
}

void DisplayCenterTextToAll(const char[] message)
{
	char finalMess[128];
	
	Format(finalMess, sizeof(finalMess), "%s", message);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
			continue;
		}
		ReplaceString(finalMess, sizeof(finalMess),"{lightred}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{lightblue}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{lightgreen}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{olive}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{grey}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{yellow}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{bluegrey}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{orchid}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{lightred2}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{purple}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{lime}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{orange}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{red}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{blue}","", false); 
		ReplaceString(finalMess, sizeof(finalMess),"{darkred}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{darkblue}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{default}","", false);
		ReplaceString(finalMess, sizeof(finalMess),"{green}","", false);
		
		PrintCenterText(i, "%s", finalMess);
	}
}

void AnnounceChaos(char[] message, bool endingChaos = false, bool megaChaos = false){
	char announcingMessage[128];
	if(megaChaos){
		DisplayCenterTextToAll(message);
		Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix_MegaChaos, message);
	}else if(endingChaos){
		Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix_EndChaos, message);
	}else{
		DisplayCenterTextToAll(message);
		Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix, message);
	}
	CPrintToChatAll(announcingMessage);
}


// UserMessageId for Fade.
UserMsg g_FadeUserMsgId;
void PerformBlind(int target, int amount)
{
	int targets[2];
	targets[0] = target;
	
	int duration = 1536;
	int holdtime = 1536;
	int flags;
	if (amount == 0)
	{
		flags = (0x0001 | 0x0010);
	}
	else
	{
		flags = (0x0002 | 0x0008);
	}
	
	int color[4] = { 0, 0, 0, 0 };
	color[3] = amount;
	g_FadeUserMsgId = GetUserMessageId("Fade");
	
	// Handle message = StartMessageEx(g_FadeUserMsgId, targets, 1);
	Handle message = StartMessageEx(g_FadeUserMsgId, targets, 1);
	if (GetUserMessageType() == UM_Protobuf)
	{
		Protobuf pb = UserMessageToProtobuf(message);
		pb.SetInt("duration", duration);
		pb.SetInt("hold_time", holdtime);
		pb.SetInt("flags", flags);
		pb.SetColor("clr", color);
	}
	else
	{
		BfWrite bf = UserMessageToBfWrite(message);
		bf.WriteShort(duration);
		bf.WriteShort(holdtime);
		bf.WriteShort(flags);		
		bf.WriteByte(color[0]);
		bf.WriteByte(color[1]);
		bf.WriteByte(color[2]);
		bf.WriteByte(color[3]);
	}
	
	EndMessage();

}


stock bool SetClientMoney(int client, int money, bool absolute = false)
{
	//https://forums.alliedmods.net/showthread.php?t=291218
	if(IsValidClient(client)){
		if(absolute){
			SetEntProp(client, Prop_Send, "m_iAccount", money);
		}else{
			SetEntProp(client, Prop_Send, "m_iAccount", GetEntProp(client, Prop_Send, "m_iAccount")+money);
		}
		int entity = CreateEntityByName("game_money");
		if(entity != INVALID_ENT_REFERENCE){
			DispatchKeyValue(entity, "AwardText", "");
			DispatchSpawn(entity);
			SetVariantInt(0);
			AcceptEntityInput(entity, "SetMoneyAmount");
			SetVariantInt(client);
			AcceptEntityInput(entity, "AddMoneyPlayer");
			AcceptEntityInput(entity, "Kill");
			return true;
		}
		
		return false;
	}else{
		return false;
	}
} 

bool g_bRemovechicken_debounce = false;
void RemoveChickens(bool removec4Chicken = false){
	if(!g_bRemovechicken_debounce){
		Log("[Chaos] > Removing Chickens");
		g_bRemovechicken_debounce = true;
		int iMaxEnts = GetMaxEntities();
		char sClassName[64];
		for(int i=MaxClients;i<iMaxEnts;i++){
			if(IsValidEntity(i) && 
			IsValidEdict(i) && 
			GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
			StrEqual(sClassName, "chicken")
			&& GetEntPropEnt(i, Prop_Send, "m_hOwnerEntity") == -1
			)
			{
			
				if(removec4Chicken){
					if(i == g_iC4ChickenEnt){
						// RemoveEdict(i);
						RemoveEntity(i);
					}
				}else{
					if(i != g_iC4ChickenEnt){
						SetEntPropFloat(i, Prop_Data, "m_flModelScale", 1.0);
						RemoveEntity(i);
					}
				}

			}
		}
		CreateTimer(5.0, timer_resetchickendebounce);
	}

}  

public Action timer_resetchickendebounce(Handle timer){
	g_bRemovechicken_debounce = false;
}
public void ResizeChickens(){
    int iMaxEnts = GetMaxEntities();
    char sClassName[64];
    for(int i=MaxClients;i<iMaxEnts;i++){
        if(IsValidEntity(i) && 
           IsValidEdict(i) && 
           GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
           StrEqual(sClassName, "chicken") &&
           GetEntPropEnt(i, Prop_Send, "m_hOwnerEntity") == -1)
        {
			SetEntPropFloat(i, Prop_Data, "m_flModelScale", 1.0);
        }
    }
}  



stock void SetClip(int weaponid,int ammosize, int clipsize) {
    SetEntData(weaponid, g_Offset_Clip1, ammosize);
    SetEntProp(weaponid, Prop_Send, "m_iPrimaryReserveAmmoCount", clipsize);
}

stock int GetAliveTCount(){
	int count = 0;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_T){
			count++;
		}
	}
	return count;
}

stock int GetAliveCTCount(){
	int count = 0;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_CT){
			count++;
		}
	}
	return count;
}


float SanitizeTime(float time){
	if(time <= 0) return 0.0;
	if(time < 5) return 5.0;
	if(time > 120) return 0.0;
	return time;
}


void GetWeaponClassname(int weapon, char[] buffer, int size) {
	switch(GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex")) {
		case 60: Format(buffer, size, "weapon_m4a1_silencer");
		case 61: Format(buffer, size, "weapon_usp_silencer");
		case 63: Format(buffer, size, "weapon_cz75a");
		case 64: Format(buffer, size, "weapon_revolver");
		default: GetEntityClassname(weapon, buffer, size);
	}
}

void SavePlayersLocations(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			GetClientAbsOrigin(i, g_AllPositions[i]);
		}
	}
}

//make sure to SavePlayersLocations before using this.
float no_vel[3] = {0.0, 0.0, 0.0};

void TeleportPlayersToClosestLocation(int client = -1, int minDist = 0){
	if(g_MapCoordinates != INVALID_HANDLE){
		ClearArray(g_UnusedCoordinates);

		for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			PushArrayArray(g_UnusedCoordinates, vec);
		}

		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i) && IsPlayerAlive(i)){
				if(client != -1 && client != i) continue; //only set specific player
				int CoordinateIndex = -1;
				float DistanceToBeat = 99999.0;
				if(GetArraySize(g_UnusedCoordinates) > 0){
					float playersVec[3];
					GetClientAbsOrigin(i, playersVec);
					for(int coord = 0; coord <= GetArraySize(g_UnusedCoordinates)-1; coord++){
						float vec[3];
						GetArrayArray(g_UnusedCoordinates, coord, vec);
						float dist = GetVectorDistance(playersVec, vec);
						if((dist < DistanceToBeat) && dist >= minDist){
							CoordinateIndex = coord;
							DistanceToBeat = dist;
						}
					}
					if(CoordinateIndex != -1){
						float realVec[3];
						GetArrayArray(g_UnusedCoordinates, CoordinateIndex, realVec);
						// realVec[2] = realVec[2] - 60;
						TeleportEntity(i, realVec, NULL_VECTOR, no_vel);
						RemoveFromArray(g_UnusedCoordinates, CoordinateIndex);
						CoordinateIndex = -1;
						DistanceToBeat = 99999.0;
					}else{
						TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
					}
				}else{
					TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
				}
				SetEntityMoveType(i, MOVETYPE_WALK);
			}
		}


	} else{
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
				SetEntityMoveType(i, MOVETYPE_WALK);
			}
		}
	}
	
}


public int getRandomAlivePlayer(){
	int id = -1;
	int attempts = 0;
	while(!ValidAndAlive(id)){
		id = GetRandomInt(0,MAXPLAYERS+1);
		attempts++;
		if(attempts > 9999) break;
	}	
	return id;
}


stock int ScreenShake(int iClient, float fAmplitude = 200.0, float duration = 5.0){
	Handle hMessage = StartMessageOne("Shake", iClient, 1);
	
	PbSetInt(hMessage, "command", 0);
	PbSetFloat(hMessage, "local_amplitude", fAmplitude);
	PbSetFloat(hMessage, "frequency", 255.0);
	PbSetFloat(hMessage, "duration", duration);
	
	EndMessage();
}

//custom model
// stock void spawnBarrel(float vec[3]) {
// 	PrintToChatAll("spawning barrel");
// 	int ent = CreateEntityByName("prop_physics_multiplayer") ;

// 	TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR) ;

// 	//new random = GetRandomInt(0, 0) ;

// 	DispatchKeyValue(ent, "model", "models/props_c17/oildrum001_explosive.mdl");
// 	DispatchKeyValue(ent, "Damagetype", "8") ;
// 	DispatchKeyValue(ent, "minhealthdmg", "0") ;
// 	DispatchKeyValue(ent, "ExplodeDamage", "0") ;
// 	DispatchKeyValue(ent, "dmg", "0") ;
// 	DispatchKeyValue(ent, "physdamagescale", "0") ;

// 	DispatchSpawn(ent);

// 	IgniteEntity(ent, 10.0) ;
// }





// stock void PrintToConsoleAll(const char[] myString, any ...)
// {
// 	int len = strlen(myString) + 255;
// 	char[] myFormattedString = new char[len];
// 	VFormat(myFormattedString, len, myString, 2);
 
// 	for(int i = 0; i <= MaxClients; i++){
// 		if(IsValidClient(i)){
// 			PrintToConsole(i, myFormattedString);
// 		}
// 	}
// }






stock void Log(const char[] format, any ...)
{
	char buffer[254];
	VFormat(buffer, sizeof(buffer), format, 2);
	char sLogPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sLogPath, sizeof(sLogPath), "logs/chaos_logs.log");
	LogToFile(sLogPath, buffer);
}

public Action Command_RefreshConfig(int client, int args){
	ParseChaosEffects();
	ParseMapCoordinates();

	return Plugin_Handled;
}

void ParseChaosEffects(){
	Chaos_Effects.Clear();
	char filePath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, filePath, sizeof(filePath), "configs/Chaos/Chaos_Effects.cfg");


	if(!FileExists(filePath)){
		Log("Configuration file: %s not found.", filePath);
		LogError("Configuration file: %s not found.", filePath);
		SetFailState("[CHAOS] Could not find configuration file: %s", filePath);
		return;
	}
	KeyValues kvConfig = new KeyValues("Effects");

	if(!kvConfig.ImportFromFile(filePath)){
		Log("Unable to parse Key Values file %s", filePath);
		LogError("Unable to parse Key Values file %s", filePath);
		SetFailState("Unable to parse Key Values file %s", filePath);
		return;
	}

	if(!kvConfig.GotoFirstSubKey()){
		Log("Unable to find 'Effects' Section in file %s", filePath);
		LogError("Unable to find 'Effects' Section in file %s", filePath);
		SetFailState("Unable to find 'Effects' Section in file %s", filePath);
		return;
	}
	int  Chaos_Properties[2];
	do{
		char Chaos_Function_Name[64];
		if (kvConfig.GetSectionName(Chaos_Function_Name, sizeof(Chaos_Function_Name))){
			int enabled = kvConfig.GetNum("enabled", 1);
			int expires = kvConfig.GetNum("duration", 15);
			if(enabled != 0 && enabled != 1) enabled = 1;
			
			Chaos_Properties[CONFIG_ENABLED] = enabled;
			Chaos_Properties[CONFIG_EXPIRE] = expires;
			Chaos_Effects.SetArray(Chaos_Function_Name, Chaos_Properties, 2);
			// PrintToChatAll("%s: on: %i, dur: %i", Chaos_Function_Name, enabled, expires);
		}
	} while(kvConfig.GotoNextKey());

	Log("Parsed Chaos_Effects.cfg succesfully!");
}


public void PrecacheTextures(){
	PrecacheModel("models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl", true);
}

