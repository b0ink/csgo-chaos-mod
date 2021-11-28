#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <multicolors>
#include <cstrike>

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
// bool g_ChaosLoggingEnabled = true;


bool Chaos_Enabled = true; //todo as convar

#define SOUND_BELL "buttons/bell1.wav"

#define CONFIG_ENABLED 0
#define CONFIG_EXPIRE 1

#include "config.sp"
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

int g_Offset_Clip1 = -1;

float g_RollbackPositions[MAXPLAYERS+1][10][3];
float g_RollbackAngles[MAXPLAYERS+1][10][3];

float g_PlayerDeathLocations[MAXPLAYERS+1][3];

bool g_rewind_logging_enabled = true;

StringMap	Chaos_Effects;
StringMap	Chaos_Settings;

int Chaos_Round_Count = 0;

public void OnPluginStart(){
	
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);	
	HookEvent("player_death", Event_PlayerDeath);	
	HookEvent("weapon_fire", OnWeaponFirePost, EventHookMode_Post);
	HookEvent("bomb_planted", Event_BombPlanted);

	HookEvent("bullet_impact", Event_BulletImpact);
	AddTempEntHook("Shotgun Shot", Hook_BulletShot);

	// HookEvent("weapon_reload", Event_WeaponReload);
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) OnClientPutInServer(i);
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) OnClientPostAdminCheck(i);

	Chaos_Effects = new StringMap();
	Chaos_Settings = new StringMap();

	ESP_INIT();
	TEAMMATESWAP_INIT();
	COORD_INIT();
	NOSCOPE_INIT();
	AUTOPLANT_INIT();
	EXPLOSIVEBULLETS_INIT();
	DRUGS_INIT();

	RegAdminCmd("chaos_refreshconfig", Command_RefreshConfig, ADMFLAG_BAN);
	RegAdminCmd("chaos_debug", Command_ChaosDebug, ADMFLAG_BAN);
	//todo: commands to toggle chaos on/off => when turned off clear all chaos
		// RegAdminCmd("sm_enablechaos")
		// RegAdminCmd("sm_disablechaos")


	g_Offset_Clip1 = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");

	CreateTimer(1.0, Rollback_Log, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);


}
bool chaos_debug = false;
public Action Command_ChaosDebug(int client, int args){
	if(!chaos_debug){
		cvar("mp_freezetime", "2");
		cvar("mp_round_restart_delay", "2");
	}else{
		cvar("mp_freezetime", "15");
		cvar("mp_round_restart_delay", "7");
	}
	chaos_debug = !chaos_debug;
	return Plugin_Handled;
}

public void OnConfigsExecuted(){
	ParseMapCoordinates();
	ParseChaosEffects();
	ParseChaosSettings();
}


// public void Event_WeaponReload(Handle event, const char[] name, bool dontBroadcast ){
// 	SDKHook(client, SDKHook_ReloadPost, OnReloadPost);
// } 

public void OnClientPostAdminCheck(int client){
	//DONE: hook them as the event occurs, unhook them on clear.
	// Aimbot_SDKHOOKS(client);
}
//TODO weapon jump disocnnect?
//DONE merge put in sever and post admin check together
public void OnClientPutInServer(int client){
	WeaponJumpConnect_Handler(client);
	SDKHook(client, SDKHook_WeaponDrop, Event_WeaponDrop);
	SDKHook(client, SDKHook_WeaponSwitch, Event_WeaponSwitch);
	SDKHook(client, SDKHook_PreThink, OnPreThink);
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	SDKHook(client, SDKHook_OnTakeDamagePost, OnTakeDamagePost);
}


#include "ChaosEvents.sp"


//TODO move these into functions in another script that can be called on map start
int FogIndex = -1;
int g_randomCache[18];

float g_OriginalSpawnVec[MAXPLAYERS+1][3];

public void OnMapStart(){
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

}
public void OnMapEnd(){
	Log("Map has ended.");
}
//Todo; shields still dont work
Action Timer_CreateHostage(Handle timer = null){
	if (FindEntityByClassname(-1, "func_hostage_rescue") == -1){
		CreateEntityByName("func_hostage_rescue");
    }
}

