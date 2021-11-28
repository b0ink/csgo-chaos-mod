
float g_RapidFire_Expire = 25.0;
Handle g_RapidFire_Timer = INVALID_HANDLE;
bool g_RapidFire = false;
float g_RapidFire_Rate = 0.7;
Action Chaos_RapidFire(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("weapon_accuracy_nospread", "0");
		cvar("weapon_recoil_scale", "2");
		g_RapidFire = false;

		StopTimer(g_RapidFire_Timer);
		if(EndChaos) AnnounceChaos("Rapid Fire", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	
	g_RapidFire_Expire = GetChaosTime("Chaos_RapidFire", 25.0);
	Log("[Chaos] Running: Rapid Fire");

	if(g_RapidFire_Expire > 0.0) g_RapidFire_Timer = CreateTimer(g_RapidFire_Expire, Chaos_RapidFire, true, TIMER_FLAG_NO_MAPCHANGE);
	g_RapidFire = true;
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");
	AnnounceChaos("Rapid Fire");
}

float g_BreakTime_Expire = 10.0;
Handle g_BreakTime_Timer = INVALID_HANDLE;
Action Chaos_BreakTime(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("sv_accelerate", "5.5");
		cvar("sv_airaccelerate", "12");

		StopTimer(g_BreakTime_Timer);
		if(EndChaos) AnnounceChaos("Break Over", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_BreakTime_Expire = GetChaosTime("Chaos_BreakTime", 10.0);
	Log("[Chaos] Running: Chaos_BreakTime");

	if(g_BreakTime_Expire > 0.0) g_BreakTime_Timer = CreateTimer(g_BreakTime_Expire, Chaos_BreakTime, true, TIMER_FLAG_NO_MAPCHANGE);
	cvar("sv_accelerate", "0");
	cvar("sv_airaccelerate", "0");
	
	//todo set m_movement to 0 so no one can do anything
	AnnounceChaos("Break Time!");
}

float FakeTeleport_Expire = 3.0;
Handle FakeTeleport_Timer = INVALID_HANDLE;
float FakeTelport_loc[MAXPLAYERS+1][3];
void Chaos_FakeTeleport(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
		StopTimer(FakeTeleport_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Fake Teleport");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			FakeTelport_loc[i] = vec;
		}
	}
	DoRandomTeleport();
	FakeTeleport_Timer = CreateTimer(FakeTeleport_Expire, Timer_ResetFakeTeleport, _, TIMER_FLAG_NO_MAPCHANGE);
}
public Action Timer_ResetFakeTeleport(Handle timer){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			vec = FakeTelport_loc[i];
			TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
		}
	}
	AnnounceChaos("Fake Teleport");
	FakeTeleport_Timer = INVALID_HANDLE;
}

//todo: test soccerballs on maps other than dust2..?
void Chaos_Soccerballs(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	Log("[Chaos] Running: Chaos_Soccerballs");
	char MapName[128];
	GetCurrentMap(MapName, sizeof(MapName));
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			int ent = CreateEntityByName("prop_physics_override"); 
			SetEntityModel(ent, "models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl"); 
			DispatchKeyValue(ent, "StartDisabled", "false"); 
			DispatchKeyValue(ent, "Solid", "6"); 
			DispatchKeyValue(ent, "spawnflags", "1026"); 
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(ent); 
			AcceptEntityInput(ent, "TurnOn", ent, ent, 0); 
			AcceptEntityInput(ent, "EnableCollision"); 
			SetEntProp(ent, Prop_Data, "m_CollisionGroup", 5); 
		
		}
	}
	AnnounceChaos("Soccer balls");


}

float g_NoCrosshair_Expire = 25.0;
Handle g_NoCrossHair_Timer = INVALID_HANDLE;
Action Chaos_NoCrosshair(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){

		StopTimer(g_NoCrossHair_Timer);
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
			}
		}
		if(EndChaos) AnnounceChaos("No Crosshair", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_NoCrosshair_Expire = GetChaosTime("Chaos_NoCrosshair", 25.0);
	Log("[Chaos] Running: Chaos_NoCrosshair");

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
		}
	}
	AnnounceChaos("No Crosshair");
	if(g_NoCrosshair_Expire > 0.0) g_NoCrossHair_Timer = CreateTimer(g_NoCrosshair_Expire, Chaos_NoCrosshair, true, TIMER_FLAG_NO_MAPCHANGE);
}

bool lag = true;
void Chaos_FakeCrash(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){    }
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_FakeCrash");
	if(GetRandomInt(0, 100) <= 25){
		AnnounceChaos("Fake Crash");
		lag = true;
		CreateTimer(1.0, Timer_nolag);
		while(lag){
			if(!lag) break;
		}
	}else{
		RetryEvent();
	}

}
public Action Timer_nolag(Handle timer){
	lag = false;
}


float g_DisableRadar_Expire = 20.0;
Handle g_DisableRadar_Timer = INVALID_HANDLE;
Action Chaos_DisableRadar(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("sv_disable_radar", "0");

		StopTimer(g_DisableRadar_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_DisableRadar_Expire = GetChaosTime("Chaos_DisableRadar", 20.0);
	Log("[Chaos] Running: Chaos_DisableRadar");

	cvar("sv_disable_radar", "1");
	if(g_DisableRadar_Expire > 0.0) g_DisableRadar_Timer = CreateTimer(g_DisableRadar_Expire, Chaos_DisableRadar, true, TIMER_FLAG_NO_MAPCHANGE);
	AnnounceChaos("No Radar");
}

void Chaos_SpawnFlashbangs(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){    }
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	Log("[Chaos] Running: Chaos_SpawnFlashbangs");

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec, sizeof(vec));
			int flash = CreateEntityByName("flashbang_projectile");
			TeleportEntity(flash, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(flash);
		}
	}
	AnnounceChaos("Spawn Flashbangs");
}

float g_SuperJump_Expire = 20.0;
Handle g_SuperJump_Timer = INVALID_HANDLE;
Action Chaos_SuperJump(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("sv_jump_impulse", "301");

		StopTimer(g_SuperJump_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_SuperJump_Expire = GetChaosTime("Chaos_SuperJump", 20.0);
	Log("[Chaos] Running: Chaos_SuperJump");
	
	cvar("sv_jump_impulse", "590");
	if(g_SuperJump_Expire > 0.0) g_SuperJump_Timer = CreateTimer(g_SuperJump_Expire, Chaos_SuperJump, true, TIMER_FLAG_NO_MAPCHANGE);
	AnnounceChaos("Super Jump");
}



float g_Juggernaut_Expire = 30.0;
Handle g_Juggernaut_Timer = INVALID_HANDLE;
char g_OriginalModels_Jugg[MAXPLAYERS + 1][PLATFORM_MAX_PATH+1];
//https://forums.alliedmods.net/showthread.php?t=307674 thanks for prop_send 
bool g_SetJuggernaut = false;
Action Chaos_Juggernaut(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){

		StopTimer(g_Juggernaut_Timer);
		if(g_SetJuggernaut){
			g_SetJuggernaut = false;
			for(int i = 0; i <= MaxClients; i++){
				if(ValidAndAlive(i)){
					SetEntProp(i, Prop_Send, "m_bHasHelmet", false);
					SetEntProp(i, Prop_Send, "m_bHasHeavyArmor", false);
					SetEntProp(i, Prop_Send, "m_bWearingSuit", false);
					if(GetEntProp(i, Prop_Send, "m_ArmorValue") > 100){
						SetEntProp(i, Prop_Data, "m_ArmorValue", 100);
					}
					if(g_OriginalModels_Jugg[i][0]){
						SetEntityModel(i, g_OriginalModels_Jugg[i]);
						g_OriginalModels_Jugg[i] = "";
					}
				}
			}
		}
		
		cvar("mp_weapons_allow_heavyassaultsuit", "0");
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_Juggernaut_Expire = GetChaosTime("Chaos_Juggernaut", 30.0);
	Log("[Chaos] Running: Chaos_Juggernaut");

	cvar("mp_weapons_allow_heavyassaultsuit", "1");
	g_SetJuggernaut = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientModel(i, g_OriginalModels_Jugg[i], sizeof(g_OriginalModels_Jugg[]));
			GivePlayerItem(i, "item_heavyassaultsuit");
		}
	}
	if(g_Juggernaut_Expire > 0.0) g_Juggernaut_Timer = CreateTimer(g_Juggernaut_Expire, Chaos_Juggernaut, true, TIMER_FLAG_NO_MAPCHANGE);
	AnnounceChaos("Juggernauts");
}


void Chaos_SpawnExplodingBarrels(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_SpawnExplodingBarrels");
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec, sizeof(vec));
			int barrel = CreateEntityByName("prop_exploding_barrel");
			TeleportEntity(barrel, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(barrel);
		}
	}
	AnnounceChaos("Exploding Barrels");
}


float g_InsaneStrafe_Expire = 20.0;
Handle g_InsaneStrafe_Timer = INVALID_HANDLE;
Action Chaos_InsaneAirSpeed(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("sv_air_max_wishspeed", "30");
		cvar("sv_airaccelerate", "12");

		StopTimer(g_InsaneStrafe_Timer);

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_InsaneStrafe_Expire = GetChaosTime("Chaos_InsaneAirSpeed", 20.0);
	Log("[Chaos] Running: Chaos_InsaneAirSpeed");
	cvar("sv_air_max_wishspeed", "2000");
	cvar("sv_airaccelerate", "2000");
	AnnounceChaos("Extreme Strafe Acceleration");
	if(g_InsaneStrafe_Expire > 0.0) g_InsaneStrafe_Timer = CreateTimer(g_InsaneStrafe_Expire, Chaos_InsaneAirSpeed, true, TIMER_FLAG_NO_MAPCHANGE);
}

void Chaos_RespawnDead_LastLocation(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){    }
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_RespawnDead_LastLocation");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			TeleportEntity(i, g_PlayerDeathLocations[i], NULL_VECTOR, NULL_VECTOR);
		}
	}
	AnnounceChaos("Resurrect players where they died");
}

