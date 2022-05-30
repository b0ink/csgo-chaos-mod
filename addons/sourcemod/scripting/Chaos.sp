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

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = "BOINK",
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = "https://github.com/b0ink/csgo-chaos-mod"
};

char mapName[64];

char 	g_Prefix[] = ">>{lime}C H A O S{default}<<";
char 	g_Prefix_EndChaos[] = "<<{darkred}Ended{default}>>";
char 	g_Prefix_MegaChaos[] = "\n<<{orange}C H A O S{default}>>";


StringMap	Chaos_Effects;

#define SOUND_BELL "buttons/bell1.wav"
#define SOUND_BLIP "buttons/blip1.wav"
#define SOUND_COUNTDOWN "ui/beep07.wav"
#define SOUND_MONEY "survival/money_collect_04.wav"

#include "Data.sp"

Handle 	g_MapCoordinates = INVALID_HANDLE;
Handle 	g_UnusedCoordinates = INVALID_HANDLE;
Handle 	bombSiteA = INVALID_HANDLE;
Handle 	bombSiteB = INVALID_HANDLE;
bool 	g_bBombPlanted = false;

bool 	g_bCanSpawnChickens = true;
bool 	g_bPlayersCanDropWeapon = true;

int 	g_iOffset_Clip1 = -1;
int 	g_iFog = -1;

float 	g_PlayerDeathLocations[MAXPLAYERS+1][3];

bool 	g_bCanSpawnEffect = true;
int 	g_iChaos_Round_Count = 0;
bool 	g_bMegaChaos = false;
char 	g_sSelectedChaosEffect[64] = "";
char 	g_sCustomEffect[64] = ""; //overrides g_sSelectedChaosEffect
char 	g_sLastPlayedEffect[64] = "";

bool 	g_bClearChaos = false;
bool 	g_bDecidingChaos = false;

Handle 	g_NewEffect_Timer = INVALID_HANDLE;
bool 	g_bPlaySound_Debounce = false;
bool 	g_bDisableRetryEffect = false;

Handle 	Effect_History = INVALID_HANDLE;
float 	g_OriginalSpawnVec[MAXPLAYERS+1][3];

bool 	g_DynamicChannel = false;

int ChaosMapCount = 0;


//todo put back in convar and use functions to adjust it
// int g_NoAirAcc = 0;
int g_MaxAirAcc = 0;

#include "Externals/InstantWeaponSwitch.sp"
#include "Externals/WeaponJump.sp"
#include "Externals/ESP.sp"
#include "Externals/Aimbot.sp"
#include "Externals/Autoplant.sp"
#include "Externals/Teleport.sp"
#include "Externals/ChickenModels.sp"
#include "Externals/ExplosiveBullets.sp"
#include "Externals/SimonSays.sp"
#include "Externals/Drugs.sp"
#include "Externals/C4Chicken.sp"
#include "Externals/Rollback.sp"
#include "Externals/Fog.sp"
#include "Externals/Impostors.sp"
#include "Externals/ColorCorrection.sp"
#include "Externals/Weather.sp"

#include "Effects.sp"
#include "Effects-2.sp"

#include "ConVars.sp"
#include "Commands.sp"
#include "Hud.sp"
#include "EffectsHandler.sp"
#include "Configs.sp"
#include "Menu.sp"

public void OnPluginStart(){

	LoadTranslations("chaos.phrases");
	
	CreateConVars();
	
	RegisterCommands();

	HookEvent("round_start", 	Event_RoundStart);
	HookEvent("round_end", 		Event_RoundEnd);	
	HookEvent("player_death", 	Event_PlayerDeath);	
	HookEvent("weapon_fire", 	Event_OnWeaponFire); //, EventHookMode_Post);
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

	g_iOffset_Clip1 = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");

	Effect_History = CreateArray(64);
	Possible_Chaos_Effects = CreateArray(64);

	g_SavedConvars  = CreateArray(64);
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

	findLight();
	
	CLEAR_CC();
	HUD_INIT();
	
	ESP_INIT();
	TEAMMATESWAP_INIT();
	COORD_INIT();
	NOSCOPE_INIT();
	AUTOPLANT_INIT();
	EXPLOSIVEBULLETS_INIT();
	DRUGS_INIT();
	TELEPORT_INIT();
	WEATHER_INIT();
	
	Overlay_INIT();

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
	SDKHook(client, SDKHook_OnTakeDamagePost, 	Hook_OnTakeDamagePost);

	SDKHook(client, SDKHook_PreThinkPost, 		Hook_PreThinkPost);
}

public void OnClientDisconnect(int client){
	ToggleAim(client, false);
	WeaponJumpDisconnect_Handler(client);
}

public Action Timer_CreateHostage(Handle timer){
	CreateHostageRescue();
}

Action ChooseEffect(Handle timer = null, bool CustomRun = false){
	if(!CustomRun) g_NewEffect_Timer = INVALID_HANDLE;
	if(!g_bCanSpawnEffect) return;
	if(!g_bChaos_Enabled && !CustomRun) return;

	char Random_Effect[64] = "-";
	int randomEffect = -1;
	int attempts = 0;
	g_sLastPlayedEffect = "";

	g_bDecidingChaos = true;
	g_bClearChaos = false;
	PoolChaosEffects();

	if(g_sCustomEffect[0]){ //run from menu
		FormatEx(g_sSelectedChaosEffect, sizeof(g_sSelectedChaosEffect), "%s", g_sCustomEffect);
		Chaos();
	}else{
		while(!g_sLastPlayedEffect[0]){
			if(!CustomRun){
				do{
					// randomEffect = GetRandomInt(0, GetArraySize(Possible_Chaos_Effects) - 1);
					randomEffect = GetRandomInt(0, GetArraySize(Effect_Functions) - 1);
					GetArrayString(Effect_Functions, randomEffect, Random_Effect, sizeof(Random_Effect));
				}while((FindStringInArray(Effect_History, Random_Effect) != -1) || !Random_Effect[0]);

				PushArrayString(Effect_History, Random_Effect);

				float average = float((GetArraySize(Possible_Chaos_Effects) / 4) * 3);
				if(GetArraySize(Effect_History) > average) RemoveFromArray(Effect_History, 0);
				
			}else{
				//ignore history if run customly
				randomEffect = GetRandomInt(0, GetArraySize(Possible_Chaos_Effects) - 1);
				GetArrayString(Effect_Functions, randomEffect, Random_Effect, sizeof(Random_Effect));
			}

			g_sSelectedChaosEffect = Random_Effect;
		
			attempts++;

			Chaos(); //finally trigger effect
			ChaosMapCount++;
			if(attempts > 9999){
				Log("Woops! Something went wrong... (Effect Generator) %s - %s", g_sSelectedChaosEffect, Random_Effect);
			}
			if(g_sLastPlayedEffect[0] || attempts > 9999) break;
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
	g_bClearChaos = true;
	g_bDecidingChaos = false;
	Chaos(true);
}

#include "Hooks.sp"
#include "Events.sp"
#include "Helpers.sp"