public void OnClientDisconnect(int client){
	ToggleAim(client, false);
}

public Action Event_RoundStart(Event event, char[] name, bool dontBroadcast){
	if(!Chaos_Enabled) return Plugin_Continue;
	Chaos_Round_Count = true;
	// to use in chaos_resetspawns()
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			g_OriginalSpawnVec[i] = vec;
		}
	}



	SetRandomSeed(GetTime());
	if (GameRules_GetProp("m_bWarmupPeriod") != 1){
		g_ClearChaos = true;
		g_Chaos_Event_Count = 0;
		g_DecidingChaos = false;
		g_CountingChaos = true;
		Chaos(); //count and reset all chaos
		float freezeTime = float(FindConVar("mp_freezetime").IntValue);
		CreateTimer(freezeTime, DecideEvent);
	}
	return Plugin_Continue;
}


//todo; hold a cache of the last 10 (or more) events, and continue to randomise it 100 times until its one is found thats not inside the cache
//during a round, each event can be saved to a cache
	//so a 1:55 minute round is about 7 chaos events, those 7 chaos events get saved to a cache that can't be used in the next round.
	//every few rounds reset the cache so the combinations can be re mixed
bool findInArray(int[] array, int target, int arraysize){
	bool found = false;
	for(int i = 0; i < arraysize; i++) if(array[i] == target) found = true;
	if(found) return true;
	return false;
}