float g_Drugs_Expire = 10.0;
Handle g_Drugs_Timer = INVALID_HANDLE;
Action Chaos_Drugs(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		KillAllDrugs();
		StopTimer(g_Drugs_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_Drugs_Expire = GetChaosTime("Chaos_Drugs", 10.0);
	Log("[Chaos] Running: Chaos_Drugs");

	if(g_Drugs_Expire > 0.0) g_Drugs_Timer = CreateTimer(g_Drugs_Expire, Chaos_Drugs, true, TIMER_FLAG_NO_MAPCHANGE);
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			CreateDrug(i);
		}
	}
	AnnounceChaos("Drugs");
}


float g_EnemyRadar_Expire = 25.0;
Handle g_EnemyRadar_Timer = INVALID_HANDLE;
Action Chaos_EnemyRadar(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("mp_radar_showall", "0");
		StopTimer(g_EnemyRadar_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_EnemyRadar_Expire = GetChaosTime("Chaos_EnemyRadar", 25.0);
	Log("[Chaos] Running: Chaos_EnemyRadar");
	
	if(g_EnemyRadar_Expire > 0.0) g_EnemyRadar_Timer = CreateTimer(g_EnemyRadar_Expire, Chaos_EnemyRadar, true, TIMER_FLAG_NO_MAPCHANGE);
	cvar("mp_radar_showall", "1");
	AnnounceChaos("Enemy Radar");
}

void Chaos_Give100HP(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	Log("[Chaos] Running: Chaos_Give100HP");
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			int currenthealth = GetClientHealth(i);
			SetEntityHealth(i, currenthealth + 100);
		}
	}
	AnnounceChaos("Give all players +100 HP");
}


void Chaos_HealAllPlayers(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	Log("[Chaos] Running: Chaos_HealAllPlayers");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntityHealth(i, 100);
		}
	}
	AnnounceChaos("Set all players health to 100");
}

float g_BuyAnywhere_Expire = 20.0;
Handle g_BuyAnywhere_Timer = INVALID_HANDLE;
Action Chaos_BuyAnywhere(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("mp_buy_anywhere", "0");
		cvar("mp_buytime", "20");

		StopTimer(g_BuyAnywhere_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_BuyAnywhere_Expire = GetChaosTime("Chaos_BuyAnywhere", 20.0);
	Log("[Chaos] Running: Chaos_BuyAnywhere");
	
	cvar("mp_buy_anywhere", "1");
	cvar("mp_buytime", "999");
	AnnounceChaos("Buy Anywhere Enabled!");
	if(g_BuyAnywhere_Expire > 0.0) g_BuyAnywhere_Timer = CreateTimer(g_BuyAnywhere_Expire, Chaos_BuyAnywhere, true);
}

// float g_SimonSays_Duration = 10.0;
void Chaos_SimonSays(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
		g_Simon_Active = false;
		KillMessageTimer();
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_SimonSays_Duration = GetChaosTime("Chaos_SimonSays", 10.0);
	Log("[Chaos] Running: Chaos_SimonSays");
	GenerateSimonOrder();
	StartMessageTimer();
	g_Simon_Active = true;
}

float g_ExplosBullets_Duration = 15.0;
Handle g_ExplosBullets_Timer = INVALID_HANDLE;
Action Chaos_ExplosiveBullets(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_ExplosBullets_Timer);
		g_ExplosiveBullets = false;
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_ExplosBullets_Duration = GetChaosTime("Chaos_ExplosiveBullets", 15.0);
	Log("[Chaos] Running: Chaos_ExplosiveBullets");
	g_ExplosiveBullets = true;
	//todo no map change flag
	if(g_ExplosBullets_Duration > 0.0) g_ExplosBullets_Timer = CreateTimer(g_ExplosBullets_Duration, Chaos_ExplosiveBullets, true);
	AnnounceChaos("Explosive Bullets");
}

bool g_SpeedShooter = false;
float g_SpeedShooter_Expire = 10.0;
Handle g_SpeedShooter_Timer = INVALID_HANDLE;
//todo, if someone has speed once this ends, they still have speed
// > try saving their old speed but itll still be fucky
Action Chaos_SpeedShooter(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_SpeedShooter_Timer);
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			}
		}
		g_SpeedShooter = false;
		if(EndChaos) AnnounceChaos("Speed Shooter", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_SpeedShooter_Expire = GetChaosTime("Chaos_SpeedShooter", 10.0);
	Log("[Chaos] Running: Chaos_SpeedShooter");

	g_SpeedShooter = true;
	AnnounceChaos("Speed Shooter");
	if(g_SpeedShooter_Expire > 0.0) g_SpeedShooter_Timer = CreateTimer(g_SpeedShooter_Expire, Chaos_SpeedShooter, true);
}

float zero_vector[3] = {0.0, 0.0, 0.0};
void Chaos_ResetSpawns(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_ResetSpawns");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			TeleportEntity(i, g_OriginalSpawnVec[i], NULL_VECTOR, zero_vector);
		}
	}
	
	AnnounceChaos("Teleport all players back to spawn");
}

bool g_NoStrafe = false;
float g_NoStrafe_Expire = 20.0;
Handle g_NoStrafe_Timer = INVALID_HANDLE;
Action Chaos_DisableStrafe(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		g_NoStrafe = false;

		StopTimer(g_NoStrafe_Timer);
		if(EndChaos) AnnounceChaos("Normal Left/Right Movement", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_NoStrafe_Expire = GetChaosTime("Chaos_DisableStrafe", 20.0);
	Log("[Chaos] Running: Chaos_DisableStrafe");
	g_NoStrafe = true;
	if(g_NoStrafe_Expire > 0.0) g_NoStrafe_Timer = CreateTimer(g_NoStrafe_Expire, Chaos_DisableStrafe, true);
	AnnounceChaos("Disable Left/Right Movement");
}

bool g_NoForwardBack = false;
float g_NoForwardBack_Expire = 20.0;
Handle g_NoForwardBack_Timer = INVALID_HANDLE;
Action Chaos_DisableForwardBack(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		g_NoForwardBack = false;

		StopTimer(g_NoForwardBack_Timer);
		if(EndChaos) AnnounceChaos("Normal Forward/Backward Movement", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_NoForwardBack_Expire = GetChaosTime("Chaos_DisableForwardBack", 20.0);
	Log("[Chaos] Running: Chaos_DisableForwardBack");
	g_NoForwardBack = true;
	if(g_NoForwardBack_Expire > 0.0) g_NoForwardBack_Timer = CreateTimer(g_NoForwardBack_Expire, Chaos_DisableForwardBack, true);
	AnnounceChaos("Disable Forward/Backward Movement");
}

bool g_Jumping = false;
float g_Jumping_Expire = 15.0;
Handle g_Jumping_Timer_Repeat = INVALID_HANDLE;
Handle g_Jumping_Time = INVALID_HANDLE;
Action Chaos_Jumping(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		g_Jumping = false;

		StopTimer(g_Jumping_Timer_Repeat);
		StopTimer(g_Jumping_Time);

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_Jumping_Expire = GetChaosTime("Chaos_Jumping", 15.0);
	Log("[Chaos] Running: Chaos_Jumping");

	StopTimer(g_Jumping_Timer_Repeat);
	g_Jumping = true;
	g_Jumping_Timer_Repeat = CreateTimer(0.3, Timer_ForceJump, _,TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	if(g_Jumping_Expire > 0.0) g_Jumping_Time = CreateTimer(g_Jumping_Expire, Chaos_Jumping, true);
	AnnounceChaos("Jumping!");
}
public Action Timer_ForceJump(Handle timer){
	if(g_Jumping){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				float vec[3];
				GetEntPropVector(i, Prop_Data, "m_vecVelocity", vec);
				if(vec[2] == 0.0) { //ensure player isnt mid jump or falling down
					vec[0] = 0.0;
					vec[1] = 0.0;
					vec[2] = 300.0;
					SetEntPropVector(i, Prop_Data, "m_vecBaseVelocity", vec);
				}
			}
		}
	}else{
		StopTimer(g_Jumping_Timer_Repeat);
	}
}


bool g_DiscoFog = false;
Handle g_DiscoFog_Timer_Repeat = INVALID_HANDLE;
float g_DiscoFog_Expire = 25.0;
Handle g_DiscoFog_Timer = INVALID_HANDLE;
Action Chaos_DiscoFog(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
		StopTimer(g_DiscoFog_Timer_Repeat);
		StopTimer(g_DiscoFog_Timer);
		g_DiscoFog = false;
		AcceptEntityInput(FogIndex, "TurnOff");
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_DiscoFog_Expire = GetChaosTime("Chaos_DiscoFog", 25.0);
	Log("[Chaos] Running: Chaos_DiscoFog");
	
	if(FogIndex != -1){
		char color[32];
		FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
		DispatchKeyValue(FogIndex, "fogcolor", color);
		// DispatchKeyValue(FogIndex, "fogcolor", "255 255 255");
		DispatchKeyValueFloat(FogIndex, "fogend", 800.0);
		DispatchKeyValueFloat(FogIndex, "fogmaxdensity", 0.92);
		// DispatchKeyValueFloat(FogIndex, "farz", -1.0);
		AcceptEntityInput(FogIndex, "TurnOn");
		AnnounceChaos("Disco Fog");
		g_DiscoFog = true;
		g_DiscoFog_Timer_Repeat = CreateTimer(1.0, Timer_NewFogColor, _,TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
		if(g_DiscoFog_Expire > 0.0) g_DiscoFog_Timer = CreateTimer(g_DiscoFog_Expire, Chaos_DiscoFog, true);
	}else{
		RetryEvent();
	}
}
public Action Timer_NewFogColor(Handle timer){
	if(g_DiscoFog){
		char color[32];
		FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
		DispatchKeyValue(FogIndex, "fogcolor", color);
	}else{
		StopTimer(g_DiscoFog_Timer_Repeat);
	}
}


float g_OneBulletOneGun_Expire = 15.0;
Handle g_OneBuilletOneGun_Timer = INVALID_HANDLE;
bool g_OneBulletOneGun = false;
Action Chaos_OneBulletOneGun(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		g_OneBulletOneGun = false;
		StopTimer(g_OneBuilletOneGun_Timer);
		if(EndChaos) AnnounceChaos("One Bullet One Gun", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_OneBulletOneGun_Expire = GetChaosTime("Chaos_OneBulletOneGun", 15.0);
	Log("[Chaos] Running: Chaos_OneBulletOneGun");

	g_OneBulletOneGun = true; //handled somehwere in events.sp
	AnnounceChaos("One Bullet One Gun");
	if(g_OneBulletOneGun_Expire > 0.0) g_OneBuilletOneGun_Timer = CreateTimer(g_OneBulletOneGun_Expire, Chaos_OneBulletOneGun, true, TIMER_FLAG_NO_MAPCHANGE);
}

float g_Earthquake_Duration = 5.0;
void Chaos_Earthquake(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){    }
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_Earthquake_Duration = GetChaosTime("Chaos_Earthquake", 5.0);
	Log("[Chaos] Running: Chaos_Earthquake");
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ScreenShake(i, g_Earthquake_Duration);
		}
	}
	AnnounceChaos("Earthquake");
}


