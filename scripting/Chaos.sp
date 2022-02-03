#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <multicolors>
#include <cstrike>

#undef REQUIRE_PLUGIN
#include <DynamicChannels>
#define REQUIRE_PLUGIN

// Protection for SMAC users (SM Aimbot).
#undef REQUIRE_PLUGIN
#include <smac>

#pragma newdecls required
#pragma semicolon 1

#define PLUGIN_NAME "CS:GO Chaos Mod"
#define PLUGIN_DESCRIPTION "Spawn random effects from over 100+ effects every 15 seconds."
#define PLUGIN_VERSION "0.0.2"

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = "BOINK",
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = "https://github.com/b0ink/csgo-chaos-mod"
};


char 	g_Prefix[] = ">>{lime}C H A O S{default}<<";
char 	g_Prefix_EndChaos[] = "<<{darkred}Ended{default}>>";
char 	g_Prefix_MegaChaos[] = "\n<<{orange}C H A O S{default}>>";

StringMap	Chaos_Effects;

#define SOUND_BELL "buttons/bell1.wav"

#include "Data.sp"

Handle 	g_MapCoordinates = INVALID_HANDLE;
Handle 	g_UnusedCoordinates = INVALID_HANDLE;
Handle 	bombSiteA = INVALID_HANDLE;
Handle 	bombSiteB = INVALID_HANDLE;
bool 	g_bBombPlanted = false;

void COORD_INIT() {g_UnusedCoordinates = CreateArray(3); }

bool 	g_bCanSpawnChickens = true;
bool 	g_bPlayersCanDropWeapon = true;

int 	g_iOffset_Clip1 = -1;
int 	g_iFog = -1;

float 	g_PlayerDeathLocations[MAXPLAYERS+1][3];

bool 	g_bCanSpawnEffect = true;
int 	g_iChaos_Round_Count = 0;
bool 	g_bMegaChaos = false;
int 	g_iChaos_Event_Count = 0;
char 	g_sSelectedChaosEffect[64] = "";

bool 	g_bClearChaos = false;
bool 	g_bDecidingChaos = false;
int 	g_iRandomEvent = 0;
bool 	g_bCountingChaos = false;

ConVar 	g_cvChaosEnabled; bool g_bChaos_Enabled = true;
ConVar 	g_cvChaosEffectInterval; float g_fChaos_EffectInterval = 15.0;
ConVar 	g_cvChaosRepeating; bool g_bChaos_Repeating = true;
ConVar 	g_cvChaosOverwriteDuration; float g_fChaos_OverwriteDuration = -1.0;


Handle 	g_NewEvent_Timer = INVALID_HANDLE;
bool 	g_bPlaySound_Debounce = false;
bool 	g_bDisableRetryEvent = false;


#include "Externals/instantweaponswitch.sp"
#include "Externals/weaponjump.sp"
#include "Externals/esp.sp"
#include "Externals/aimbot.sp"
#include "Externals/autoplant.sp"
#include "Externals/teleport.sp"
#include "Externals/chickenmodels.sp"
#include "Externals/explosivebullets.sp"
#include "Externals/simonsays.sp"
#include "Externals/drugs.sp"
#include "Externals/c4chicken.sp"
#include "Externals/Rollback.sp"
#include "Externals/Fog.sp"
#include "Externals/Impostors.sp"

#include "Commands.sp"
#include "Hud.sp"
#include "EffectsHandler.sp"
#include "Configs.sp"

int	g_iEffectsHistory[18];

float g_OriginalSpawnVec[MAXPLAYERS+1][3];

public void OnPluginStart(){
	CreateConVar("csgo_chaos_mod_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);

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
	HookEvent("server_cvar", 	Event_Cvar, 			EventHookMode_Pre);
	AddTempEntHook("Shotgun Shot", Hook_BulletShot);

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			OnClientPutInServer(i);
		}
	}

	Chaos_Effects = new StringMap();

	HUD_INIT();

	ESP_INIT();
	TEAMMATESWAP_INIT();
	COORD_INIT();
	NOSCOPE_INIT();
	AUTOPLANT_INIT();
	EXPLOSIVEBULLETS_INIT();
	DRUGS_INIT();

	RegAdminCmd("chaos_refreshconfig", Command_RefreshConfig, ADMFLAG_GENERIC);
	RegAdminCmd("chaos_debug", Command_ChaosDebug, ADMFLAG_GENERIC);
	RegAdminCmd("chaos_help", Command_ChaosHelp, ADMFLAG_GENERIC);

	RegAdminCmd("sm_chaos", Command_NewChaosEffect, ADMFLAG_GENERIC);
	RegAdminCmd("sm_startchaos", Command_StartChaos, ADMFLAG_GENERIC);
	RegAdminCmd("sm_stopchaos", Command_StopChaos, ADMFLAG_GENERIC);

	g_iOffset_Clip1 = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");

}

public void OnMapStart(){
	UpdateCvars();

	char mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	char string[128];
	FormatEx(string, sizeof(string), "New Map/Plugin Restart - Map: %s", mapName);
	Log(string);
	PrecacheSound(SOUND_BELL);
	//todo precache player models?
	for(int i = 0; i < sizeof(g_iEffectsHistory); i++) g_iEffectsHistory[i] = -1;
	PrecacheTextures();
	if(g_MapCoordinates != INVALID_HANDLE) ClearArray(g_MapCoordinates);
	if(bombSiteA != INVALID_HANDLE) ClearArray(bombSiteA);
	if(bombSiteB != INVALID_HANDLE) ClearArray(bombSiteB);

	g_MapCoordinates = INVALID_HANDLE;
	bombSiteA = INVALID_HANDLE;
	bombSiteB = INVALID_HANDLE;

	findLight();

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

bool g_DynamicChannel = false;

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
	SDKHook(client, SDKHook_OnTakeDamagePost, 	Hook_OnTakeDamagePost);
}

public void OnClientDisconnect(int client){
	ToggleAim(client, false);
	WeaponJumpDisconnect_Handler(client);
}

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

//Todo; shields still dont work lol
Action Timer_CreateHostage(Handle timer = null){
	if (FindEntityByClassname(-1, "func_hostage_rescue") == -1){
		CreateEntityByName("func_hostage_rescue");
    }
}

Action DecideEvent(Handle timer, bool CustomRun = false){
	if(!CustomRun) g_NewEvent_Timer = INVALID_HANDLE;
	if(!g_bCanSpawnEffect) return;
	if(!g_bChaos_Enabled && !CustomRun) return;
	CountChaos();
	
	int index = sizeof(g_iEffectsHistory) - 1;
	while(index >= 1){
		g_iEffectsHistory[index] = g_iEffectsHistory[index - 1];
		index--;
	}


	g_iRandomEvent = GetRandomInt(1, g_iChaos_Event_Count);
	if(g_iChaos_Event_Count > sizeof(g_iEffectsHistory)-1){
		while(findInArray(g_iEffectsHistory, g_iRandomEvent, sizeof(g_iEffectsHistory))){
			g_iRandomEvent = GetRandomInt(1,g_iChaos_Event_Count);
		}
	}
	g_iEffectsHistory[0] = g_iRandomEvent;
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
		if(g_DynamicChannel) Timer_Display(null, RoundToFloor(Effect_Interval));

		g_iChaos_Round_Count++;
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
	Fog_OFF();
	g_bClearChaos = true;
	g_bDecidingChaos = false;
	g_bCountingChaos = false;
	Chaos();
}


#include "Effects.sp"
#include "Hooks.sp"
#include "Events.sp"
#include "Helpers.sp"