Handle g_NewEvent_Timer = INVALID_HANDLE;
bool g_PlaySound_Debounce = false;
public Action DecideEvent(Handle timer){
	g_NewEvent_Timer = INVALID_HANDLE;
	int index = sizeof(g_randomCache) - 1;
	while(index >= 1){
		g_randomCache[index] = g_randomCache[index - 1];
		index--;
	}


	g_RandomEvent = GetRandomInt(1, g_Chaos_Event_Count);
	if(g_Chaos_Event_Count > sizeof(g_randomCache)-1){
		// while(g_RandomEvent == g_Previous_Chaos_Event && findInArray(g_randomCache, g_RandomEvent, sizeof(g_randomCache))){
		while(findInArray(g_randomCache, g_RandomEvent, sizeof(g_randomCache))){
			g_RandomEvent = GetRandomInt(1,g_Chaos_Event_Count);
		}
	}
	// g_Previous_Chaos_Event = g_RandomEvent; //redundant, scheduled to be removed;
	g_randomCache[0] = g_RandomEvent;
	// PrintToChatAll("The chaos event count is %i",g_Chaos_Event_Count);
	PrintToConsoleAll("The chaos event count is %i",g_Chaos_Event_Count);
	// CPrintToChatAll("Event was %i", g_RandomEvent);
	g_DecidingChaos = true;
	g_ClearChaos = false;
	g_Chaos_Event_Count = 0;
	g_CountingChaos = true;
	Chaos(); //run the chaos
	StopTimer(g_NewEvent_Timer);
	int Chaos_Repeating = -1;
	if(!Chaos_Settings.GetValue("Repeating", Chaos_Repeating)){
		Log("Could not find 'Repeating' key in Chaos_Settings.cfg. Effects will repeat by default");
		Chaos_Repeating = 1;
	}
	if(Chaos_Repeating != 0 && Chaos_Repeating != 1){
		Log("Settings 'Repeating' Out Of Bounds. Defaulting to Enabled (1) - Chaos_Settings.cfg");
		Chaos_Repeating = 1;
	}
	if(Chaos_Repeating == 1){
		int Effect_Interval = -1;
		if(!Chaos_Settings.GetValue("EffectInterval", Effect_Interval)){
			Log("Could not find 'EffectInterval' key in Chaos_Settings.cfg. Effects will default to repeat every 15 seconds.");
			Effect_Interval = 15;
		}
		if(Effect_Interval > 60 || Effect_Interval < 5){
			Log("Settings 'EffectInterval' Out Of Bounds. Resetting to 15 seconds - Chaos_Settings.cfg");
			Effect_Interval = 15;
		}

		g_NewEvent_Timer = CreateTimer(float(Effect_Interval), DecideEvent);
		Chaos_Round_Count++;
		if(g_PlaySound_Debounce == false){
			//sometimes this function runs 5 times at once to find a new chaos, this prevents it from being played more than once
			g_PlaySound_Debounce = true;
			for(int i = 0; i <= MaxClients; i++){
				if(IsValidClient(i)){
					EmitSoundToClient(i, SOUND_BELL, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
				}
			}
			CreateTimer(2.0, Timer_ResetPlaySound);
		}
	}
}

public Action Timer_ResetPlaySound(Handle timer){
	g_PlaySound_Debounce = false;
}
public void RetryEvent(){ //Used if there's no map data found for the map that renders the event useless
	Log("RETRYING EVENT..");
	StopTimer(g_NewEvent_Timer);
	DecideEvent(INVALID_HANDLE);
}

public Action Event_RoundEnd(Event event, char[] name, bool dontBroadcast){
	ResetTimerRemoveChickens();
	StopTimer(g_NewEvent_Timer);
	CreateTimer(1.0, ResetRoundChaos);

}
public Action ResetRoundChaos(Handle timer){
	RemoveChickens(false);
	AcceptEntityInput(FogIndex, "TurnOff");

	g_ClearChaos = true;
	g_DecidingChaos = false;
	g_CountingChaos = false;
	Chaos();
}

//todo when i make the config and parse all the timer lengths, i'll sanitize the time

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   #####   #     #     #     #######   #####       #######  #     #  #######  #     #  #######   #####    ///////////
//  #     #  #     #    # #    #     #  #     #      #        #     #  #        ##    #     #     #     #  ////////////
//  #        #     #   #   #   #     #  #            #        #     #  #        # #   #     #     #         ///////////
//  #        #######  #     #  #     #   #####       #####    #     #  #####    #  #  #     #      #####    ///////////
//  #        #     #  #######  #     #        #      #         #   #   #        #   # #     #           #   ///////////
//  #     #  #     #  #     #  #     #  #     #      #          # #    #        #    ##     #     #     #   ///////////
//   #####   #     #  #     #  #######   #####       #######     #     #######  #     #     #      #####   ////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////\////////////////////////////////////////////////////////////////////////////////////////////////

// void Chaos_FakeDeath(){
// 	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
// 	if(g_ClearChaos){	

// 	}
// 	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
// 	for(int i = 0; i <= MaxClients; i++){
// 		if(ValidAndAlive(i)){
// 			// SetEntProp(i, Prop_Send, "m_lifeState", 1); 
// 		}
// 	}
// 	// CreateTimer(5.0, Test_Death);
// 	AnnounceChaos("Fake Death");
// }
// Action Test_Death(Handle timer){
// 	for(int i = 0; i <= MaxClients; i++){
// 		if(ValidAndAlive(i)){
// 			SetEntProp(i, Prop_Send, "m_lifeState", 0); 
// 		}
// 	}
// }

bool IsChaosEnabled(char[] EffectName, int defaultEnable = 1){
	if(g_ClearChaos) return true;
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
	int OverwriteDuration = -1;
	if(!Chaos_Settings.GetValue("OverwriteEffectDuration", OverwriteDuration)){
		Log("Could not find 'OverwriteEffectDuration' key in Chaos_Settings.cfg. Effect duration will default to Chaos_Effects.cfg settings.");
		OverwriteDuration = -1;
	}
	if(OverwriteDuration < -1){
		Log("Settings 'OverwriteEffectDuration' set Out Of Bounds in Chaos_Settings.cfg, effects will use their durations in Chaos_Effects.cfg");
		OverwriteDuration = -1;
	}

	int Chaos_Properties[2];
	float expire = defaultTime;
	if(Chaos_Effects.GetArray(EffectName, Chaos_Properties, 2)){
		if(OverwriteDuration == -1){
			expire = float(Chaos_Properties[CONFIG_EXPIRE]);
		}else{
			expire = float(OverwriteDuration);
		}
		if(expire != SanitizeTime(expire)){
			Log("Incorrect duration set for %s. You set: %f, defaulting to: %f", EffectName, expire, SanitizeTime(expire));
		}
		expire = SanitizeTime(expire);
	}else{
		Log("[CONFIG] Could not find configuration for Effect: %s, using default of %f", EffectName, defaultTime);
	}

	return expire;
}


#include "Effects.sp"

public Action Rollback_Log(Handle Timer){
	if(g_rewind_logging_enabled){
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
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
		g_rewind_logging_enabled = true;
		StopTimer(g_Chaos_Rewind_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_RewindTenSeconds");
	// g_rewind_logging_enabled = false;
	AnnounceChaos("Rewind 10 seconds");
	int time = 0;
	CreateTimer(0.1, Rewind_Timer, time, TIMER_FLAG_NO_MAPCHANGE);
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
		CreateTimer(0.3, Rewind_Timer, time, TIMER_FLAG_NO_MAPCHANGE);
	}else{
		TeleportPlayersToClosestLocation(); //fail safe todo: this is still bugged (the rewind part not this <<--)
		g_rewind_logging_enabled = true;
	}
}
// g_RollbackPositions[client][count] = g_RollbackPositions[client][count - 1];
				// g_RollbackAngles[client][count] = g_RollbackAngles[client][count - 1];

//todo: change to a repeating timer instead of a one off.. i was too lazy when doing this..
void Chaos_DiscoPlayers(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_DiscoPlayers");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntityRenderMode(i, RENDER_TRANSCOLOR);
			int color[3];
			color[0] = GetRandomInt(0, 255);
			color[1] = GetRandomInt(0, 255);
			color[2] = GetRandomInt(0, 255);
			int oldcolors[4];
			GetEntityRenderColor(i, oldcolors[0],oldcolors[1],oldcolors[2],oldcolors[3]);
			SetEntityRenderColor(i, color[0], color[1], color[2], oldcolors[3]);
		}
	}

	AnnounceChaos("Random Player Colours");
}