float g_ChickenPlayers_Expire = 20.0;
Handle g_ChickenPlayers_Timer = INVALID_HANDLE;
Action Chaos_ChickenPlayers(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		StopTimer(g_ChickenPlayers_Timer);
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				DisableChicken(i);
			}
		}
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_ChickenPlayers_Expire = GetChaosTime("Chaos_ChickenPlayers", 20.0);
	Log("[Chaos] Running: Chaos_ChickenPlayers");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetChicken(i);
		}
	}
	if(g_ChickenPlayers_Expire > 0) g_ChickenPlayers_Timer = CreateTimer(g_ChickenPlayers_Expire, Chaos_ChickenPlayers, true);
	AnnounceChaos("Make all players a chicken");
}


void Chaos_IgnitePlayer(bool forceAllPlayers = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){    }
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_IgnitePlayer");
	int randomchance = GetRandomInt(1,100);
	if(randomchance <= 25 || forceAllPlayers){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				IgniteEntity(i, 10.0);
			}
		}
		AnnounceChaos("Ignite All Players");
	}else{
		int player = getRandomAlivePlayer();
		if(player != -1){
			IgniteEntity(player, 10.0);
			char msg[128];
			FormatEx(msg, sizeof(msg), "Ignite {orange}%N", player);
			AnnounceChaos(msg);
		}else{
			Chaos_IgnitePlayer(true);
		}
	}
}

float g_LockPlayersAim_Expire = 20.0;
Handle g_LockPlayersAim_Timer_Expire = INVALID_HANDLE; //keeps track of when to end the event
Handle g_LockPlayersAim_Timer_Enforce = INVALID_HANDLE; //enforces locked aim
bool g_LockPlayersAim_Active = false;
float g_LockPlayersAim_Angles[MAXPLAYERS+1][3];
Action Chaos_LockPlayersAim(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		g_LockPlayersAim_Active = false;
		StopTimer(g_LockPlayersAim_Timer_Expire);
		StopTimer(g_LockPlayersAim_Timer_Enforce);
		if(EndChaos) AnnounceChaos("Lock Mouse Movement", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_LockPlayersAim_Expire = GetChaosTime("Chaos_LockPlayersAim", 20.0);
	Log("[Chaos] Running: Chaos_LockPlayersAim");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GetClientEyeAngles(i, g_LockPlayersAim_Angles[i]);
	g_LockPlayersAim_Timer_Enforce = CreateTimer(0.01, Timer_EnforcePlayerLock, _, TIMER_REPEAT);
	g_LockPlayersAim_Active  = true;
	if(g_LockPlayersAim_Expire > 0) g_LockPlayersAim_Timer_Expire = CreateTimer(g_LockPlayersAim_Expire, Chaos_LockPlayersAim, true);
	AnnounceChaos("Lock Mouse Movement");
}
//potentially to add in OnPlayerRunCmd?
Action Timer_EnforcePlayerLock(Handle timer){
	if(g_LockPlayersAim_Active){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				TeleportEntity(i, NULL_VECTOR, g_LockPlayersAim_Angles[i], NULL_VECTOR);
			}
		}
	}else{
		StopTimer(g_LockPlayersAim_Timer_Enforce);
	}
}

float g_SlowSpeed_Expire = 20.0;
Handle g_SlowSpeed_Timer = INVALID_HANDLE;
Action Chaos_SlowSpeed(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
		if(EndChaos) AnnounceChaos("Normal Movement Speed", true);
		StopTimer(g_SlowSpeed_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_SlowSpeed_Expire = GetChaosTime("Chaos_SlowSpeed", 20.0);
	Log("[Chaos] Running: Chaos_SlowSpeed");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.5);
	AnnounceChaos("0.5x Movement Speed");
	if(g_SlowSpeed_Expire > 0) g_SlowSpeed_Timer = CreateTimer(g_SlowSpeed_Expire, Chaos_SlowSpeed, true);
}

float g_FastSpeed_Expire = 20.0;
Handle g_FastSpeed_Timer = INVALID_HANDLE;
Action Chaos_FastSpeed(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
		if(EndChaos) AnnounceChaos("Normal Movement Speed", true);
		StopTimer(g_FastSpeed_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_FastSpeed_Expire = GetChaosTime("Chaos_FastSpeed", 20.0);
	Log("[Chaos] Running: Chaos_FastSpeed");
	
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 3.0);
	AnnounceChaos("3x Movement Speed");
	if(g_FastSpeed_Expire > 0) g_FastSpeed_Timer = CreateTimer(g_FastSpeed_Expire, Chaos_FastSpeed, true);
}

void Chaos_RespawnTheDead(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_RespawnTheDead");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			if(!IsPlayerAlive(i)){
				CS_RespawnPlayer(i);
			}
		}
	}
	// AnnounceChaos("The Dead Have Awaken");
	AnnounceChaos("Resurrect dead players");
}

void Chaos_RespawnTheDead_Randomly(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_RespawnTheDead_Randomly");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			if(!IsPlayerAlive(i)){
				CS_RespawnPlayer(i);
				DoRandomTeleport(i);
			}
		}
	}
	AnnounceChaos("Resurrect dead players in random locations");
}

void Chaos_Bumpmines(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_Bumpmines");
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GivePlayerItem(i, "weapon_bumpmine");
	AnnounceChaos("Bumpmines");
}

Action Chaos_Spin180(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_Spin180");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float angs[3];
			GetClientEyeAngles(i, angs);
			angs[1] = angs[1] + 180;
			TeleportEntity(i, NULL_VECTOR, angs, NULL_VECTOR);
		}
	}
	AnnounceChaos("180 Spin");
}

bool g_PortalGuns = false;
float g_PortalGuns_Expire = 20.0; //config
Handle g_PortalGuns_Timer = INVALID_HANDLE;
Action Chaos_PortalGuns(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos && timer == null) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		if(EndChaos){
			TeleportPlayersToClosestLocation();
			AnnounceChaos("Portal Guns", true);
		}
		g_PortalGuns = false;
		StopTimer(g_PortalGuns_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_PortalGuns_Expire = GetChaosTime("Chaos_PortalGuns", 20.0);
	Log("[Chaos] Running: Chaos_PortalGuns");
	
	g_PortalGuns = true;
	AnnounceChaos("Portal Guns");
	SavePlayersLocations();
	if(g_PortalGuns_Expire > 0) g_PortalGuns_Timer = CreateTimer(g_PortalGuns_Expire, Chaos_PortalGuns, true);
}


// Action Chaos_TeleportFewMeters(Handle timer = null, bool EndChaos = false){
void Chaos_TeleportFewMeters(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	Log("[Chaos] Running: Chaos_TeleportFewMeters");
	
	SavePlayersLocations();
	TeleportPlayersToClosestLocation(-1, 250); //250 units of minimum teleport distance
	AnnounceChaos("Teleport Players A Few Meters");
}



float g_InfiniteGrenades_Expire = 20.0; //config
Handle g_InfiniteGrenade_Timer = INVALID_HANDLE;
Action Chaos_InfiniteGrenades(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		StopTimer(g_InfiniteGrenade_Timer);
		cvar("sv_infinite_ammo", "0");
		if(EndChaos) AnnounceChaos("Infinite Grenades", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	
	g_InfiniteGrenades_Expire = GetChaosTime("Chaos_InfiniteGrenades", 20.0);
	Log("[Chaos] Running: Chaos_InfiniteGrenades");

	cvar("sv_infinite_ammo", "2");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GivePlayerItem(i, "weapon_hegrenade");
			GivePlayerItem(i, "weapon_molotov");
			GivePlayerItem(i, "weapon_smokegrenade");
			GivePlayerItem(i, "weapon_flashbang");
		}
	}
	AnnounceChaos("Infinite Grenades");
	if(g_InfiniteGrenades_Expire > 0) g_InfiniteGrenade_Timer = CreateTimer(g_InfiniteGrenades_Expire, Chaos_InfiniteGrenades, true);
}

void Chaos_Shields(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_Shields");
	Timer_CreateHostage();
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GivePlayerItem(i, "weapon_shield");
	AnnounceChaos("Shields");
}


float g_IsThisMexico_Expire = 30.0;
Handle g_IsThisMexico_Timer = INVALID_HANDLE;
Action Chaos_IsThisMexico(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		AcceptEntityInput(FogIndex, "TurnOff");
		if(EndChaos) AnnounceChaos("Is This What Mexico Looks Like?", true);
		StopTimer(g_IsThisMexico_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_IsThisMexico_Expire = GetChaosTime("Chaos_IsThisMexico", 30.0);
	Log("[Chaos] Running: Chaos_IsThisMexico");

	DispatchKeyValue(FogIndex, "fogcolor", "138 86 22");
	DispatchKeyValueFloat(FogIndex, "fogend", 0.0);
	// DispatchKeyValueFloat(FogIndex, "fogmaxdensity", 0.9989);
	// DispatchKeyValueFloat(FogIndex, "fogmaxdensity", 0.75);
	DispatchKeyValueFloat(FogIndex, "fogmaxdensity", 0.85);
	AcceptEntityInput(FogIndex, "TurnOn");
	AnnounceChaos("Is This What Mexico Looks Like?");
	if(g_IsThisMexico_Expire > 0) g_IsThisMexico_Timer = CreateTimer(g_IsThisMexico_Expire, Chaos_IsThisMexico, true);
}

float g_OneWeaponOnly_Expire = 30.0;
Handle g_OneWeaponOnly_Timer = INVALID_HANDLE;
Action Chaos_OneWeaponOnly(Handle timer = null, bool EndChaos = false){
	//todo; change chaos name, but its an event to pick a random weapon, and players are restricted to that weapon for the rest of the round.
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		StopTimer(g_OneWeaponOnly_Timer);
		g_PlayersCanDropWeapon = true;
		if(EndChaos) AnnounceChaos("Weapon Drop Re-enabled", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_OneWeaponOnly_Expire = GetChaosTime("Chaos_OneWeaponOnly", 30.0);
	Log("[Chaos] Running: Chaos_OneWeaponOnly");
	//todo; might have to handle weapon pickups?.. (players can still buy)
	g_PlayersCanDropWeapon = false;
	char randomWeapon[64];
	int randomIndex = GetRandomInt(0, sizeof(weapons)-1);
	randomWeapon = weapons[randomIndex];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			StripPlayer(i);
			GivePlayerItem(i, randomWeapon);
		}
	}
	for(int i = 0; i < sizeof(randomWeapon); i++) randomWeapon[i] = CharToUpper(randomWeapon[i]);

	char chaosMsg[128];
	FormatEx(chaosMsg, sizeof(chaosMsg), "%s's Only!", randomWeapon[7]); //strip weapon_ from name;
	// chaosMsg[0] = CharToUpper(chaosMsg[0]);
	AnnounceChaos(chaosMsg);
	if(g_OneWeaponOnly_Expire > 0) g_OneWeaponOnly_Timer = CreateTimer(g_OneWeaponOnly_Expire, Chaos_OneWeaponOnly, true);
}

void Chaos_AutoPlantC4(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){
		AutoPlantRoundEnd();
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	Log("[Chaos] Running: Chaos_AutoPlantC4");

	if(g_BombPlanted){
		//todo: teleport the bomb to another bomb site? haha
		RetryEvent();
		return;
	}
	AutoPlantC4();
	if(g_PlantedSite == BOMBSITE_A){
		AnnounceChaos("Auto Plant C4 at Bombsite A");
	}else if(g_PlantedSite == BOMBSITE_B){
		AnnounceChaos("Auto Plant C4 at Bombsite B");
	}else{
		AnnounceChaos("Auto Plant C4");
	}
	g_PlantedSite = -1;
}

public void Chaos_ChickensIntoPlayers(){
	//not to be confused with players into chickesn..
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){
		RemoveChickens();
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_ChickensIntoPlayers");

	if(g_MapCoordinates == INVALID_HANDLE){
		RetryEvent();
		return;
	}
	//todo: chickens get stuck, saw a video somewhere that its possible for them to move around like normal
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int chance = GetRandomInt(0,100);
		if(chance <= 25){
			int ent = CreateEntityByName("chicken");
			if(ent != -1){
				int randomSkin = GetRandomInt(0, 23 - 1);
				float vec[3];
				GetArrayArray(g_MapCoordinates, i, vec);
				vec[2] = vec[2] + 50.0;
				TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);

				DispatchSpawn(ent);
				// SetEntProp(ent, Prop_Send, "m_fEffects", 0);
				// SetEntProp(ent, Prop_Data, "m_flGroundSpeed", 1);
				// CreateTimer(0.1, Timer_SetChickenModel, ent);
				SetEntityModel(ent, playerModel_Path[randomSkin]);
				// SetEntPropFloat(ent, Prop_Send, "m_flSpeed", 2.0);
				// SetVariantString("!activator");
			}
		}
	}
	AnnounceChaos("Impostors");
}

public void Chaos_MamaChook(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){
		RemoveChickens();
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_MamaChook");
	if(g_MapCoordinates == INVALID_HANDLE || !g_CanSpawnChickens){
		RetryEvent();
		return;
	}

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int chance = GetRandomInt(0,100);
		if(chance <= 25){
			int ent = CreateEntityByName("chicken");
			if(ent != -1){
				float vec[3];
				GetArrayArray(g_MapCoordinates, i, vec);
				TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(ent);
				SetEntPropFloat(ent, Prop_Data, "m_flModelScale", 100.0);
			}
			break;
		}
	
	}

	AnnounceChaos("Mama Chook");
}

public void Chaos_BigChooks(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){
		RemoveChickens();
		g_CanSpawnChickens = true;
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_BigChooks");

	if(g_MapCoordinates == INVALID_HANDLE || !g_CanSpawnChickens){
		RetryEvent();
		return;
	}

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int chance = GetRandomInt(0,100);
		if(chance <= 25){ //too many chickens is a no no
			int ent = CreateEntityByName("chicken");
			if(ent != -1){
				float vec[3];
				GetArrayArray(g_MapCoordinates, i, vec);
				TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
				float randomSize = GetRandomFloat(2.0, 15.0);
				DispatchSpawn(ent);
				SetEntPropFloat(ent, Prop_Data, "m_flModelScale", randomSize);
			}
		}
	
	}
	AnnounceChaos("Big Chooks");
}

public void Chaos_LittleChooks(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){
		RemoveChickens();
		g_CanSpawnChickens = true;

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_LittleChooks");

	if(g_MapCoordinates == INVALID_HANDLE || !g_CanSpawnChickens){
		RetryEvent();
		return;
	}
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int chance = GetRandomInt(0,100);
		if(chance <= 25){ //too many chickens is a no no
			int ent = CreateEntityByName("chicken");
			if(ent != -1){
				float vec[3];
				GetArrayArray(g_MapCoordinates, i, vec);
				TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(ent);
				float randomSize = GetRandomFloat(0.4, 0.9);
				SetEntPropFloat(ent, Prop_Data, "m_flModelScale", randomSize);
			}
		}
	
	}
	AnnounceChaos("Lil' Chooks");
}


bool g_OneBulletMag = false;
float g_OneBuilletMag_Expire = 20.0; //config
Handle g_OneBulletMagTimer = INVALID_HANDLE;
Action Chaos_OneBulletMag(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		g_OneBulletMag = false;
		if(EndChaos){ //don't need to do this if the round has ended, especially if the event didnt even happen
			for(int i = 0; i <= MaxClients; i++){
				if(ValidAndAlive(i)){
					char currentWeapon[64];
					GetClientWeapon(i, currentWeapon, sizeof(currentWeapon));
					int wepID = -1;
					for(int slot = 0; slot < 2; slot++){ //pistol and primary are the only ones i care about
						if((wepID = GetPlayerWeaponSlot(i, slot)) != -1){
							char ClientWeaponName[64];
							GetWeaponClassname(wepID, ClientWeaponName, 64);
							if(IsValidEntity(wepID)){
								RemovePlayerItem(i, wepID);
								GivePlayerItem(i, ClientWeaponName);
							} 
						}
					}
					FakeClientCommand(i, "use %s", currentWeapon); //swap back to original weapon
				}
			}
			AnnounceChaos("One Bullet Mags", true);
		}

		StopTimer(g_OneBulletMagTimer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_OneBuilletMag_Expire = GetChaosTime("Chaos_OneBulletMag", 20.0);
	Log("[Chaos] Running: Chaos_OneBulletMag");
	// cvar("sv_infinite_ammo", "0"); //avoids conflict with chaos_infiniteammo?
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			for (int j = 0; j < 2; j++){
				int iTempWeapon = -1;
				if ((iTempWeapon = GetPlayerWeaponSlot(i, j)) != -1) SetClip(iTempWeapon, 1, 1);
			}
		}
	}
	g_OneBulletMag = true;
	if(g_OneBuilletMag_Expire > 0) g_OneBulletMagTimer = CreateTimer(g_OneBuilletMag_Expire, Chaos_OneBulletMag, true);
	AnnounceChaos("One Bullet Mags");
}

float g_CrabPeople_Expire = 15.0;
Handle g_CrabPeopleTimer = INVALID_HANDLE;
bool g_ForceCrouch = false;
Action Chaos_CrabPeople(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		g_ForceCrouch = false;
		StopTimer(g_CrabPeopleTimer);
		if(EndChaos) AnnounceChaos("Crab People", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_CrabPeople_Expire = GetChaosTime("Chaos_CrabPeople", 15.0);
	Log("[Chaos] Running: Chaos_CrabPeople");
	g_ForceCrouch = true;
	AnnounceChaos("Crab People");
	if(g_CrabPeople_Expire > 0) g_CrabPeopleTimer = CreateTimer(g_CrabPeople_Expire, Chaos_CrabPeople, true);
}

bool g_NoscopeOnly = false;
float g_NoscopeOnly_Expire = 20.0;
Handle g_NoscopeOnly_Timer = INVALID_HANDLE;
Action Chaos_NoScopeOnly(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		StopTimer(g_NoscopeOnly_Timer);
		g_NoscopeOnly = false;
		if(EndChaos) AnnounceChaos("You can now scope again", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_NoscopeOnly_Expire = GetChaosTime("Chaos_NoScopeOnly", 20.0);
	Log("[Chaos] Running: Chaos_NoScopeOnly");
	g_NoscopeOnly = true;
	if(g_NoscopeOnly_Expire > 0) g_NoscopeOnly_Timer = CreateTimer(g_NoscopeOnly_Expire, Chaos_NoScopeOnly, true);
	AnnounceChaos("No scopes only");
}

void Chaos_MoneyRain(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){ cvar("sv_dz_cash_bundle_size", "50"); }
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_MoneyRain");

	cvar("sv_dz_cash_bundle_size", "500");
	if(g_MapCoordinates == INVALID_HANDLE){
		RetryEvent();
		return;
	}
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int ent = CreateEntityByName("item_cash");
		if(ent != -1){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			vec[2] = vec[2] + GetRandomInt(50, 200);
			//todo; randomise the rotation of the cash for extra bounce?
			TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(ent);
		}
	}
	AnnounceChaos("Make it rain");
}