//todo, doesnt always work?
public void Chaos_RandomInvisiblePlayer(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_RandomInvisiblePlayer");
	int alivePlayers = GetAliveCTCount() + GetAliveTCount();
	int target = GetRandomInt(0, alivePlayers);
	int count = -1;
	bool setPlayer = false;
	if(alivePlayers > 1){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i) && !setPlayer){
				count++;
				if(count == target){
					setPlayer = true;
					target = i;
					SetEntityRenderMode(i, RENDER_TRANSCOLOR);
					SetEntityRenderColor(i, 255, 255, 255, 0);
					// SetEntityRenderMode(target, RENDER_NONE);
					// SetEntityRenderColor(target, 255, 255, 255, 0);
					//todo: shorten player names if its too high
					char chaosMsg[256];
					FormatEx(chaosMsg, sizeof(chaosMsg), "{orange}%N {default}has been made invisible!", target);
					AnnounceChaos(chaosMsg);
				}
			}
		}
	}else{
		RetryEvent();
	}
}





public void Chaos_MEGACHAOS(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_MEGACHAOS");
	
	g_MegaChaos = true; 
	AnnounceChaos("MEGA CHAOS", true, true);
	for(int i = 1; i <= 5; i++) RetryEvent();
	AnnounceChaos("MEGA CHAOS", true, true);
	g_MegaChaos = false; 
}













//todo move sdkhooks into their own file








float g_AllPositions[MAXPLAYERS+1][3];


void DoRandomTeleport(int client = -1){
	Log("[Chaos] Running: DoRandomTeleport (function, not chaos event)");

	ClearArray(g_UnusedCoordinates);

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		float vec[3];
		GetArrayArray(g_MapCoordinates, i, vec);
		PushArrayArray(g_UnusedCoordinates, vec);
	}
	// g_UnusedCoordinates = CloneArray(g_MapCoordinates);
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
	}
	timer = INVALID_HANDLE;
}



// public void Chaos_BouncyAir(){ //? todo
// 	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
// 	// if(g_ClearChaos){}
// 	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
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
		//todo test blending
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