bool g_VampireRound = false;
float g_Vampire_Expire = 30.0;
Handle g_Vampire_Timer = INVALID_HANDLE;
Action Chaos_VampireHeal(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		StopTimer(g_Vampire_Timer);
		g_VampireRound = false;
		if(EndChaos) AnnounceChaos("Vampires", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_Vampire_Expire = GetChaosTime("Chaos_VampireHeal", 30.0);
	Log("[Chaos] Running: Chaos_VampireHeal");

	g_VampireRound = true;
	AnnounceChaos("Vampires");
	if(g_Vampire_Expire > 0) g_Vampire_Timer = CreateTimer(g_Vampire_Expire, Chaos_VampireHeal, true);
}


void Chaos_C4Chicken(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos){
		g_c4Chicken = false;
		RemoveChickens();
		g_c4chickenEnt = -1;
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_C4Chicken");
	if(g_c4Chicken){
		RetryEvent();
		return;
	}
	g_c4Chicken = true;
	C4Chicken(); //convert any planted c4's to chicken
	AnnounceChaos("C4 Chicken");
}

//tood; buggy if you still have other nades?
bool g_DecoyDodgeball = false;
float g_DecoyDoge_Expire = 20.0;
Handle g_DecoyDodgeballTimer = INVALID_HANDLE;
Handle g_DecoyDodgeball_CheckDecoyTimer = INVALID_HANDLE;
Action Chaos_DecoyDodgeball(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		StopTimer(g_DecoyDodgeballTimer);
		StopTimer(g_DecoyDodgeball_CheckDecoyTimer);
		if(g_DecoyDodgeball){
			for(int i = 0; i <= MaxClients; i++){
				if(ValidAndAlive(i)){
					StripPlayer(i, true, true, true); //strip grenades only
					SetEntityHealth(i, 100);
					FakeClientCommand(i, "use weapon_knife");
				}
			}
		}
		g_DecoyDodgeball = false;
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_DecoyDoge_Expire = GetChaosTime("Chaos_DecoyDodgeball", 20.0);
	Log("[Chaos] Running: Chaos_DecoyDodgeball");
	g_DecoyDodgeball = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			StripPlayer(i, true, true, true); //strip grenades only
			GivePlayerItem(i, "weapon_decoy");
			FakeClientCommand(i, "use weapon_decoy");
			SetEntityHealth(i, 1);
		}
	}
	AnnounceChaos("Decoy Dodgeball");
	if(g_DecoyDoge_Expire > 0) g_DecoyDodgeballTimer = CreateTimer(g_DecoyDoge_Expire, Chaos_DecoyDodgeball, true);
	g_DecoyDodgeball_CheckDecoyTimer = CreateTimer(5.0, Timer_CheckDecoys, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}
Action Timer_CheckDecoys(Handle timer){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			bool hasDecoy = false;
			int wepID = -1;
			for(int slot = 0; slot < 7; slot++){
				if((wepID = GetPlayerWeaponSlot(i, slot)) != -1){
					char ClientWeaponName[64];
					GetWeaponClassname(wepID, ClientWeaponName, 64);
					if(IsValidEntity(wepID)){
						if(StrContains(ClientWeaponName, "weapon_decoy") != -1){
							hasDecoy = true;
						}
					} 
				}
			}
			if(!hasDecoy){
				GivePlayerItem(i, "weapon_decoy");
			}
		}
	}
}

bool g_HeadshotOnly = false;
float g_HeadshotOnly_Expire = 20.0;
Handle g_HeadshotOnly_Timer = INVALID_HANDLE;
Action Chaos_HeadshotOnly(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		StopTimer(g_HeadshotOnly_Timer);
		if(g_HeadshotOnly) g_HeadshotOnly = false;
		cvar("mp_damage_headshot_only", "0");
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_HeadshotOnly_Expire = GetChaosTime("Chaos_HeadshotOnly", 20.0);
	Log("[Chaos] Running: Chaos_HeadshotOnly");
	g_HeadshotOnly = true;
	cvar("mp_damage_headshot_only", "1");
	AnnounceChaos("Headshots Only");
	if(g_HeadshotOnly_Expire > 0) g_HeadshotOnly_Timer = CreateTimer(g_HeadshotOnly_Expire, Chaos_HeadshotOnly, true);
}

float g_ohko_Expire = 15.0;
Handle g_ohko_Timer = INVALID_HANDLE;
Action Chaos_OHKO(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} //TODO return this info in another function
	if(g_ClearChaos || EndChaos){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 100);
		StopTimer(g_ohko_Timer);
		if(EndChaos) AnnounceChaos("1 HP", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_ohko_Expire = GetChaosTime("Chaos_OHKO", 15.0);
	Log("[Chaos] Running: Chaos_OHKO");
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 1);
	AnnounceChaos("1 HP");
	if(g_ohko_Expire > 0) g_ohko_Timer = CreateTimer(g_ohko_Expire, Chaos_OHKO, true);
}

float g_InsaneGravity_Expire = 20.0;
Handle g_InsaneGravityTimer = INVALID_HANDLE;
Action Chaos_InsaneGravity(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){	
		StopTimer(g_InsaneGravityTimer);
		cvar("sv_gravity", "800");
		ServerCommand("sv_falldamage_scale 1");
		if(EndChaos) AnnounceChaos("Insane Gravity", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_InsaneGravity_Expire = GetChaosTime("Chaos_InsaneGravity", 20.0);
	Log("[Chaos] Running: Chaos_InsaneGravity");
	cvar("sv_gravity", "3000");
	ServerCommand("sv_falldamage_scale 0");
	if(g_InsaneGravity_Expire > 0) g_InsaneGravityTimer = CreateTimer(g_InsaneGravity_Expire, Chaos_InsaneGravity, true);
	AnnounceChaos("Insane Gravity");
}

void Chaos_Nothing(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_Nothing");
	AnnounceChaos("Nothing");
}

Handle g_IceySurface_Timer = INVALID_HANDLE;
float g_IceySurface_Expire = 20.0;
Action Chaos_IceySurface(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} 
	if(g_ClearChaos || EndChaos){
		StopTimer(g_IceySurface_Timer);
		cvar("sv_friction", "5.2");
		if(EndChaos) AnnounceChaos("Icey Ground", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_IceySurface_Expire = GetChaosTime("Chaos_IceySurface", 20.0);
	Log("[Chaos] Running: Chaos_IceySurface");
	cvar("sv_friction", "0");
	AnnounceChaos("Icey Ground");
	if(g_IceySurface_Expire > 0) g_IceySurface_Timer = CreateTimer(g_IceySurface_Expire, Chaos_IceySurface, true);
}

Handle Chaos_RandomSlap_Timer = INVALID_HANDLE;
float g_Chaos_RandomSlap_Interval = 7.0;
float g_RandomSlap_Expire = 30.0;
Handle g_RandomSlapDuration_Timer = INVALID_HANDLE;
Action Chaos_RandomSlap(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(Chaos_RandomSlap_Timer);
		StopTimer(g_RandomSlapDuration_Timer);
		cvar("sv_falldamage_scale", "1");
		if(EndChaos) AnnounceChaos("Ghost Slaps", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_RandomSlap_Expire = GetChaosTime("Chaos_RandomSlap", 30.0);
	Log("[Chaos] Running: Chaos_RandomSlap");
	StopTimer(Chaos_RandomSlap_Timer);
	cvar("sv_falldamage_scale", "0");
	Chaos_RandomSlap_Timer = CreateTimer(g_Chaos_RandomSlap_Interval, Timer_RandomSlap, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	if(g_RandomSlap_Expire > 0) g_RandomSlapDuration_Timer = CreateTimer(g_RandomSlap_Expire, Chaos_RandomSlap, true, TIMER_FLAG_NO_MAPCHANGE);
	AnnounceChaos("Ghost Slaps");
}

float g_maxRange = 750.0;
float g_minRange = -750.0;
// int g_RandomSlap_Count = 0;
Action Timer_RandomSlap(Handle timer){
	//Todo play sound.. or do ghost slaps make no noise at all? { o.o }
	// g_RandomSlap_Count++;
	// if(g_RandomSlap_Count > 5){
	// 	g_RandomSlap_Count = 0;
	// 	KillTimer(Chaos_RandomSlap_Timer);
	// 	Chaos_RandomSlap_Timer = INVALID_HANDLE;
	// }
	for(int  client = 0;  client <= MaxClients;  client++){
		if(IsValidClient(client) && IsPlayerAlive(client)){
			float vec[3];
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", vec);
			float x = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(-100.0, -1.0);
			float y = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(-100.0, 50.0);
			float z = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(20.0, 50.0);
			vec[0] = vec[0]+x;
			vec[1] = vec[1]+y;
			vec[2] = vec[2]+z;
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec); 
			CPrintToChat(client, "What was that?");
		}
	}
}

float g_TaserParty_Expire = 10.0;
Handle g_TaserParty_Timer = INVALID_HANDLE;
Action Chaos_TaserParty(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("mp_taser_recharge_time", "-1");
		cvar("sv_party_mode", "0");
		g_TaserRound = false;
		StopTimer(g_TaserParty_Timer);
		if(EndChaos) AnnounceChaos("Taser Party", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_TaserParty_Expire = GetChaosTime("Chaos_TaserParty", 10.0);
	Log("[Chaos] Running: Chaos_TaserParty");

	g_TaserRound = true;
	cvar("mp_taser_recharge_time", ".5");
	cvar("sv_party_mode", "1");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			GivePlayerItem(i, "weapon_taser");
			FakeClientCommand(i, "use weapon_taser");
		}
	}
	if(g_TaserParty_Expire > 0) g_TaserParty_Timer = CreateTimer(g_TaserParty_Expire, Chaos_TaserParty, true);
	AnnounceChaos("Taser Party!");
}

bool g_KnifeFight = false;
float g_KnifeFight_Expire = 15.0;
Handle g_KnifeFight_Timer = INVALID_HANDLE;
Action Chaos_KnifeFight(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_KnifeFight_Timer);
		g_KnifeFight = false;
		if(EndChaos) AnnounceChaos("Knife Fight", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_KnifeFight_Expire = GetChaosTime("Chaos_KnifeFight", 15.0);
	Log("[Chaos] Running: Chaos_KnifeFight");
	g_KnifeFight = true;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			FakeClientCommand(i, "use weapon_knife");
		}
	}
	if(g_KnifeFight_Expire > 0) g_KnifeFight_Timer = CreateTimer(g_KnifeFight_Expire, Chaos_KnifeFight, true);
	AnnounceChaos("Knife Fight!");
}

float g_Funky_Expire = 30.0;
Handle g_Funky_Timer = INVALID_HANDLE;
Action Chaos_Funky(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("sv_enablebunnyhopping", "0");
		cvar("sv_autobunnyhopping", "0");
		cvar("sv_airaccelerate", "12");
		StopTimer(g_Funky_Timer);
		if(EndChaos) AnnounceChaos("No more {orchid}funky{default}?", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_Funky_Expire = GetChaosTime("Chaos_Funky", 30.0);
	Log("[Chaos] Running: Chaos_Funky");
	
	cvar("sv_airaccelerate", "2000");
	cvar("sv_enablebunnyhopping", "1");
	cvar("sv_autobunnyhopping", "1");
	if(g_Funky_Expire > 0) g_Funky_Timer = CreateTimer(g_Funky_Expire, Chaos_Funky, true);
	AnnounceChaos("Are you feeling {orchid}funky{default}?");
}

// bool g_RandomWeaponRound = false;
float g_RandWep_Expire = 30.0;
Handle g_RandWep_Timer = INVALID_HANDLE;
Action Chaos_RandomWeapons(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		g_PlayersCanDropWeapon = true;
		// g_RandomWeaponRound = false;
		StopTimer(g_Chaos_RandomWeapons_Timer);
		StopTimer(g_RandWep_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_RandWep_Expire = GetChaosTime("Chaos_RandomWeapons", 30.0);
	Log("[Chaos] Running: Chaos_RandomWeapons");


	StopTimer(g_Chaos_RandomWeapons_Timer);
	// g_RandomWeaponRound = true;
	g_PlayersCanDropWeapon = false;
	Timer_GiveRandomWeapon();
	g_Chaos_RandomWeapons_Timer = CreateTimer(g_Chaos_RandomWeapons_Interval, Timer_GiveRandomWeapon, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	if(g_RandWep_Expire > 0) g_RandWep_Timer = CreateTimer(g_RandWep_Expire, Chaos_RandomWeapons, true, TIMER_FLAG_NO_MAPCHANGE);
	AnnounceChaos("Random Weapons!");
}
Action Timer_GiveRandomWeapon(Handle timer = null){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			int randomWeaponIndex = GetRandomInt(0,sizeof(weapons)-1);	
			GiveAndSwitchWeapon(i, weapons[randomWeaponIndex]);
		}
	}
}

float g_MoonGravity_Duration = 30.0;
Handle g_MoonGravity_Timer = INVALID_HANDLE;
Action Chaos_MoonGravity(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_MoonGravity_Timer);
		cvar("sv_gravity", "800");
		if(EndChaos) AnnounceChaos("Moon Gravity", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_MoonGravity_Duration = GetChaosTime("Chaos_MoonGravity", 30.0);
	Log("[Chaos] Running: Chaos_MoonGravity");
	//TODO fluctuating gravity thoughout the round?
	cvar("sv_gravity", "300");
	if(g_MoonGravity_Duration > 0) g_MoonGravity_Timer = CreateTimer(g_MoonGravity_Duration, Chaos_MoonGravity, true);
	AnnounceChaos("Moon Gravity");
}


//TODO use the map coordinates to make it look like cool raining in another effect
Handle Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
float g_Chaos_RandomMolotovSpawn_Interval = 5.0; //5+ recommended for bomb plants

int g_MolotovSpawn_Count = 0;

public void Chaos_RandomMolotovSpawn(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
		cvar("inferno_flame_lifetime", "7");
		StopTimer(Chaos_MolotovSpawn_Timer);
	}		
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_MolotovSpawn_Count = RoundToFloor(GetChaosTime("Chaos_RandomMolotovSpawn", 5.0));
	Log("[Chaos] Running: Chaos_RandomMolotovSpawn");
	
	cvar("inferno_flame_lifetime", "4");
	Chaos_MolotovSpawn_Timer = CreateTimer(g_Chaos_RandomMolotovSpawn_Interval, Timer_SpawnMolotov, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	AnnounceChaos("Raining Fire!");
}

public Action Timer_SpawnMolotov(Handle timer){
	if(g_MolotovSpawn_Count > 5){
		g_MolotovSpawn_Count = 0;
		StopTimer(Chaos_MolotovSpawn_Timer);
		Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
		AnnounceChaos("Raining Fire Ended", true);
		return;
	}
	g_MolotovSpawn_Count++;
	for(int client = 0; client <= MaxClients; client++){
		if(IsValidClient(client) && IsPlayerAlive(client)){
			float vec[3];
			GetClientAbsOrigin(client, vec);
			vec[2] = vec[2] + 100; //anything bigger and things like vents or ct spawn will spawn molotov in other areas of the map
			//TODO offset x and z
			int ent = CreateEntityByName("molotov_projectile");
			TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(ent);
			AcceptEntityInput(ent, "InitializeSpawnFromWorld"); 
		}
	}
}


float g_ESP_Duration = 30.0;
Handle g_ESP_Timer = INVALID_HANDLE;
Action Chaos_ESP(Handle timer = null, bool EndChaos = false ){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	
		StopTimer(g_ESP_Timer);
		// cvar("sv_force_transmit_players", "0"); //todo is this the one that hides everyone?
		destroyGlows();
		if(EndChaos) AnnounceChaos("Wall Hacks", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_ESP_Duration = GetChaosTime("Chaos_ESP", 30.0);
	Log("[Chaos] Running: Chaos_ESP");
	cvar("sv_force_transmit_players", "1");
	createGlows();
	AnnounceChaos("Wall Hacks");
	if(g_ESP_Duration > 0) g_ESP_Timer = CreateTimer(g_ESP_Duration, Chaos_ESP, true);
}

Handle g_ReversedMovementTimer = INVALID_HANDLE;
float g_ReversedMovement_Duration = 20.0;
Action Chaos_ReversedMovement(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	
		cvar("sv_accelerate", "5.5");
		// cvar("sv_airaccelerate", "12");

		StopTimer(g_ReversedMovementTimer);
		if(EndChaos) AnnounceChaos("Reversed Movement");
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_ReversedMovement_Duration = GetChaosTime("Chaos_ReversedMovement", 20.0);
	Log("[Chaos] Running: Chaos_ReversedMovement");
	cvar("sv_accelerate", "-5.5");
	if(g_ReversedMovement_Duration > 0) g_ReversedMovementTimer = CreateTimer(g_ReversedMovement_Duration, Chaos_ReversedMovement, true);
	AnnounceChaos("Reversed Movement");
}


void Chaos_TeammateSwap(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){	

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_TeammateSwap");

	ClearArray(TPos);
	ClearArray(CTPos);
	ClearArray(tIndex);
	ClearArray(ctIndex);

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && GetClientTeam(i) == CS_TEAM_T){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			PushArrayArray(TPos, vec);
		}else if(IsValidClient(i) && GetClientTeam(i) == CS_TEAM_CT){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			PushArrayArray(CTPos, vec);
		} 
	}

	for(int i = MaxClients; i >= 0; i--){
		if(IsValidClient(i) && GetClientTeam(i) == CS_TEAM_T){
			PushArrayCell(tIndex, i);
		}else if(IsValidClient(i) && GetClientTeam(i) == CS_TEAM_CT){
			PushArrayCell(ctIndex, i);
		}
	}

	for(int i = 0; i < GetArraySize(ctIndex); i++){
		float vec[3];
		GetArrayArray(CTPos, i, vec);
		TeleportEntity(GetArrayCell(ctIndex, i), vec, NULL_VECTOR, NULL_VECTOR);
	}

	for(int i = 0; i < GetArraySize(tIndex); i++){
		float vec[3];
		GetArrayArray(TPos, i, vec);
		TeleportEntity(GetArrayCell(tIndex, i), vec, NULL_VECTOR, NULL_VECTOR);
	}

	AnnounceChaos("Teammate Swap!");
}

//Allows nowclippers to take damage
bool g_ActiveNoclip = false;
float g_Flying_Expire = 10.0;
Handle g_ResetNoclipTimer = INVALID_HANDLE;