// char skyboxes[][] = {
// 	"cs_baggage_skybox_",
// 	"cs_tibet",
// 	"vietnam",
// 	"vertigo",
// 	"sky_lunacy",
// 	"jungle"
// };





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
	DispatchSpawn(ent);
	TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
	ActivateEntity(ent);
	AcceptEntityInput(ent, "Start");
	return true;
}





#include "hooks.sp"
#include "events.sp"





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
		SetFailState("Unable to parse Key Values from %s", path);
		return;
	}
	//jump to key of map name
	if(!kv.JumpToKey(MapName)){
		SetFailState("Unable to find de_dust2 Key from %s", path);
		return;
	}

	if(!kv.GotoFirstSubKey(false)){
		SetFailState("Unable to find sub keys %s", path);
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

void StripPlayer(int client, bool knife = true, bool keepBomb = true, bool stripGrenadesOnly = false)
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
					if (IsValidEntity(iTempWeapon))
						RemovePlayerItem(client, iTempWeapon);
				}else{
					if(j==3)
						RemovePlayerItem(client, iTempWeapon);
				}
				
			}
		// if(knife) ClientCommand(client, "slot3");// zmienia bro� na n�	
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
	return (IsValidClient(client) && IsPlayerAlive(client));
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

bool removechicken_debounce = false;
void RemoveChickens(bool removec4Chicken = false){
	if(!removechicken_debounce){
		Log("[Chaos] > Removing Chickens");
		removechicken_debounce = true;
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
					if(i == g_c4chickenEnt){
						RemoveEdict(i);
					}
				}else{
					if(i != g_c4chickenEnt){
						SetEntPropFloat(i, Prop_Data, "m_flModelScale", 1.0);
						RemoveEdict(i);
					}
				}

			}
		}
		CreateTimer(5.0, timer_resetchickendebounce);
	}

}  

public Action timer_resetchickendebounce(Handle timer){
	removechicken_debounce = false;
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
	//todo: Log warnings when time doesnt get sanitized correctly, will require to pass effect name
	//or if(sanititizetime(time) != time) issue warning cos they dont match
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


stock int ScreenShake(int iClient, float fAmplitude = 100.0, float duration = 5.0){
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





stock void PrintToConsoleAll(const char[] myString, any ...)
{
	int len = strlen(myString) + 255;
	char[] myFormattedString = new char[len];
	VFormat(myFormattedString, len, myString, 2);
 
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			PrintToConsole(i, myFormattedString);
		}
	}
}






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
	ParseChaosSettings();
	ParseMapCoordinates();
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

void ParseChaosSettings(){
	Chaos_Settings.Clear();
	char filePath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, filePath, sizeof(filePath), "configs/Chaos/Chaos_Settings.cfg");


	if(!FileExists(filePath)){
		Log("Configuration file: %s not found.", filePath);
		LogError("Configuration file: %s not found.", filePath);
		SetFailState("[CHAOS] Could not find configuration file: %s", filePath);
		return;
	}
	KeyValues kvConfig = new KeyValues("Settings");

	if(!kvConfig.ImportFromFile(filePath)){
		Log("Unable to parse Key Values file %s", filePath);
		LogError("Unable to parse Key Values file %s", filePath);
		SetFailState("[CHAOS] Unable to parse Key Values file %s", filePath);
		return;
	}

	if(!kvConfig.GotoFirstSubKey()){
		Log("Unable to find 'Settings' Section in file %s", filePath);
		LogError("Unable to find 'Settings' Section in file %s", filePath);
		SetFailState("[CHAOS] Unable to find 'Settings' Section in file %s", filePath);
		return;
	}
	
	do{
		char Chaos_Setting_Name[64];
		if (kvConfig.GetSectionName(Chaos_Setting_Name, sizeof(Chaos_Setting_Name))){
			int value = kvConfig.GetNum(NULL_STRING);
			Chaos_Settings.SetValue(Chaos_Setting_Name, value);
		}
	} while(kvConfig.GotoNextKey());

	Log("Parsed Chaos_Settings.cfg succesfully!");
}