Action Chaos_Flying(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
	
		for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetEntityMoveType(i, MOVETYPE_WALK);
		cvar("sv_noclipspeed", "5");
		if(EndChaos) AnnounceChaos("Flying", true);
		if(EndChaos) TeleportPlayersToClosestLocation();
		g_ActiveNoclip = false;	
		StopTimer(g_ResetNoclipTimer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_Flying_Expire = GetChaosTime("Chaos_Flying", 10.0);
	Log("[Chaos] Running: Chaos_Flying");
	g_ActiveNoclip = true;	
	SavePlayersLocations();
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityMoveType(i, MOVETYPE_NOCLIP);
	cvar("sv_noclipspeed", "2");
	if(g_Flying_Expire > 0) g_ResetNoclipTimer = CreateTimer(g_Flying_Expire, Chaos_Flying, true);
	AnnounceChaos("Flying");
}

void Chaos_RandomTeleport(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){	
		// if(g_UnusedCoordinates != INVALID_HANDLE) g_UnusedCoordinates;
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_RandomTeleport");

	DoRandomTeleport();

	AnnounceChaos("Random Teleport");
}

void Chaos_LavaFloor(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){	
		// if(g_UnusedCoordinates != INVALID_HANDLE) g_UnusedCoordinates;
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	Log("[Chaos] Running: Chaos_LavaFloor");

	for(int i = 0; i <=  GetArraySize(g_MapCoordinates)-1; i++){
		int spawnChance = GetRandomInt(0,100);
		if(spawnChance <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			// vec[2] = vec[2]; //anything bigger and things like vents or ct spawn will spawn molotov in other areas of the map
			//TODO offset x and z
			int ent = CreateEntityByName("molotov_projectile");
			TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(ent);
			AcceptEntityInput(ent, "InitializeSpawnFromWorld"); 
		}
	}
	
	AnnounceChaos("The Floor Is Lava");

}

float g_Quake_Duration = 25.0;
Handle g_Quake_Timer = INVALID_HANDLE;
Action Chaos_QuakeFOV(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	
		StopTimer(g_Quake_Timer);
		ResetPlayersFOV();
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_Quake_Duration = GetChaosTime("Chaos_QuakeFOV", 25.0);
	Log("[Chaos] Running: Chaos_QuakeFOV");
	int RandomFOV = GetRandomInt(110,160);
	SetPlayersFOV(RandomFOV);
	if(g_Quake_Duration > 0) g_Quake_Timer = CreateTimer(g_Quake_Duration, Chaos_QuakeFOV, true);
	AnnounceChaos("Quake FOV");
}

float g_Binoculars_Duration = 25.0;
Handle g_Binoculars_Timer = INVALID_HANDLE;
Action Chaos_Binoculars(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	
		StopTimer(g_Binoculars_Timer);
		ResetPlayersFOV();
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_Quake_Duration = GetChaosTime("Chaos_Binoculars", 25.0);
	Log("[Chaos] Running: Chaos_Binoculars");
	int RandomFOV = GetRandomInt(20,50);
	SetPlayersFOV(RandomFOV);
	if(g_Binoculars_Duration > 0) g_Binoculars_Timer = CreateTimer(g_Binoculars_Duration, Chaos_Binoculars, true);
	AnnounceChaos("Binoculars");
}

void SetPlayersFOV(int fov){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			SetEntProp(i, Prop_Send, "m_iFOV", fov);
			SetEntProp(i, Prop_Send, "m_iDefaultFOV", fov);
		}
	}
}
void ResetPlayersFOV(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetEntProp(i, Prop_Send, "m_iFOV", 0);
			SetEntProp(i, Prop_Send, "m_iDefaultFOV", 90);
		}
	}
}


Handle g_BlindPlayers_Timer = INVALID_HANDLE;
float g_Chaos_BlindLength = 7.0; //how long the player is blind for.
Action Chaos_BlindPlayers(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				PerformBlind(i, 0);
			}
		}
		StopTimer(g_BlindPlayers_Timer);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_Chaos_BlindLength = GetChaosTime("Chaos_BlindPlayers", 7.0);
	Log("[Chaos] Running: Chaos_BlindPlayers");

	for(int client = 0; client <= MaxClients; client++){
		if(IsValidClient(client)){
			PerformBlind(client, 255);
		}
	}
	g_BlindPlayers_Timer = CreateTimer(g_Chaos_BlindLength, Chaos_BlindPlayers, true);
	AnnounceChaos("Blind");
}

float g_Aimbot_Duration = 30.0;
Handle g_Aimbot_Timer = INVALID_HANDLE;
Action Chaos_Aimbot(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	
		StopTimer(g_Aimbot_Timer);
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				Aimbot_REMOVE_SDKHOOKS(i);
				ToggleAim(i, false);
			}
		}
	}
	
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_Aimbot_Duration = GetChaosTime("Chaos_Aimbot", 30.0);
	Log("[Chaos] Running: Chaos_Aimbot");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			Aimbot_SDKHOOKS(i);
			ToggleAim(i, true);
		}
	}
	if(g_Aimbot_Duration > 0) g_Aimbot_Timer = CreateTimer(g_Aimbot_Duration, Chaos_Aimbot, true);
	AnnounceChaos("Aimbot");
}

float g_NoSpread_Duration = 25.0;
Handle g_NoSpread_Timer = INVALID_HANDLE;
Action Chaos_NoSpread(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	

		StopTimer(g_NoSpread_Timer);
		cvar("weapon_accuracy_nospread", "0");
		cvar("weapon_recoil_scale", "2");
		if(EndChaos) AnnounceChaos("100\% Weapon Accuracy", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	g_NoSpread_Duration = GetChaosTime("Chaos_NoSpread", 25.0);
	Log("[Chaos] Running: Chaos_NoSpread");
	
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");
	AnnounceChaos("100\% Weapon Accuracy");
	if(g_NoSpread_Duration > 0) g_NoSpread_Timer = CreateTimer(g_NoSpread_Duration, Chaos_NoSpread, true);

	// weapon_accuracy_nospread "1";
	// weapon_debug_spread_gap "1";
	// weapon_recoil_cooldown "0";
	// weapon_recoil_decay1_exp "99999";
	// weapon_recoil_decay2_exp "99999";
	// weapon_recoil_decay2_lin "99999";
	// weapon_recoil_scale "0";
	// weapon_recoil_suppression_shots "500";
}

float g_IncRecoil_Duration = 25.0;
Handle g_IncRecoil_Timer = INVALID_HANDLE;
Action Chaos_IncreasedRecoil(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	
		StopTimer(g_IncRecoil_Timer);
		cvar("weapon_recoil_scale", "2");
		if(EndChaos) AnnounceChaos("Increased Recoil", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_IncreasedRecoil");
	cvar("weapon_recoil_scale", "10");
	AnnounceChaos("Increased Recoil");
	if(g_IncRecoil_Duration > 0) g_IncRecoil_Timer = CreateTimer(g_IncRecoil_Duration, Chaos_IncreasedRecoil, true);
}

float g_ReverseRecoil_Duration = 25.0;
Handle g_ReverseRecoil_Timer = INVALID_HANDLE;
Action Chaos_ReversedRecoil(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){	
		StopTimer(g_ReverseRecoil_Timer);
		cvar("weapon_recoil_scale", "2");
		if(EndChaos) AnnounceChaos("Reversed Recoil", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_ReversedRecoil");
	cvar("weapon_recoil_scale", "-5");
	AnnounceChaos("Reversed Recoil");
	if(g_ReverseRecoil_Duration > 0) g_ReverseRecoil_Timer = CreateTimer(g_ReverseRecoil_Duration, Chaos_ReversedRecoil, true);
}

void Chaos_Jackpot(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	// if(g_ClearChaos){	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetClientMoney(i, 16000);
	Log("[Chaos] Running: Chaos_Jackpot");
	AnnounceChaos("Jackpot");
}

void Chaos_Bankrupt(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	// if(g_ClearChaos){}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetClientMoney(i, 0, true);
	Log("[Chaos] Running: Chaos_Bankrupt");
	AnnounceChaos("Bankrupt");
}

//TODO: chnage to a giverandomplayer function so i can ignite random player or something
void Chaos_SlayRandomPlayer(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	// if(g_ClearChaos){}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_SlayRandomPlayer");

	int aliveT = 0;
	int aliveCT = 0;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			if(GetClientTeam(i) == CS_TEAM_CT) aliveCT++;
			if(GetClientTeam(i) == CS_TEAM_T) aliveT++;
		}
	}
	int RandomTSlay = GetRandomInt(1, aliveT);
	int RandomCTSlay = GetRandomInt(1, aliveCT);

	if(aliveT > 1){
		aliveT = 0;
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i) && IsPlayerAlive(i)){
				if(GetClientTeam(i) == CS_TEAM_T){
					aliveT++;
					if(aliveT == RandomTSlay){
						ForcePlayerSuicide(i);
					}
				}
			}
		}
	}
	if(aliveCT > 1){
		aliveCT = 0;
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i) && IsPlayerAlive(i)){
				if(GetClientTeam(i) == CS_TEAM_CT){
					aliveCT++;
					if(aliveCT == RandomCTSlay){
						if(aliveCT){
							ForcePlayerSuicide(i);
						}
					}
				}
			}
		}
	}
	if(aliveCT < 2 && aliveT < 2){
		RetryEvent();
	}else{
		AnnounceChaos("Slay Random Player On Each Team");
	}
}


void Chaos_Healthshot(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_Healthshot");
	int amount = GetRandomInt(1,3);
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			for(int j = 1; j <= amount; j++){
				GivePlayerItem(i, "weapon_healthshot");
			}
		}
	}
	AnnounceChaos("Healthshots");
}


float g_AlienKnifeFight_Expire = 15.0;
Handle g_AlienKnifeFightTimer = INVALID_HANDLE;
Action Chaos_AlienModelKnife(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_AlienKnifeFightTimer);
		g_KnifeFight = false;
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				SetEntPropFloat(i, Prop_Send, "m_flModelScale", 1.0);
				SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0);
				SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			}
		}
		if(EndChaos) AnnounceChaos("Alien Knife Fight", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_AlienKnifeFight_Expire = GetChaosTime("Chaos_AlienModelKnife", 15.0);
	Log("[Chaos] Running: Chaos_AlienModelKnife");
	//hitboxes are tiny, but knives work fine
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			SetEntPropFloat(i, Prop_Send, "m_flModelScale", 0.5);
			// SetEntProp(i, Prop_Send, "m_ScaleType", 5); //TODO EXPERIEMNT WITH
			SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0*0.55);
		}
	}
	if(g_AlienKnifeFight_Expire > 0) g_AlienKnifeFightTimer = CreateTimer(g_AlienKnifeFight_Expire, Chaos_AlienModelKnife, true);
	g_KnifeFight = true;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 2.0);
			FakeClientCommand(i, "use weapon_knife");
		}
	}
	AnnounceChaos("Alien Knife Fight");
}

float g_LightsOff_Duration = 30.0;
Handle g_LightsOff_Timer = INVALID_HANDLE;
Action Chaos_LightsOff(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_LightsOff_Timer);
		AcceptEntityInput(FogIndex, "TurnOff");
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;

	if(FogIndex != -1){
		g_LightsOff_Duration = GetChaosTime("Chaos_LightsOff", 30.0);
		Log("[Chaos] Running: Chaos_LightsOff");
		DispatchKeyValue(FogIndex, "fogcolor", "0 0 0");
		DispatchKeyValueFloat(FogIndex, "fogend", 0.0);
		DispatchKeyValueFloat(FogIndex, "fogmaxdensity", 0.9989);
		// DispatchKeyValueFloat(FogIndex, "fogmaxdensity", 0.998);
		DispatchKeyValueFloat(FogIndex, "farz", -1.0);
		AnnounceChaos("Who turned the lights off?");
		AcceptEntityInput(FogIndex, "TurnOn");
		if(g_LightsOff_Duration  > 0) g_LightsOff_Timer = CreateTimer(g_LightsOff_Duration, Chaos_LightsOff, true);
		//Random chance for night vision? or separate chaos

	}else{
		Log("[Chaos] Couldn't find fog index");
		RetryEvent();
	}
}

void Chaos_NightVision(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i) && IsPlayerAlive(i)){
				SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
			}
		}
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_NightVision");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && IsPlayerAlive(i)){
			GivePlayerItem(i, "item_nvgs");
			FakeClientCommand(i, "nightvision");
		}
	}
	AnnounceChaos("Night Vision");
}


float g_NormalWhiteFog_Duration = 45.0;
Handle g_NormalWhiteFog_Timer = INVALID_HANDLE;
Action Chaos_NormalWhiteFog(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_NormalWhiteFog_Timer);
		AcceptEntityInput(FogIndex, "TurnOff");
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_NormalWhiteFog_Duration = GetChaosTime("Chaos_NormalWhiteFog", 45.0);
	Log("[Chaos] Running: Chaos_NormalWhiteFog");

	if(FogIndex != -1){
		DispatchKeyValue(FogIndex, "fogcolor", "255 255 255");
		DispatchKeyValueFloat(FogIndex, "fogend", 800.0);
		DispatchKeyValueFloat(FogIndex, "fogmaxdensity", 0.8);
		DispatchKeyValueFloat(FogIndex, "farz", -1.0);
		AcceptEntityInput(FogIndex, "TurnOn");
		AnnounceChaos("Fog");
		if(g_NormalWhiteFog_Duration > 0) g_NormalWhiteFog_Timer = CreateTimer(g_NormalWhiteFog_Duration, Chaos_NormalWhiteFog, true);
	}else{
		Log("[Chaos] Couldn't find fog index");
		RetryEvent();
	}
}

float g_ExtremeWhiteFog_Duration = 45.0;
Handle g_ExtremeWhiteFog_Timer = INVALID_HANDLE;
Action Chaos_ExtremeWhiteFog(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_ExtremeWhiteFog_Timer);
		AcceptEntityInput(FogIndex, "TurnOff");
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_ExtremeWhiteFog_Duration = GetChaosTime("Chaos_NormalWhiteFog", 45.0);
	Log("[Chaos] Running: Chaos_NormalWhiteFog");

	if(FogIndex != -1){
		DispatchKeyValue(FogIndex, "fogcolor", "255 255 255");
		DispatchKeyValueFloat(FogIndex, "fogend", 400.0);
		DispatchKeyValueFloat(FogIndex, "fogmaxdensity", 1.0);
		DispatchKeyValueFloat(FogIndex, "farz", -1.0);
		AcceptEntityInput(FogIndex, "TurnOn");
		AnnounceChaos("Fog");
		if(g_ExtremeWhiteFog_Duration > 0) g_NormalWhiteFog_Timer = CreateTimer(g_ExtremeWhiteFog_Duration, Chaos_ExtremeWhiteFog, true);
	}else{
		Log("[Chaos] Couldn't find fog index");
		RetryEvent();
	}
}

void Chaos_RandomSkybox(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	//todo: disable effect on dust2
	Log("[Chaos] Running: Chaos_RandomSkybox");
	int randomSkyboxIndex = GetRandomInt(0, sizeof(skyboxes)-1);
	DispatchKeyValue(0, "skyname", skyboxes[randomSkyboxIndex]);
	AnnounceChaos("Random Skybox");
}

float g_LowRender_Duration = 30.0;
Handle g_LowRender_Timer = INVALID_HANDLE;
Action Chaos_LowRenderDistance(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		StopTimer(g_LowRender_Timer);
		DispatchKeyValueFloat(FogIndex, "farz", -1.0);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_LowRender_Duration = GetChaosTime("Chaos_LowRenderDistance", 30.0);
	Log("[Chaos] Running: Chaos_LowRenderDistance");
	if(FogIndex != -1){
		DispatchKeyValueFloat(FogIndex, "farz", 450.0);
		AnnounceChaos("Low Render Distance");
		if(g_LowRender_Duration > 0 ) g_LowRender_Timer = CreateTimer(g_LowRender_Duration, Chaos_LowRenderDistance, true);
	}else{
		Log("[Chaos] Couldn't find fog index");
		RetryEvent();
	}
}


float g_Thirdperson_Expire = 15.0;
Handle g_Thirdperson_Timer = INVALID_HANDLE;
Action Chaos_Thirdperson(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) ClientCommand(i, "firstperson");
		cvar("sv_allow_thirdperson", "0");
		StopTimer(g_Thirdperson_Timer);
		if(EndChaos) AnnounceChaos("Firstperson");
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_Thirdperson_Expire = GetChaosTime("Chaos_Thirdperson", 15.0);
	Log("[Chaos] Running: Chaos_Thirdperson");
	StopTimer(g_Thirdperson_Timer);
	cvar("sv_allow_thirdperson", "1");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "thirdperson");
		}
	}
	if(g_Thirdperson_Expire > 0) g_Thirdperson_Timer = CreateTimer(20.0, Chaos_Thirdperson, true);
	AnnounceChaos("Thirdperson");
}

void Chaos_SmokeMap(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){

	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	Log("[Chaos] Running: Chaos_SmokeMap");
	if(g_MapCoordinates == INVALID_HANDLE){
		RetryEvent();
		return;
	}
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			// vec[2] = vec[2] - 64;
			CreateParticle("explosion_smokegrenade_fallback", vec);
		}
	}
	AnnounceChaos("Smoke Strat");
}

float g_InfiniteAmmo_Expire = 20.0;
Handle g_ChaosInfiniteAmmoTimer = INVALID_HANDLE;
Action Chaos_InfiniteAmmo(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos || EndChaos){
		cvar("sv_infinite_ammo", "0");
		StopTimer(g_ChaosInfiniteAmmoTimer);
		if(EndChaos) AnnounceChaos("Limited Ammo", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_InfiniteAmmo_Expire = GetChaosTime("Chaos_InfiniteAmmo", 20.0);
	Log("[Chaos] Running: Chaos_InfiniteAmmo");
	cvar("sv_infinite_ammo", "1");
	if(g_InfiniteAmmo_Expire > 0) g_ChaosInfiniteAmmoTimer = CreateTimer(g_InfiniteAmmo_Expire, Chaos_InfiniteAmmo, true);
	AnnounceChaos("Infinite Ammo");
}


void Chaos_DropCurrentWeapon(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
	
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "drop");
		}
	}
	AnnounceChaos("Drop Current Weapon");
}

void Chaos_DropPrimaryWeapon(){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }}
	if(g_ClearChaos){
	
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "slot1; drop");
		}
	}
	AnnounceChaos("Drop Primary Weapon");
}


float g_Invis_Expire = 15.0;
Handle g_Invis_Timer = INVALID_HANDLE;
Action Chaos_Invis(Handle timer = null, bool EndChaos = false){
	if(g_CountingChaos) {	g_Chaos_Event_Count++;	if(!g_DecidingChaos) {  return;  }} //TODO return this info in another function
	if(g_ClearChaos || EndChaos){
		for(int  client = 0;  client <= MaxClients;  client++){
			if(IsValidClient(client)){
				//todo: doesnt resest on rounbd end?
				// SetEntityRenderMode(client , RENDER_NORMAL);
				// SetEntityRenderColor(client, 255, 255, 255, 255);
			}
		}
		StopTimer(g_Invis_Timer);
		if(EndChaos) AnnounceChaos("Where did everyone go?", true);
	}
	if(g_ClearChaos || !g_DecidingChaos || (g_Chaos_Event_Count != g_RandomEvent)) return;
	g_Invis_Expire = GetChaosTime("Chaos_Invis", 15.0);
	Log("[Chaos] Running: Chaos_Invis");
	int alpha = 50;
	if(g_Invis_Expire > 0) alpha = 0;
	cvar("sv_disable_immunity_alpha", "1");
	for(int  client = 0;  client <= MaxClients;  client++){
		if(IsValidClient(client)){
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 255, 255, alpha);
		}
	}
	//Perhaps it can fade in and out, full invis for 5 seconds, then transition to visible for 10 seconds, back to invis, etc.
	//Various timers that slowly increase or giveaway positions.
	AnnounceChaos("Where did everyone go?");
	if(g_Invis_Expire > 0) g_Invis_Timer = CreateTimer(g_Invis_Expire, Chaos_Invis, true);
}
