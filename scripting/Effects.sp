Handle g_RapidFire_Timer = INVALID_HANDLE;
bool g_bRapidFire = false;
float g_RapidFire_Rate = 0.7;
Action Chaos_RapidFire(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("weapon_accuracy_nospread", "0");
		cvar("weapon_recoil_scale", "2");
		g_bRapidFire = false;
		StopTimer(g_RapidFire_Timer);
		if(EndChaos) AnnounceChaos("Rapid Fire", -1.0, true);
	}
	if(DecidingChaos("Chaos_RapidFire")) return;
	if(CurrentlyActive(g_RapidFire_Timer)) return; //will retry event in that function
	
	Log("[Chaos] Running: Rapid Fire");

	g_bRapidFire = true;
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");

	float duration = GetChaosTime("Chaos_RapidFire", 25.0);
	if(duration > 0) g_RapidFire_Timer = CreateTimer(duration, Chaos_RapidFire, true);

	AnnounceChaos("Rapid Fire", duration);
}

Handle g_BreakTime_Timer = INVALID_HANDLE;
Action Chaos_BreakTime(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_accelerate", "5.5");
		cvar("sv_airaccelerate", "12");
		StopTimer(g_BreakTime_Timer);
		if(EndChaos) AnnounceChaos("Break Over", -1.0,  true);
	}
	if(DecidingChaos("Chaos_BreakTime")) return;
	if(CurrentlyActive(g_BreakTime_Timer)) return;

	Log("[Chaos] Running: Chaos_BreakTime");
	
	cvar("sv_accelerate", "0");
	cvar("sv_airaccelerate", "0");

	float duration = GetChaosTime("Chaos_BreakTime", 10.0);
	if(duration > 0) g_BreakTime_Timer = CreateTimer(duration, Chaos_BreakTime, true);
	
	//todo set m_movement to 0 so no one can do anything, potentially stop shooting?
	AnnounceChaos("Break Time!", duration);
}

Handle FakeTeleport_Timer = INVALID_HANDLE;
float FakeTelport_loc[MAXPLAYERS+1][3];
void Chaos_FakeTeleport(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){
		StopTimer(FakeTeleport_Timer);
	}
	if(DecidingChaos("Chaos_FakeTeleport")) return;
	if(CurrentlyActive(FakeTeleport_Timer)) return;

	Log("[Chaos] Running: Fake Teleport");

	float duration = 3.0;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			FakeTelport_loc[i] = vec;
		}
	}
	DoRandomTeleport();

	FakeTeleport_Timer = CreateTimer(duration, Timer_ResetFakeTeleport);
}
public Action Timer_ResetFakeTeleport(Handle timer){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			vec = FakeTelport_loc[i];
			TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
		}
	}
	AnnounceChaos("Fake Teleport", -1.0);
	FakeTeleport_Timer = INVALID_HANDLE;
}

void Chaos_Soccerballs(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){
	}
	if(DecidingChaos("Chaos_Soccerballs")) return;
	Log("[Chaos] Running: Chaos_Soccerballs");
	
	cvar("sv_turbophysics", "100");

	char MapName[128];
	GetCurrentMap(MapName, sizeof(MapName));
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			if(DistanceToClosestPlayer(vec) > 50){
				int ent = CreateEntityByName("prop_physics_multiplayer");
				SetEntityModel(ent, "models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl");
				DispatchKeyValue(ent, "StartDisabled", "false");
				DispatchKeyValue(ent, "Solid", "6");
				DispatchKeyValue(ent, "spawnflags", "1026");
				
				TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(ent);
				AcceptEntityInput(ent, "TurnOn", ent, ent, 0);
				AcceptEntityInput(ent, "EnableCollision");
				SetEntProp(ent, Prop_Data, "m_CollisionGroup", 5);
				SetEntityMoveType(ent, MOVETYPE_VPHYSICS);
			}
		}
	}

	AnnounceChaos("Soccer balls", -1.0);
}

Handle g_NoCrossHair_Timer = INVALID_HANDLE;
Action Chaos_NoCrosshair(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_NoCrossHair_Timer);
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
			}
		}
		if(EndChaos) AnnounceChaos("No Crosshair", -1.0, true);
	}
	if(DecidingChaos("Chaos_NoCrosshair")) return;
	if(CurrentlyActive(g_NoCrossHair_Timer)) return;

	Log("[Chaos] Running: Chaos_NoCrosshair");

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
		}
	}

	float duration = GetChaosTime("Chaos_NoCrosshair", 25.0);
	if(duration > 0) g_NoCrossHair_Timer = CreateTimer(duration, Chaos_NoCrosshair, true);

	AnnounceChaos("No Crosshair", duration);
}

bool g_bLag = true;
void Chaos_FakeCrash(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){    }
	if(DecidingChaos("Chaos_FakeCrash")) return;
	Log("[Chaos] Running: Chaos_FakeCrash");
	AnnounceChaos("Fake Crash", -1.0);
	g_bLag = true;
	CreateTimer(1.0, Timer_nolag);
	while(g_bLag){
		if(!g_bLag) break;
	}
}
public Action Timer_nolag(Handle timer){
	g_bLag = false;
}


Handle g_DisableRadar_Timer = INVALID_HANDLE;
Action Chaos_DisableRadar(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_disable_radar", "0");
		StopTimer(g_DisableRadar_Timer);
	}
	if(DecidingChaos("Chaos_DisableRadar")) return;
	if(CurrentlyActive(g_DisableRadar_Timer)) return;

	Log("[Chaos] Running: Chaos_DisableRadar");

	cvar("sv_disable_radar", "1");
	
	float duration = GetChaosTime("Chaos_DisableRadar", 20.0);
	if(duration > 0) g_DisableRadar_Timer = CreateTimer(duration, Chaos_DisableRadar, true);

	AnnounceChaos("No Radar", duration);
}

void Chaos_SpawnFlashbangs(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){    }
	if(DecidingChaos("Chaos_SpawnFlashbangs")) return;

	Log("[Chaos] Running: Chaos_SpawnFlashbangs");

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec, sizeof(vec));
			if(DistanceToClosestPlayer(vec) > 25){
				int flash = CreateEntityByName("flashbang_projectile");
				TeleportEntity(flash, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(flash);
			}
		}
	}

	AnnounceChaos("Spawn Flashbangs", -1.0);
}

Handle g_SuperJump_Timer = INVALID_HANDLE;
Action Chaos_SuperJump(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_jump_impulse", "301");
		StopTimer(g_SuperJump_Timer);
	}
	if(DecidingChaos("Chaos_SuperJump")) return;
	if(CurrentlyActive(g_SuperJump_Timer)) return;

	Log("[Chaos] Running: Chaos_SuperJump");
	
	cvar("sv_jump_impulse", "590");
	
	float duration = GetChaosTime("Chaos_SuperJump", 20.0);
	if(duration > 0.0) g_SuperJump_Timer = CreateTimer(duration, Chaos_SuperJump, true);

	AnnounceChaos("Super Jump", duration);
}



Handle g_Juggernaut_Timer = INVALID_HANDLE;
char g_OriginalModels_Jugg[MAXPLAYERS + 1][PLATFORM_MAX_PATH+1];
//https://forums.alliedmods.net/showthread.php?t=307674 thanks for prop_send 
bool g_bSetJuggernaut = false;
Action Chaos_Juggernaut(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_Juggernaut_Timer);
		if(g_bSetJuggernaut){
			g_bSetJuggernaut = false;
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
	if(DecidingChaos("Chaos_Juggernaut")) return;
	if(CurrentlyActive(g_Juggernaut_Timer)) return;

	Log("[Chaos] Running: Chaos_Juggernaut");

	cvar("mp_weapons_allow_heavyassaultsuit", "1");
	g_bSetJuggernaut = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientModel(i, g_OriginalModels_Jugg[i], sizeof(g_OriginalModels_Jugg[]));
			GivePlayerItem(i, "item_heavyassaultsuit");
		}
	}

	float duration = GetChaosTime("Chaos_Juggernaut", 30.0);
	if(duration > 0) g_Juggernaut_Timer = CreateTimer(duration, Chaos_Juggernaut, true);

	AnnounceChaos("Juggernauts", duration);
}


void Chaos_SpawnExplodingBarrels(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){    }
	if(DecidingChaos("Chaos_SpawnExplodingBarrels")) return;
	Log("[Chaos] Running: Chaos_SpawnExplodingBarrels");

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec, sizeof(vec));
			if(DistanceToClosestPlayer(vec) > 50){
				int barrel = CreateEntityByName("prop_exploding_barrel");
				TeleportEntity(barrel, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(barrel);
			}
		}
	}

	AnnounceChaos("Exploding Barrels", -1.0);
}


Handle g_InsaneStrafe_Timer = INVALID_HANDLE;
Action Chaos_InsaneAirSpeed(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_air_max_wishspeed", "30");
		cvar("sv_airaccelerate", "12");
		StopTimer(g_InsaneStrafe_Timer);
	}
	if(DecidingChaos("Chaos_InsaneAirSpeed")) return;
	if(CurrentlyActive(g_InsaneStrafe_Timer)) return;

	Log("[Chaos] Running: Chaos_InsaneAirSpeed");
	
	cvar("sv_air_max_wishspeed", "2000");
	cvar("sv_airaccelerate", "2000");
	
	float duration = GetChaosTime("Chaos_InsaneAirSpeed", 20.0);
	if(duration > 0) g_InsaneStrafe_Timer = CreateTimer(duration, Chaos_InsaneAirSpeed, true);

	AnnounceChaos("Extreme Strafe Acceleration", duration);
}

void Chaos_RespawnDead_LastLocation(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){    }
	if(DecidingChaos("Chaos_RespawnDead_LastLocation")) return;
	Log("[Chaos] Running: Chaos_RespawnDead_LastLocation");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			if(g_PlayerDeathLocations[i][0] != 0.0 && g_PlayerDeathLocations[i][1] != 0.0 && g_PlayerDeathLocations[i][2] != 0.0){ //safety net for any players that joined mid round
				TeleportEntity(i, g_PlayerDeathLocations[i], NULL_VECTOR, NULL_VECTOR);
			}
		}
	}
	AnnounceChaos("Resurrect players where they died", -1.0);
}

Handle g_Drugs_Timer = INVALID_HANDLE;
Action Chaos_Drugs(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		KillAllDrugs();
		StopTimer(g_Drugs_Timer);
	}
	if(DecidingChaos("Chaos_Drugs")) return;
	if(CurrentlyActive(g_Drugs_Timer)) return;

	Log("[Chaos] Running: Chaos_Drugs");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) CreateDrug(i);

	float duration = GetChaosTime("Chaos_Drugs", 10.0);
	if(duration > 0) g_Drugs_Timer = CreateTimer(duration, Chaos_Drugs, true);
	
	AnnounceChaos("Drugs", duration);
}


Handle g_EnemyRadar_Timer = INVALID_HANDLE;
Action Chaos_EnemyRadar(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("mp_radar_showall", "0");
		StopTimer(g_EnemyRadar_Timer);
	}
	if(DecidingChaos("Chaos_EnemyRadar")) return;
	if(CurrentlyActive(g_EnemyRadar_Timer)) return;

	Log("[Chaos] Running: Chaos_EnemyRadar");

	cvar("mp_radar_showall", "1");

	float duration = GetChaosTime("Chaos_EnemyRadar", 25.0);
	if(duration > 0) g_EnemyRadar_Timer = CreateTimer(duration, Chaos_EnemyRadar, true);
	
	AnnounceChaos("Enemy Radar", duration);
}

void Chaos_Give100HP(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_Give100HP")) return;

	Log("[Chaos] Running: Chaos_Give100HP");
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			int currenthealth = GetClientHealth(i);
			SetEntityHealth(i, currenthealth + 100);
		}
	}

	AnnounceChaos("Give all players +100 HP", -1.0);
}


void Chaos_HealAllPlayers(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_HealAllPlayers")) return;

	Log("[Chaos] Running: Chaos_HealAllPlayers");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntityHealth(i, 100);
		}
	}
	
	AnnounceChaos("Set all players health to 100", -1.0);
}

Handle g_BuyAnywhere_Timer = INVALID_HANDLE;
Action Chaos_BuyAnywhere(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("mp_buy_anywhere", "0");
		cvar("mp_buytime", "20");
		StopTimer(g_BuyAnywhere_Timer);
	}
	if(DecidingChaos("Chaos_BuyAnywhere")) return;
	if(CurrentlyActive(g_BuyAnywhere_Timer)) return;

	Log("[Chaos] Running: Chaos_BuyAnywhere");
	
	cvar("mp_buy_anywhere", "1");
	cvar("mp_buytime", "999");

	float duration = GetChaosTime("Chaos_BuyAnywhere", 20.0);
	if(duration > 0.0) g_BuyAnywhere_Timer = CreateTimer(duration, Chaos_BuyAnywhere, true);
	
	AnnounceChaos("Buy Anywhere Enabled", duration);
}

// float g_SimonSays_Duration = 10.0;
void Chaos_SimonSays(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){
		g_bSimon_Active = false;
		KillMessageTimer();
	}
	if(DecidingChaos("Chaos_SimonSays")) return;
	if(CurrentlyActive(g_SimonSays_Timer)) return;

	Log("[Chaos] Running: Chaos_SimonSays");

	float duration = GetChaosTime("Chaos_SimonSays", 10.0);
	GenerateSimonOrder(duration);
	StartMessageTimer();
	g_bSimon_Active = true;
}

Handle g_ExplosiveBullets_Timer = INVALID_HANDLE;
Action Chaos_ExplosiveBullets(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_ExplosiveBullets_Timer);
		g_bExplosiveBullets = false;
	}
	if(DecidingChaos("Chaos_ExplosiveBullets")) return;
	if(CurrentlyActive(g_ExplosiveBullets_Timer)) return;

	Log("[Chaos] Running: Chaos_ExplosiveBullets");
	
	g_bExplosiveBullets = true;
	
	float duration = GetChaosTime("Chaos_ExplosiveBullets", 15.0);
	if(duration > 0) g_ExplosiveBullets_Timer = CreateTimer(duration, Chaos_ExplosiveBullets, true);

	AnnounceChaos("Explosive Bullets", duration);
}

bool g_bSpeedShooter = false;
Handle g_bSpeedShooter_Timer = INVALID_HANDLE;
//todo, if someone has speed once this ends, they still have speed
// > try saving their old speed but itll still be fucky
Action Chaos_SpeedShooter(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_bSpeedShooter_Timer);
		g_bSpeedShooter = false;
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++){
				if(ValidAndAlive(i)){
					SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
				}
			}
			AnnounceChaos("Speed Shooter", -1.0, true);
		}
	}
	if(DecidingChaos("Chaos_SpeedShooter")) return;
	if(CurrentlyActive(g_bSpeedShooter_Timer)) return;

	Log("[Chaos] Running: Chaos_SpeedShooter");

	g_bSpeedShooter = true;

	float duration = GetChaosTime("Chaos_SpeedShooter", 10.0);
	if(duration > 0) g_bSpeedShooter_Timer = CreateTimer(duration, Chaos_SpeedShooter, true);
	
	AnnounceChaos("Speed Shooter", duration);
}

float zero_vector[3] = {0.0, 0.0, 0.0};
void Chaos_ResetSpawns(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_ResetSpawns")) return;
	Log("[Chaos] Running: Chaos_ResetSpawns");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			if(g_OriginalSpawnVec[i][0] != 0.0 && g_OriginalSpawnVec[i][1] != 0.0 && g_OriginalSpawnVec[i][2] != 0.0){
				TeleportEntity(i, g_OriginalSpawnVec[i], NULL_VECTOR, zero_vector);
			}
		}
	}
	
	AnnounceChaos("Teleport all players back to spawn", -1.0);
}

bool g_bNoStrafe = false;
Handle g_NoStrafe_Timer = INVALID_HANDLE;
Action Chaos_DisableStrafe(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bNoStrafe = false;

		StopTimer(g_NoStrafe_Timer);
		if(EndChaos) AnnounceChaos("Normal Left/Right Movement", -1.0, true);
	}
	if(DecidingChaos("Chaos_DisableStrafe")) return;
	if(CurrentlyActive(g_NoStrafe_Timer)) return;
	
	Log("[Chaos] Running: Chaos_DisableStrafe");

	g_bNoStrafe = true;

	float duration = GetChaosTime("Chaos_DisableStrafe", 20.0);
	if(duration > 0.0) g_NoStrafe_Timer = CreateTimer(duration, Chaos_DisableStrafe, true);
	
	AnnounceChaos("Disable Left/Right Movement", duration);
}

bool g_bNoForwardBack = false;
Handle g_NoForwardBack_Timer = INVALID_HANDLE;
Action Chaos_DisableForwardBack(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bNoForwardBack = false;
		StopTimer(g_NoForwardBack_Timer);
		if(EndChaos) AnnounceChaos("Normal Forward/Backward Movement", -1.0, true);
	}
	if(DecidingChaos("Chaos_DisableForwardBack")) return;
	if(CurrentlyActive(g_NoForwardBack_Timer)) return;

	Log("[Chaos] Running: Chaos_DisableForwardBack");
	
	g_bNoForwardBack = true;
	
	float duration = GetChaosTime("Chaos_DisableForwardBack", 20.0);
	if(duration > 0) g_NoForwardBack_Timer = CreateTimer(duration, Chaos_DisableForwardBack, true);
	
	AnnounceChaos("Disable W / S Keys", duration);
}

bool g_bJumping = false;
Handle g_Jumping_Timer_Repeat = INVALID_HANDLE;
Handle g_Jumping_Timer = INVALID_HANDLE;
Action Chaos_Jumping(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bJumping = false;
		StopTimer(g_Jumping_Timer_Repeat);
		StopTimer(g_Jumping_Timer);
	}
	if(DecidingChaos("Chaos_Jumping")) return;
	if(CurrentlyActive(g_Jumping_Timer)) return;

	Log("[Chaos] Running: Chaos_Jumping");

	StopTimer(g_Jumping_Timer_Repeat);
	g_bJumping = true;
	
	float duration = GetChaosTime("Chaos_Jumping", 15.0);
	if(duration > 0) g_Jumping_Timer = CreateTimer(duration, Chaos_Jumping, true);
	g_Jumping_Timer_Repeat = CreateTimer(0.3, Timer_ForceJump, _, TIMER_REPEAT);
	
	AnnounceChaos("Jumping!", duration);
}

public Action Timer_ForceJump(Handle timer){
	if(g_bJumping){
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


bool g_bDiscoFog = false;
Handle g_DiscoFog_Timer_Repeat = INVALID_HANDLE;
Handle g_DiscoFog_Timer = INVALID_HANDLE;
Action Chaos_DiscoFog(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_DiscoFog_Timer_Repeat);
		StopTimer(g_DiscoFog_Timer);
		g_bDiscoFog = false;
		Fog_OFF();
	}
	if(DecidingChaos("Chaos_DiscoFog")) return;
	if(CurrentlyActive(g_DiscoFog_Timer)) return;

	Log("[Chaos] Running: Chaos_DiscoFog");
	
	DiscoFog();

	g_bDiscoFog = true;
	g_DiscoFog_Timer_Repeat = CreateTimer(1.0, Timer_NewFogColor, _,TIMER_REPEAT);

	float duration = GetChaosTime("Chaos_DiscoFog", 25.0);
	if(duration > 0) g_DiscoFog_Timer = CreateTimer(duration, Chaos_DiscoFog, true);
	
	AnnounceChaos("Disco Fog", duration);
}

public Action Timer_NewFogColor(Handle timer){
	if(g_bDiscoFog){
		char color[32];
		FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
		DispatchKeyValue(g_iFog, "fogcolor", color);
	}else{
		StopTimer(g_DiscoFog_Timer_Repeat);
	}
}


Handle g_OneBuilletOneGun_Timer = INVALID_HANDLE;
bool g_bOneBulletOneGun = false;
Action Chaos_OneBulletOneGun(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		g_bOneBulletOneGun = false;
		StopTimer(g_OneBuilletOneGun_Timer);
		if(EndChaos) AnnounceChaos("One Bullet One Gun", -1.0, true);
	}
	if(DecidingChaos("Chaos_OneBulletOneGun")) return;
	if(CurrentlyActive(g_OneBuilletOneGun_Timer)) return;

	Log("[Chaos] Running: Chaos_OneBulletOneGun");

	g_bOneBulletOneGun = true; //handled somehwere in events.sp

	float duration = GetChaosTime("Chaos_OneBulletOneGun", 15.0);
	if(duration > 0) g_OneBuilletOneGun_Timer = CreateTimer(duration, Chaos_OneBulletOneGun, true);
	
	AnnounceChaos("One Bullet One Gun", duration);
}

float g_Earthquake_Duration = 7.0;
void Chaos_Earthquake(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){    }
	if(DecidingChaos("Chaos_Earthquake")) return;

	Log("[Chaos] Running: Chaos_Earthquake");
	
	g_Earthquake_Duration = GetChaosTime("Chaos_Earthquake", 5.0);
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ScreenShake(i, _, g_Earthquake_Duration);
		}
	}

	AnnounceChaos("Earthquake", -1.0);
}


Handle g_ChickenPlayers_Timer = INVALID_HANDLE;
Action Chaos_ChickenPlayers(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_ChickenPlayers_Timer);
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) DisableChicken(i);
		}
	}
	if(DecidingChaos("Chaos_ChickenPlayers")) return;
	if(CurrentlyActive(g_ChickenPlayers_Timer)) return;

	Log("[Chaos] Running: Chaos_ChickenPlayers");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetChicken(i);

	float duration = GetChaosTime("Chaos_ChickenPlayers", 20.0);
	if(duration > 0) g_ChickenPlayers_Timer = CreateTimer(duration, Chaos_ChickenPlayers, true);
	
	AnnounceChaos("Make all players a chicken", duration);
}


void Chaos_IgnitePlayer(bool forceAllPlayers = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){    }
	if(DecidingChaos("Chaos_IgnitePlayer")) return;

	Log("[Chaos] Running: Chaos_IgnitePlayer");
	
	int randomchance = GetRandomInt(1,100);
	if(randomchance <= 25 || forceAllPlayers){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				IgniteEntity(i, 10.0);
			}
		}
		AnnounceChaos("Ignite All Players", -1.0);
	}else{
		int player = getRandomAlivePlayer();
		if(player != -1 && ValidAndAlive(player)){
			IgniteEntity(player, 10.0);
			char msg[128];
			FormatEx(msg, sizeof(msg), "Ignite {orange}%N", player);
			AnnounceChaos(msg, -1.0);
		}else{
			Chaos_IgnitePlayer(true);
		}
	}
}

Handle g_LockPlayersAim_Timer = INVALID_HANDLE; //keeps track of when to end the event
bool g_bLockPlayersAim_Active = false;
float g_LockPlayersAim_Angles[MAXPLAYERS+1][3];
Action Chaos_LockPlayersAim(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		g_bLockPlayersAim_Active = false;
		StopTimer(g_LockPlayersAim_Timer);
		if(EndChaos) AnnounceChaos("Lock Mouse Movement", -1.0, true);
	}
	if(DecidingChaos("Chaos_LockPlayersAim")) return;
	if(CurrentlyActive(g_LockPlayersAim_Timer)) return;

	Log("[Chaos] Running: Chaos_LockPlayersAim");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GetClientEyeAngles(i, g_LockPlayersAim_Angles[i]);

	g_bLockPlayersAim_Active  = true;

	float duration = GetChaosTime("Chaos_LockPlayersAim", 20.0);
	if(duration > 0) g_LockPlayersAim_Timer = CreateTimer(duration, Chaos_LockPlayersAim, true);
	
	AnnounceChaos("Lock Mouse Movement", duration);
}


Handle g_SlowSpeed_Timer = INVALID_HANDLE;
Action Chaos_SlowSpeed(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		if(EndChaos) {
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			AnnounceChaos("Normal Movement Speed", -1.0, true);
		}
		StopTimer(g_SlowSpeed_Timer);
	}
	if(DecidingChaos("Chaos_SlowSpeed")) return;
	if(CurrentlyActive(g_SlowSpeed_Timer)) return;

	Log("[Chaos] Running: Chaos_SlowSpeed");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.5);

	float duration = GetChaosTime("Chaos_SlowSpeed", 20.0);
	if(duration > 0) g_SlowSpeed_Timer = CreateTimer(duration, Chaos_SlowSpeed, true);
	
	AnnounceChaos("0.5x Movement Speed", duration);
}

Handle g_FastSpeed_Timer = INVALID_HANDLE;
Action Chaos_FastSpeed(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			AnnounceChaos("Normal Movement Speed", -1.0, true);
		}
		StopTimer(g_FastSpeed_Timer);
	}
	if(DecidingChaos("Chaos_FastSpeed")) return;
	if(CurrentlyActive(g_FastSpeed_Timer)) return;

	Log("[Chaos] Running: Chaos_FastSpeed");
	
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 3.0);

	float duration = GetChaosTime("Chaos_FastSpeed", 20.0);
	if(duration > 0) g_FastSpeed_Timer = CreateTimer(duration, Chaos_FastSpeed, true);
	
	AnnounceChaos("3x Movement Speed", duration);
}

void Chaos_RespawnTheDead(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_RespawnTheDead")) return;
	Log("[Chaos] Running: Chaos_RespawnTheDead");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)) CS_RespawnPlayer(i);
	}
	AnnounceChaos("Resurrect dead players", -1.0);
}

void Chaos_RespawnTheDead_Randomly(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_RespawnTheDead_Randomly")) return;
	Log("[Chaos] Running: Chaos_RespawnTheDead_Randomly");

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			DoRandomTeleport(i);
		}
	}

	AnnounceChaos("Resurrect dead players in random locations", -1.0);
}

void Chaos_Bumpmines(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_Bumpmines")) return;
	Log("[Chaos] Running: Chaos_Bumpmines");
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GivePlayerItem(i, "weapon_bumpmine");
	AnnounceChaos("Bumpmines", -1.0);
}

Action Chaos_Spin180(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_Spin180")) return;
	Log("[Chaos] Running: Chaos_Spin180");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float angs[3];
			GetClientEyeAngles(i, angs);
			angs[1] = angs[1] + 180;
			TeleportEntity(i, NULL_VECTOR, angs, NULL_VECTOR);
		}
	}
	AnnounceChaos("180 Spin", -1.0);
}

bool g_bPortalGuns = false;
Handle g_PortalGuns_Timer = INVALID_HANDLE;
Action Chaos_PortalGuns(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			TeleportPlayersToClosestLocation();
			AnnounceChaos("Portal Guns", -1.0, true);
		}
		g_bPortalGuns = false;
		StopTimer(g_PortalGuns_Timer);
	}
	if(DecidingChaos("Chaos_PortalGuns")) return;
	if(CurrentlyActive(g_PortalGuns_Timer)) return;

	Log("[Chaos] Running: Chaos_PortalGuns");
	
	g_bPortalGuns = true;
	SavePlayersLocations();

	float duration = GetChaosTime("Chaos_PortalGuns", 20.0);
	if(duration > 0) g_PortalGuns_Timer = CreateTimer(duration, Chaos_PortalGuns, true);
	
	AnnounceChaos("Portal Guns", duration);
}


void Chaos_TeleportFewMeters(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_TeleportFewMeters")) return;

	Log("[Chaos] Running: Chaos_TeleportFewMeters");
	
	SavePlayersLocations();
	TeleportPlayersToClosestLocation(-1, 250); //250 units of minimum teleport distance
	AnnounceChaos("Teleport Players A Few Meters", -1.0);
}



Handle g_InfiniteGrenade_Timer = INVALID_HANDLE;
Action Chaos_InfiniteGrenades(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_InfiniteGrenade_Timer);
		cvar("sv_infinite_ammo", "0");
		if(EndChaos) AnnounceChaos("Infinite Grenades", -1.0,  true);
	}
	if(DecidingChaos("Chaos_InfiniteGrenades")) return;
	if(CurrentlyActive(g_InfiniteGrenade_Timer)) return;
	
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

	float duration = GetChaosTime("Chaos_InfiniteGrenades", 20.0);
	if(duration > 0) g_InfiniteGrenade_Timer = CreateTimer(duration, Chaos_InfiniteGrenades, true);

	AnnounceChaos("Infinite Grenades", duration);
}

void Chaos_Shields(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_Shields")) return;
	Log("[Chaos] Running: Chaos_Shields");
	char playerWeapon[62];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientWeapon(i, playerWeapon, sizeof(playerWeapon));
			int entity = CreateEntityByName("weapon_shield");
			if (entity > 0) {
				EquipPlayerWeapon(i, entity);
				SetEntPropEnt(i, Prop_Data, "m_hActiveWeapon" , entity);
				PrintToChatAll("the weapon is %s", playerWeapon);
				if(StrContains(playerWeapon, "knife", false) != -1){
					FakeClientCommand(i, "use weapon_knife");
					InstantSwitch(i, -1);
				}else{
					FakeClientCommand(i, "use %s", playerWeapon);
					InstantSwitch(i, -1);
				}
			}
		}
	}
	AnnounceChaos("Shields", -1.0);
}


Handle g_IsThisMexico_Timer = INVALID_HANDLE;
Action Chaos_IsThisMexico(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		Fog_OFF();
		if(EndChaos) AnnounceChaos("Is This What Mexico Looks Like?", -1.0, true);
		StopTimer(g_IsThisMexico_Timer);
	}
	if(DecidingChaos("Chaos_IsThisMexico")) return;
	if(CurrentlyActive(g_IsThisMexico_Timer)) return;
	
	Log("[Chaos] Running: Chaos_IsThisMexico");

	Mexico();

	float duration = GetChaosTime("Chaos_IsThisMexico", 30.0);
	if(duration > 0) g_IsThisMexico_Timer = CreateTimer(duration, Chaos_IsThisMexico, true);
	
	AnnounceChaos("Is This What Mexico Looks Like?", duration);
}

Handle g_OneWeaponOnly_Timer = INVALID_HANDLE;
Action Chaos_OneWeaponOnly(Handle timer = null, bool EndChaos = false){
	//todo; change chaos name, but its an event to pick a random weapon, and players are restricted to that weapon for the rest of the round.
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_OneWeaponOnly_Timer);
		g_bPlayersCanDropWeapon = true;
		if(EndChaos) AnnounceChaos("Weapon Drop Re-enabled", -1.0,  true);
	}
	if(DecidingChaos("Chaos_OneWeaponOnly")) return;
	if(CurrentlyActive(g_OneWeaponOnly_Timer)) return;

	Log("[Chaos] Running: Chaos_OneWeaponOnly");
	//todo; might have to handle weapon pickups?.. (players can still buy)
	g_bPlayersCanDropWeapon = false;
	char randomWeapon[64];
	int randomIndex = GetRandomInt(0, sizeof(g_sWeapons)-1);
	randomWeapon = g_sWeapons[randomIndex];
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

	float duration = GetChaosTime("Chaos_OneWeaponOnly", 30.0);
	if(duration > 0) g_OneWeaponOnly_Timer = CreateTimer(duration, Chaos_OneWeaponOnly, true);
	
	AnnounceChaos(chaosMsg, duration);
}

void Chaos_AutoPlantC4(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){
		AutoPlantRoundEnd();
	}
	if(DecidingChaos("Chaos_AutoPlantC4")) return;

	Log("[Chaos] Running: Chaos_AutoPlantC4");

	if(g_bBombPlanted){
		//todo make this a little cleaner
		float newBombPosition[3];
		char newBombSiteName[64];
		if(g_PlantedSite == BOMBSITE_A && bombSiteB != INVALID_HANDLE){
			int randomCoord = GetRandomInt(0, GetArraySize(bombSiteB)-1);
			GetArrayArray(bombSiteB, randomCoord, newBombPosition);
			newBombSiteName = "Bombsite B";
			g_PlantedSite = BOMBSITE_B;
		}else if(g_PlantedSite == BOMBSITE_B && bombSiteA != INVALID_HANDLE){
			int randomCoord = GetRandomInt(0, GetArraySize(bombSiteA)-1);
			GetArrayArray(bombSiteA, randomCoord, newBombPosition);
			newBombSiteName = "Bombsite A";
			g_PlantedSite = BOMBSITE_A;
		}else if(g_PlantedSite == -1 && bombSiteA != INVALID_HANDLE && bombSiteB != INVALID_HANDLE){
			if(GetRandomInt(0,100) <= 50){
				int randomCoord = GetRandomInt(0, GetArraySize(bombSiteA)-1);
				GetArrayArray(bombSiteA, randomCoord, newBombPosition);
				newBombSiteName = "Bombsite A";
				g_PlantedSite = BOMBSITE_A;
			}else{
				int randomCoord = GetRandomInt(0, GetArraySize(bombSiteB)-1);
				GetArrayArray(bombSiteB, randomCoord, newBombPosition);
				newBombSiteName = "Bombsite B";
				g_PlantedSite = BOMBSITE_B;
			}
		}else{
			RetryEvent();
			return;
		}
		int bombEnt = FindEntityByClassname(-1, "planted_c4");
		if(g_iC4ChickenEnt != -1) bombEnt = g_iC4ChickenEnt;
		// newBombPosition[2] = newBombPosition[2] - 64;
		if(bombEnt != -1){
			TeleportEntity(bombEnt, newBombPosition, NULL_VECTOR, NULL_VECTOR);
			char AnnounceMessage[128];
			FormatEx(AnnounceMessage, sizeof(AnnounceMessage), "Teleport bomb to %s", newBombSiteName);
			AnnounceChaos(AnnounceMessage, -1.0);
			return;
		}else{
			g_PlantedSite = -1; //fooked up
		}
		RetryEvent();
		return;
	}
	AutoPlantC4();
	CreateTimer(0.6, Timer_EnsureSpawnedAutoPlant);

}

public Action Timer_EnsureSpawnedAutoPlant(Handle timer){
	if(g_PlantedSite == BOMBSITE_A){
		AnnounceChaos("Auto Plant C4 at Bombsite A", -1.0);
	}else if(g_PlantedSite == BOMBSITE_B){
		AnnounceChaos("Auto Plant C4 at Bombsite B", -1.0);
	}else{
		AnnounceChaos("Auto Plant C4", -1.0);
	}
}

public void Chaos_Impostors(){
	//not to be confused with players into chickesn..
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){
		RemoveChickens();
	}
	if(DecidingChaos("Chaos_Impostors")) return;
	Log("[Chaos] Running: Chaos_Impostors");

	SpawnImpostors();

	AnnounceChaos("Impostors", -1.0);
}

public void Chaos_MamaChook(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){
		RemoveChickens();
	}
	if(DecidingChaos("Chaos_MamaChook")) return;
	Log("[Chaos] Running: Chaos_MamaChook");


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

	AnnounceChaos("Mama Chook", -1.0);
}

public void Chaos_BigChooks(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){
		RemoveChickens();
		g_bCanSpawnChickens = true;
	}
	if(DecidingChaos("Chaos_BigChooks")) return;
	Log("[Chaos] Running: Chaos_BigChooks");


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
	AnnounceChaos("Big Chooks", -1.0);
}

public void Chaos_LittleChooks(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){
		RemoveChickens();
		g_bCanSpawnChickens = true;

	}
	if(DecidingChaos("Chaos_LittleChooks")) return;
	Log("[Chaos] Running: Chaos_LittleChooks");


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
	AnnounceChaos("Lil' Chooks", -1.0);
}


bool g_bOneBulletMag = false;
Handle g_OneBulletMag_Timer = INVALID_HANDLE;
Action Chaos_OneBulletMag(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		g_bOneBulletMag = false;
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
			AnnounceChaos("One Bullet Mags", -1.0, true);
		}

		StopTimer(g_OneBulletMag_Timer);
	}
	if(DecidingChaos("Chaos_OneBulletMag")) return;
	if(CurrentlyActive(g_OneBulletMag_Timer)) return;

	Log("[Chaos] Running: Chaos_OneBulletMag");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			for (int j = 0; j < 2; j++){
				int iTempWeapon = -1;
				if ((iTempWeapon = GetPlayerWeaponSlot(i, j)) != -1) SetClip(iTempWeapon, 1, 1);
			}
		}
	}
	g_bOneBulletMag = true;
	
	float duration = GetChaosTime("Chaos_OneBulletMag", 20.0);
	if(duration > 0) g_OneBulletMag_Timer = CreateTimer(duration, Chaos_OneBulletMag, true);
	
	AnnounceChaos("One Bullet Mags", duration);
}

Handle g_CrabPeople_Timer = INVALID_HANDLE;
bool g_bForceCrouch = false;
Action Chaos_CrabPeople(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		g_bForceCrouch = false;
		StopTimer(g_CrabPeople_Timer);
		if(EndChaos) AnnounceChaos("Crab People", -1.0, true);
	}
	if(DecidingChaos("Chaos_CrabPeople")) return;
	if(CurrentlyActive(g_CrabPeople_Timer)) return;

	Log("[Chaos] Running: Chaos_CrabPeople");
	g_bForceCrouch = true;
	
	float duration = GetChaosTime("Chaos_CrabPeople", 15.0);
	if(duration > 0) g_CrabPeople_Timer = CreateTimer(duration, Chaos_CrabPeople, true);
	
	AnnounceChaos("Crab People", duration);
}

bool g_bNoscopeOnly = false;
Handle g_NoscopeOnly_Timer = INVALID_HANDLE;
Action Chaos_NoScopeOnly(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_NoscopeOnly_Timer);
		g_bNoscopeOnly = false;
		if(EndChaos) AnnounceChaos("You can now scope again", -1.0, true);
	}
	if(DecidingChaos("Chaos_NoScopeOnly")) return;
	if(CurrentlyActive(g_NoscopeOnly_Timer)) return;

	Log("[Chaos] Running: Chaos_NoScopeOnly");
	g_bNoscopeOnly = true;

	float duration = GetChaosTime("Chaos_NoScopeOnly", 20.0);
	if(duration > 0) g_NoscopeOnly_Timer = CreateTimer(duration, Chaos_NoScopeOnly, true);
	
	AnnounceChaos("No scopes only", duration);
}

void Chaos_MoneyRain(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){ cvar("sv_dz_cash_bundle_size", "50"); }
	if(DecidingChaos("Chaos_MoneyRain")) return;
	Log("[Chaos] Running: Chaos_MoneyRain");

	cvar("sv_dz_cash_bundle_size", "500");

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
	AnnounceChaos("Make it rain", -1.0);
}

bool g_bVampireRound = false;
Handle g_Vampire_Timer = INVALID_HANDLE;
Action Chaos_VampireHeal(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_Vampire_Timer);
		g_bVampireRound = false;
		if(EndChaos) AnnounceChaos("Vampires", -1.0, true);
	}
	if(DecidingChaos("Chaos_VampireHeal")) return;
	if(CurrentlyActive(g_Vampire_Timer)) return;

	Log("[Chaos] Running: Chaos_VampireHeal");

	g_bVampireRound = true;

	float duration = GetChaosTime("Chaos_VampireHeal", 30.0);
	if(duration > 0) g_Vampire_Timer = CreateTimer(duration, Chaos_VampireHeal, true);
	
	AnnounceChaos("Vampires", duration);
}


void Chaos_C4Chicken(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){
		g_bC4Chicken = false;
		RemoveChickens();
		g_iC4ChickenEnt = -1;
	}
	if(DecidingChaos("Chaos_C4Chicken")) return;
	Log("[Chaos] Running: Chaos_C4Chicken");

	g_bC4Chicken = true;
	C4Chicken(); //convert any planted c4's to chicken
	AnnounceChaos("C4 Chicken", -1.0);
}

//tood; buggy if you still have other nades?
bool g_bDecoyDodgeball = false;
Handle g_DecoyDodgeball_Timer = INVALID_HANDLE;
Handle g_DecoyDodgeball_CheckDecoyTimer = INVALID_HANDLE;
Action Chaos_DecoyDodgeball(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		if(g_bDecoyDodgeball && EndChaos){
			for(int i = 0; i <= MaxClients; i++){
				if(ValidAndAlive(i)){
					StripPlayer(i, true, true, true); //strip grenades only
					SetEntityHealth(i, 100);
					ClientCommand(i, "slot2");
					ClientCommand(i, "slot1");
					// FakeClientCommand(i, "use weapon_knife");
				}
			}
		}
		g_bDecoyDodgeball = false;
		StopTimer(g_DecoyDodgeball_Timer);
		delete g_DecoyDodgeball_CheckDecoyTimer;

	}
	if(DecidingChaos("Chaos_DecoyDodgeball")) return;
	if(CurrentlyActive(g_DecoyDodgeball_Timer)) return;
	
	Log("[Chaos] Running: Chaos_DecoyDodgeball");

	g_bDecoyDodgeball = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			StripPlayer(i, true, true, true); //strip grenades only
			GivePlayerItem(i, "weapon_decoy");
			FakeClientCommand(i, "use weapon_decoy");
			SetEntityHealth(i, 1);
		}
	}
	
	float duration = GetChaosTime("Chaos_DecoyDodgeball", 20.0);
	if(duration > 0) g_DecoyDodgeball_Timer = CreateTimer(duration, Chaos_DecoyDodgeball, true);
	
	g_DecoyDodgeball_CheckDecoyTimer = CreateTimer(5.0, Timer_CheckDecoys, _, TIMER_REPEAT);

	AnnounceChaos("Decoy Dodgeball", duration);
}
Action Timer_CheckDecoys(Handle timer){
	if(g_bDecoyDodgeball){
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
}

Handle g_bHeadshotOnly_Timer = INVALID_HANDLE;
Action Chaos_HeadshotOnly(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_bHeadshotOnly_Timer);
		cvar("mp_damage_headshot_only", "0");
	}
	if(DecidingChaos("Chaos_HeadshotOnly")) return;
	if(CurrentlyActive(g_bHeadshotOnly_Timer)) return;

	Log("[Chaos] Running: Chaos_HeadshotOnly");
	cvar("mp_damage_headshot_only", "1");
	
	float duration = GetChaosTime("Chaos_HeadshotOnly", 20.0);
	if(duration > 0) g_bHeadshotOnly_Timer = CreateTimer(duration, Chaos_HeadshotOnly, true);
	
	AnnounceChaos("Headshots Only", duration);
}

Handle g_ohko_Timer = INVALID_HANDLE;
Action Chaos_OHKO(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; //TODO return this info in another function
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 100);
			AnnounceChaos("1 HP", -1.0, true);
		}
		StopTimer(g_ohko_Timer);
	}
	if(DecidingChaos("Chaos_OHKO")) return;
	if(CurrentlyActive(g_ohko_Timer)) return;

	Log("[Chaos] Running: Chaos_OHKO");
	
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 1);
	
	float duration = GetChaosTime("Chaos_OHKO", 15.0);
	if(duration > 0) g_ohko_Timer = CreateTimer(duration, Chaos_OHKO, true);
	
	AnnounceChaos("1 HP", duration);
}

Handle g_InsaneGravityTimer = INVALID_HANDLE;
Action Chaos_InsaneGravity(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){	
		StopTimer(g_InsaneGravityTimer);
		cvar("sv_gravity", "800");
		ServerCommand("sv_falldamage_scale 1");
		if(EndChaos) AnnounceChaos("Insane Gravity", -1.0, true);
	}
	if(DecidingChaos("Chaos_InsaneGravity")) return;
	if(CurrentlyActive(g_InsaneGravityTimer)) return;
	
	Log("[Chaos] Running: Chaos_InsaneGravity");

	cvar("sv_gravity", "3000");
	ServerCommand("sv_falldamage_scale 0");
	
	float duration = GetChaosTime("Chaos_InsaneGravity", 20.0);
	if(duration > 0) g_InsaneGravityTimer = CreateTimer(duration, Chaos_InsaneGravity, true);
	
	AnnounceChaos("Insane Gravity", duration);
}

void Chaos_Nothing(){
	if(CountingCheckDecideChaos()) return;
	if(DecidingChaos("Chaos_Nothing")) return;
	Log("[Chaos] Running: Chaos_Nothing");
	AnnounceChaos("Nothing", -1.0);
}

Handle g_IceySurface_Timer = INVALID_HANDLE;
Action Chaos_IceySurface(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_IceySurface_Timer);
		cvar("sv_friction", "5.2");
		if(EndChaos) AnnounceChaos("Icey Ground", -1.0, true);
	}
	if(DecidingChaos("Chaos_IceySurface")) return;
	if(CurrentlyActive(g_IceySurface_Timer)) return;

	Log("[Chaos] Running: Chaos_IceySurface");
	cvar("sv_friction", "0");
	
	float duration = GetChaosTime("Chaos_IceySurface", 20.0);
	if(duration > 0) g_IceySurface_Timer = CreateTimer(duration, Chaos_IceySurface, true);
	
	AnnounceChaos("Icey Ground", duration);
}

Handle Chaos_RandomSlap_Timer = INVALID_HANDLE;
float g_Chaos_RandomSlap_Interval = 7.0;
Handle g_RandomSlapDuration_Timer = INVALID_HANDLE;
Action Chaos_RandomSlap(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(Chaos_RandomSlap_Timer);
		StopTimer(g_RandomSlapDuration_Timer);
		cvar("sv_falldamage_scale", "1");
		if(EndChaos) AnnounceChaos("Ghost Slaps", -1.0, true);
	}
	if(DecidingChaos("Chaos_RandomSlap")) return;
	if(CurrentlyActive(g_RandomSlapDuration_Timer)) return;

	Log("[Chaos] Running: Chaos_RandomSlap");
	cvar("sv_falldamage_scale", "0");
	Chaos_RandomSlap_Timer = CreateTimer(g_Chaos_RandomSlap_Interval, Timer_RandomSlap, _,TIMER_REPEAT);
	
	float duration = GetChaosTime("Chaos_RandomSlap", 30.0);
	if(duration > 0) g_RandomSlapDuration_Timer = CreateTimer(duration, Chaos_RandomSlap, true);
	
	AnnounceChaos("Ghost Slaps", duration);
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
		if(ValidAndAlive(client)){
			float vec[3];
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", vec);
			float x = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(-100.0, -1.0);
			float y = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(0.0, 50.0);
			float z = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(20.0, 50.0);
			vec[0] = vec[0]+x;
			vec[1] = vec[1]+y;
			vec[2] = vec[2]+z;
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec); 
			CPrintToChat(client, "What was that?");
		}
	}
}

Handle g_TaserParty_Timer = INVALID_HANDLE;
Action Chaos_TaserParty(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("mp_taser_recharge_time", "-1");
		cvar("sv_party_mode", "0");
		g_bTaserRound = false;
		StopTimer(g_TaserParty_Timer);
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) ClientCommand(i, "slot2;slot1");
			AnnounceChaos("Taser Party", -1.0, true);
		}
	}
	if(DecidingChaos("Chaos_TaserParty")) return;
	if(CurrentlyActive(g_TaserParty_Timer)) return;

	Log("[Chaos] Running: Chaos_TaserParty");

	g_bTaserRound = true;
	cvar("mp_taser_recharge_time", ".5");
	cvar("sv_party_mode", "1");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GivePlayerItem(i, "weapon_taser");
			FakeClientCommand(i, "use weapon_taser");
		}
	}

	float duration = GetChaosTime("Chaos_TaserParty", 10.0);
	if(duration > 0) g_TaserParty_Timer = CreateTimer(duration, Chaos_TaserParty, true);
	
	AnnounceChaos("Taser Party!", duration);
}

bool g_bKnifeFight = false;
Handle g_KnifeFight_Timer = INVALID_HANDLE;
Action Chaos_KnifeFight(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_KnifeFight_Timer);
		g_bKnifeFight = false;
		
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) ClientCommand(i, "slot1");
			AnnounceChaos("Knife Fight", -1.0, true);
		}
	}
	if(DecidingChaos("Chaos_KnifeFight")) return;
	if(CurrentlyActive(g_KnifeFight_Timer)) return;

	Log("[Chaos] Running: Chaos_KnifeFight");
	g_bKnifeFight = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			FakeClientCommand(i, "use weapon_knife");
		}
	}
	
	float duration = GetChaosTime("Chaos_KnifeFight", 15.0);
	if(duration > 0) g_KnifeFight_Timer = CreateTimer(duration, Chaos_KnifeFight, true);
	
	AnnounceChaos("Knife Fight!", duration);
}

Handle g_Funky_Timer = INVALID_HANDLE;
Action Chaos_Funky(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_enablebunnyhopping", "0");
		cvar("sv_autobunnyhopping", "0");
		cvar("sv_airaccelerate", "12");
		StopTimer(g_Funky_Timer);
		if(EndChaos) AnnounceChaos("No more {orchid}funky{default}?", -1.0, true);
	}
	if(DecidingChaos("Chaos_Funky.autobhop.bhop")) return;
	if(CurrentlyActive(g_Funky_Timer)) return;

	Log("[Chaos] Running: Chaos_Funky");
	
	cvar("sv_airaccelerate", "2000");
	cvar("sv_enablebunnyhopping", "1");
	cvar("sv_autobunnyhopping", "1");

	float duration = GetChaosTime("Chaos_Funky", 30.0);
	if(duration > 0) g_Funky_Timer = CreateTimer(duration, Chaos_Funky, true);
	
	AnnounceChaos("Are you feeling {orchid}funky{default}?", duration);
}

// bool g_bRandomWeaponRound = false;
Handle g_RandWep_Timer = INVALID_HANDLE;
float g_fRandomWeapons_Interval = 5.0; //5+ recommended for bomb plants
Action Chaos_RandomWeapons(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bPlayersCanDropWeapon = true;
		StopTimer(g_RandomWeapons_Timer_Repeat);
		StopTimer(g_RandWep_Timer);
	}
	if(DecidingChaos("Chaos_RandomWeapons")) return;
	if(CurrentlyActive(g_RandWep_Timer)) return;

	Log("[Chaos] Running: Chaos_RandomWeapons");


	StopTimer(g_RandomWeapons_Timer_Repeat);
	g_bPlayersCanDropWeapon = false;
	Timer_GiveRandomWeapon();
	g_RandomWeapons_Timer_Repeat = CreateTimer(g_fRandomWeapons_Interval, Timer_GiveRandomWeapon, _, TIMER_REPEAT);

	float duration = GetChaosTime("Chaos_RandomWeapons", 30.0);
	if(duration > 0) g_RandWep_Timer = CreateTimer(duration, Chaos_RandomWeapons, true);
	
	AnnounceChaos("Random Weapons!", duration);
}
Action Timer_GiveRandomWeapon(Handle timer = null){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			int randomWeaponIndex = GetRandomInt(0,sizeof(g_sWeapons)-1);	
			GiveAndSwitchWeapon(i, g_sWeapons[randomWeaponIndex]);
		}
	}
}

Handle g_MoonGravity_Timer = INVALID_HANDLE;
Action Chaos_MoonGravity(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_MoonGravity_Timer);
		cvar("sv_gravity", "800");
		if(EndChaos) AnnounceChaos("Moon Gravity", -1.0, true);
	}
	if(DecidingChaos("Chaos_MoonGravity")) return;
	if(CurrentlyActive(g_MoonGravity_Timer)) return;

	Log("[Chaos] Running: Chaos_MoonGravity");
	cvar("sv_gravity", "300");
	//TODO fluctuating gravity thoughout the round?

	float duration = GetChaosTime("Chaos_MoonGravity", 30.0);
	if(duration > 0) g_MoonGravity_Timer = CreateTimer(duration, Chaos_MoonGravity, true);
	
	AnnounceChaos("Moon Gravity", duration);
}


//TODO use the map coordinates to make it look like cool raining in another effect
Handle Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
float g_RandomMolotovSpawn_Interval = 5.0; //5+ recommended for bomb plants
int g_MolotovSpawn_Count = 0;
public void Chaos_RandomMolotovSpawn(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){
		cvar("inferno_flame_lifetime", "7");
		StopTimer(Chaos_MolotovSpawn_Timer);
	}		
	if(DecidingChaos("Chaos_RandomMolotovSpawn")) return;
	if(CurrentlyActive(Chaos_MolotovSpawn_Timer)) return;

	Log("[Chaos] Running: Chaos_RandomMolotovSpawn");

	g_MolotovSpawn_Count = 0;
	cvar("inferno_flame_lifetime", "4");
	
	Chaos_MolotovSpawn_Timer = CreateTimer(g_RandomMolotovSpawn_Interval, Timer_SpawnMolotov, _, TIMER_REPEAT);

	AnnounceChaos("Raining Fire!", 25.0);
}

public Action Timer_SpawnMolotov(Handle timer){
	if(g_MolotovSpawn_Count > 5){
		g_MolotovSpawn_Count = 0;
		StopTimer(Chaos_MolotovSpawn_Timer);
		Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
		AnnounceChaos("Raining Fire Ended", -1.0, true);
		return;
	}
	g_MolotovSpawn_Count++;
	for(int client = 0; client <= MaxClients; client++){
		if(ValidAndAlive(client)){
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


Handle g_ESP_Timer = INVALID_HANDLE;
Action Chaos_ESP(Handle timer = null, bool EndChaos = false ){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_ESP_Timer);
		cvar("sv_force_transmit_players", "0");
		destroyGlows();
		if(EndChaos) AnnounceChaos("Wall Hacks", -1.0, true);
	}
	if(DecidingChaos("Chaos_ESP.WallHacks")) return; //todo test if works
	if(CurrentlyActive(g_ESP_Timer)) return;
	
	Log("[Chaos] Running: Chaos_ESP");

	cvar("sv_force_transmit_players", "1");
	createGlows();
	
	float duration = GetChaosTime("Chaos_ESP", 30.0);
	if(duration > 0) g_ESP_Timer = CreateTimer(duration, Chaos_ESP, true);
	
	AnnounceChaos("Wall Hacks", duration);
}

Handle g_ReversedMovementTimer = INVALID_HANDLE;
Action Chaos_ReversedMovement(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		cvar("sv_accelerate", "5.5");
		StopTimer(g_ReversedMovementTimer);
		if(EndChaos) AnnounceChaos("Reversed Movement", -1.0, true);
	}
	if(DecidingChaos("Chaos_ReversedMovement")) return;
	if(CurrentlyActive(g_ReversedMovementTimer)) return;
	
	Log("[Chaos] Running: Chaos_ReversedMovement");

	cvar("sv_accelerate", "-5.5");
	
	float duration = GetChaosTime("Chaos_ReversedMovement", 20.0);
	if(duration > 0) g_ReversedMovementTimer = CreateTimer(duration, Chaos_ReversedMovement, true);
	
	AnnounceChaos("Reversed Movement", duration);
}

Handle TPos = INVALID_HANDLE;
Handle CTPos = INVALID_HANDLE;
Handle tIndex = INVALID_HANDLE;
Handle ctIndex = INVALID_HANDLE;
public void TEAMMATESWAP_INIT(){
	TPos = CreateArray(3);
	CTPos = CreateArray(3);
	tIndex = CreateArray(1);
	ctIndex = CreateArray(1);
}

void Chaos_TeammateSwap(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){		}
	if(DecidingChaos("Chaos_TeammateSwap")) return;
	Log("[Chaos] Running: Chaos_TeammateSwap");

	ClearArray(TPos);
	ClearArray(CTPos);
	ClearArray(tIndex);
	ClearArray(ctIndex);

	float vec[3];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, vec);
			if(GetClientTeam(i) == CS_TEAM_T) 	PushArrayArray(TPos, vec);
			if(GetClientTeam(i) == CS_TEAM_CT) 	PushArrayArray(CTPos, vec);
		}
	}

	for(int i = MaxClients; i >= 0; i--){
		if(ValidAndAlive(i)){
			if(GetClientTeam(i) == CS_TEAM_T) 	PushArrayCell(tIndex, i);
			if(GetClientTeam(i) == CS_TEAM_CT) 	PushArrayCell(ctIndex, i);
		}
	}

	for(int i = 0; i < GetArraySize(ctIndex); i++){
		GetArrayArray(CTPos, i, vec);
		TeleportEntity(GetArrayCell(ctIndex, i), vec, NULL_VECTOR, NULL_VECTOR);
	}

	for(int i = 0; i < GetArraySize(tIndex); i++){
		GetArrayArray(TPos, i, vec);
		TeleportEntity(GetArrayCell(tIndex, i), vec, NULL_VECTOR, NULL_VECTOR);
	}

	AnnounceChaos("Teammate Swap!", -1.0);
}

//Allows nowclippers to take damage
bool g_bActiveNoclip = false;
Handle g_ResetNoclipTimer = INVALID_HANDLE;

Action Chaos_Flying(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityMoveType(i, MOVETYPE_WALK);
			TeleportPlayersToClosestLocation();
			AnnounceChaos("Flying", -1.0, true);
		}
		cvar("sv_noclipspeed", "5");
		g_bActiveNoclip = false;	
		StopTimer(g_ResetNoclipTimer);
	}
	if(DecidingChaos("Chaos_Flying")) return;
	if(CurrentlyActive(g_ResetNoclipTimer)) return;

	Log("[Chaos] Running: Chaos_Flying");

	g_bActiveNoclip = true;	
	SavePlayersLocations();
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityMoveType(i, MOVETYPE_NOCLIP);
	cvar("sv_noclipspeed", "2");

	float duration = GetChaosTime("Chaos_Flying", 10.0);
	if(duration > 0) g_ResetNoclipTimer = CreateTimer(duration, Chaos_Flying, true);
	
	AnnounceChaos("Flying", duration);
}

void Chaos_RandomTeleport(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){		}
	if(DecidingChaos("Chaos_RandomTeleport")) return;
	Log("[Chaos] Running: Chaos_RandomTeleport");
	DoRandomTeleport();
	AnnounceChaos("Random Teleport", -1.0);
}

void Chaos_LavaFloor(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){		}
	if(DecidingChaos("Chaos_LavaFloor")) return;
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
	
	AnnounceChaos("The Floor Is Lava", -1.0);
}

Handle g_Quake_Timer = INVALID_HANDLE;
Action Chaos_QuakeFOV(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_Quake_Timer);
		ResetPlayersFOV();
	}
	if(DecidingChaos("Chaos_QuakeFOV")) return;
	if(CurrentlyActive(g_Quake_Timer)) return;
	
	Log("[Chaos] Running: Chaos_QuakeFOV");

	int RandomFOV = GetRandomInt(110,160);
	SetPlayersFOV(RandomFOV);

	float duration = GetChaosTime("Chaos_QuakeFOV", 25.0);
	if(duration > 0) g_Quake_Timer = CreateTimer(duration, Chaos_QuakeFOV, true);
	
	AnnounceChaos("Quake FOV", duration);
}

Handle g_Binoculars_Timer = INVALID_HANDLE;
Action Chaos_Binoculars(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_Binoculars_Timer);
		ResetPlayersFOV();
	}
	if(DecidingChaos("Chaos_Binoculars")) return;
	if(CurrentlyActive(g_Binoculars_Timer)) return;

	Log("[Chaos] Running: Chaos_Binoculars");

	int RandomFOV = GetRandomInt(20,50);
	SetPlayersFOV(RandomFOV);
	
	float duration = GetChaosTime("Chaos_Binoculars", 25.0);
	if(duration > 0) g_Binoculars_Timer = CreateTimer(duration, Chaos_Binoculars, true);
	
	AnnounceChaos("Binoculars", duration);
}

void SetPlayersFOV(int fov){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
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
Action Chaos_BlindPlayers(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				PerformBlind(i, 0);
			}
		}
		StopTimer(g_BlindPlayers_Timer);
	}
	if(DecidingChaos("Chaos_BlindPlayers")) return;
	if(CurrentlyActive(g_BlindPlayers_Timer)) return;

	Log("[Chaos] Running: Chaos_BlindPlayers");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)) PerformBlind(i, 255);
	}

	float duration = GetChaosTime("Chaos_BlindPlayers", 7.0);
	g_BlindPlayers_Timer = CreateTimer(duration, Chaos_BlindPlayers, true);
	
	AnnounceChaos("Blind", duration);
}

Handle g_Aimbot_Timer = INVALID_HANDLE;
Action Chaos_Aimbot(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_Aimbot_Timer);
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				Aimbot_REMOVE_SDKHOOKS(i);
				ToggleAim(i, false);
			}
		}
		if(EndChaos) AnnounceChaos("Aimbot", -1.0, true);
	}
	if(DecidingChaos("Chaos_Aimbot")) return;
	if(CurrentlyActive(g_Aimbot_Timer)) return;

	Log("[Chaos] Running: Chaos_Aimbot");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			Aimbot_SDKHOOKS(i);
			ToggleAim(i, true);
		}
	}

	float duration = GetChaosTime("Chaos_Aimbot", 30.0);
	if(duration > 0) g_Aimbot_Timer = CreateTimer(duration, Chaos_Aimbot, true);
	
	AnnounceChaos("Aimbot", duration);
}

Handle g_NoSpread_Timer = INVALID_HANDLE;
Action Chaos_NoSpread(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	

		StopTimer(g_NoSpread_Timer);
		cvar("weapon_accuracy_nospread", "0");
		cvar("weapon_recoil_scale", "2");
		if(EndChaos) AnnounceChaos("100\% Weapon Accuracy", -1.0, true);
	}
	if(DecidingChaos("Chaos_NoSpread")) return;
	if(CurrentlyActive(g_NoSpread_Timer)) return;

	Log("[Chaos] Running: Chaos_NoSpread");
	
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");

	float duration = GetChaosTime("Chaos_NoSpread", 25.0);
	if(duration > 0) g_NoSpread_Timer = CreateTimer(duration, Chaos_NoSpread, true);
	
	AnnounceChaos("100\% Weapon Accuracy", duration);
}
// weapon_accuracy_nospread "1";
// weapon_debug_spread_gap "1";
// weapon_recoil_cooldown "0";
// weapon_recoil_decay1_exp "99999";
// weapon_recoil_decay2_exp "99999";
// weapon_recoil_decay2_lin "99999";
// weapon_recoil_scale "0";
// weapon_recoil_suppression_shots "500";

Handle g_IncRecoil_Timer = INVALID_HANDLE;
Action Chaos_IncreasedRecoil(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_IncRecoil_Timer);
		cvar("weapon_recoil_scale", "2");
		if(EndChaos) AnnounceChaos("Increased Recoil", -1.0, true);
	}
	if(DecidingChaos("Chaos_IncreasedRecoil")) return;
	if(CurrentlyActive(g_IncRecoil_Timer)) return;

	Log("[Chaos] Running: Chaos_IncreasedRecoil");

	cvar("weapon_recoil_scale", "10");

	float duration = GetChaosTime("Chaos_IncreasedRecoil", 25.0);
	if(duration > 0) g_IncRecoil_Timer = CreateTimer(duration, Chaos_IncreasedRecoil, true);

	AnnounceChaos("Increased Recoil", duration);
}

Handle g_ReverseRecoil_Timer = INVALID_HANDLE;
Action Chaos_ReversedRecoil(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_ReverseRecoil_Timer);
		cvar("weapon_recoil_scale", "2");
		if(EndChaos) AnnounceChaos("Reversed Recoil", -1.0, true);
	}
	if(DecidingChaos("Chaos_ReversedRecoil")) return;
	if(CurrentlyActive(g_ReverseRecoil_Timer)) return;

	Log("[Chaos] Running: Chaos_ReversedRecoil");

	cvar("weapon_recoil_scale", "-5");

	float duration = GetChaosTime("Chaos_ReversedRecoil", 25.0);
	if(duration > 0) g_ReverseRecoil_Timer = CreateTimer(duration, Chaos_ReversedRecoil, true);
	
	AnnounceChaos("Reversed Recoil", duration);
}

void Chaos_Jackpot(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_Jackpot")) return;
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetClientMoney(i, 16000);
	Log("[Chaos] Running: Chaos_Jackpot");
	AnnounceChaos("Jackpot", -1.0);
}

void Chaos_Bankrupt(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){}
	if(DecidingChaos("Chaos_Bankrupt")) return;
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetClientMoney(i, 0, true);
	Log("[Chaos] Running: Chaos_Bankrupt");
	AnnounceChaos("Bankrupt", -1.0);
}

//TODO: chnage to a giverandomplayer function so i can ignite random player or something
void Chaos_SlayRandomPlayer(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){}
	if(DecidingChaos("Chaos_SlayRandomPlayer")) return;

	Log("[Chaos] Running: Chaos_SlayRandomPlayer");


	int aliveCT = GetAliveCTCount();
	int aliveT = GetAliveTCount();
	int RandomTSlay = GetRandomInt(1, aliveT);
	int RandomCTSlay = GetRandomInt(1, aliveCT);

	if(aliveT > 1){
		aliveT = 0;
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
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
			if(ValidAndAlive(i)){
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

	AnnounceChaos("Slay Random Player On Each Team", -1.0);
}


void Chaos_Healthshot(){
	if(CountingCheckDecideChaos()) return;
	if(DecidingChaos("Chaos_Healthshot")) return;
	Log("[Chaos] Running: Chaos_Healthshot");
	int amount = GetRandomInt(1,3);
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			for(int j = 1; j <= amount; j++){
				GivePlayerItem(i, "weapon_healthshot");
			}
		}
	}
	AnnounceChaos("Healthshots", -1.0);
}

Handle g_AlienKnifeFightTimer = INVALID_HANDLE;
Action Chaos_AlienModelKnife(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_AlienKnifeFightTimer);
		g_bKnifeFight = false;
		// if(EndChaos){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				ClientCommand(i, "slot1");
				SetEntPropFloat(i, Prop_Send, "m_flModelScale", 1.0);
				SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0);
				SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			}
		}	
		// }
		if(EndChaos) AnnounceChaos("Alien Knife Fight", -1.0, true);
	}
	if(DecidingChaos("Chaos_AlienModelKnife")) return;
	if(CurrentlyActive(g_AlienKnifeFightTimer)) return;

	Log("[Chaos] Running: Chaos_AlienModelKnife");

	//hitboxes are tiny, but knives work fine
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntPropFloat(i, Prop_Send, "m_flModelScale", 0.5);
			// SetEntProp(i, Prop_Send, "m_ScaleType", 5); //TODO EXPERIEMNT WITH
			SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0*0.55);
		}
	}

	g_bKnifeFight = true;
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 2.0);
			FakeClientCommand(i, "use weapon_knife");
		}
	}

	float duration = GetChaosTime("Chaos_AlienModelKnife", 15.0);
	if(duration > 0) g_AlienKnifeFightTimer = CreateTimer(duration, Chaos_AlienModelKnife, true);

	AnnounceChaos("Alien Knife Fight", duration);
}

Handle g_LightsOff_Timer = INVALID_HANDLE;
Action Chaos_LightsOff(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_LightsOff_Timer);
		Fog_OFF();
	}
	if(DecidingChaos("Chaos_LightsOff")) return;
	if(CurrentlyActive(g_LightsOff_Timer)) return;

	Log("[Chaos] Running: Chaos_LightsOff");
	
	LightsOff();
	
	float duration = GetChaosTime("Chaos_LightsOff", 30.0);
	if(duration  > 0) g_LightsOff_Timer = CreateTimer(duration, Chaos_LightsOff, true);
	//Random chance for night vision? or separate chaos

	AnnounceChaos("Who turned the lights off?", duration);
}

void Chaos_NightVision(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
			}
		}
	}
	if(DecidingChaos("Chaos_NightVision")) return;
	
	Log("[Chaos] Running: Chaos_NightVision");
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GivePlayerItem(i, "item_nvgs");
			FakeClientCommand(i, "nightvision");
		}
	}

	AnnounceChaos("Night Vision", -1.0);
}


Handle g_NormalWhiteFog_Timer = INVALID_HANDLE;
Action Chaos_NormalWhiteFog(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_NormalWhiteFog_Timer);
		AcceptEntityInput(g_iFog, "TurnOff");
	}
	if(DecidingChaos("Chaos_NormalWhiteFog")) return;
	if(CurrentlyActive(g_NormalWhiteFog_Timer)) return;

	Log("[Chaos] Running: Chaos_NormalWhiteFog");

	NormalWhiteFog();

	float duration = GetChaosTime("Chaos_NormalWhiteFog", 45.0);
	if(duration > 0) g_NormalWhiteFog_Timer = CreateTimer(duration, Chaos_NormalWhiteFog, true);
	
	AnnounceChaos("Fog", duration);

}

Handle g_ExtremeWhiteFog_Timer = INVALID_HANDLE;
Action Chaos_ExtremeWhiteFog(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		Fog_OFF();
		StopTimer(g_ExtremeWhiteFog_Timer);
	}
	if(DecidingChaos("Chaos_ExtremeWhiteFog")) return;
	if(CurrentlyActive(g_ExtremeWhiteFog_Timer)) return;

	Log("[Chaos] Running: Chaos_NormalWhiteFog");

	ExtremeWhiteFog();
	float duration = GetChaosTime("Chaos_NormalWhiteFog", 45.0);
	if(duration > 0) g_ExtremeWhiteFog_Timer = CreateTimer(duration, Chaos_ExtremeWhiteFog, true);

	AnnounceChaos("Extreme Fog", duration);
}


void Chaos_RandomSkybox(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_RandomSkybox")) return;
	
	Log("[Chaos] Running: Chaos_RandomSkybox");

	int randomSkyboxIndex = GetRandomInt(0, sizeof(g_sSkyboxes)-1);
	DispatchKeyValue(0, "skyname", g_sSkyboxes[randomSkyboxIndex]);
	
	AnnounceChaos("Random Skybox", -1.0);
}

Handle g_LowRender_Timer = INVALID_HANDLE;
Action Chaos_LowRenderDistance(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_LowRender_Timer);
		ResetRenderDistance();
	}
	if(DecidingChaos("Chaos_LowRenderDistance")) return;
	if(CurrentlyActive(g_LowRender_Timer)) return;

	Log("[Chaos] Running: Chaos_LowRenderDistance");

	LowRenderDistance();
	
	float duration = GetChaosTime("Chaos_LowRenderDistance", 30.0);
	if(duration > 0 ) g_LowRender_Timer = CreateTimer(duration, Chaos_LowRenderDistance, true);
	
	AnnounceChaos("Low Render Distance", duration);
}


Handle g_Thirdperson_Timer = INVALID_HANDLE;
Action Chaos_Thirdperson(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) ClientCommand(i, "firstperson");
		cvar("sv_allow_thirdperson", "0");
		StopTimer(g_Thirdperson_Timer);
		if(EndChaos) AnnounceChaos("Firstperson", -1.0);
	}
	if(DecidingChaos("Chaos_Thirdperson")) return;
	if(CurrentlyActive(g_Thirdperson_Timer)) return;

	Log("[Chaos] Running: Chaos_Thirdperson");

	cvar("sv_allow_thirdperson", "1");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)) ClientCommand(i, "thirdperson");
	}
	
	float duration = GetChaosTime("Chaos_Thirdperson", 15.0);
	if(duration > 0) g_Thirdperson_Timer = CreateTimer(duration, Chaos_Thirdperson, true);

	AnnounceChaos("Thirdperson", duration);
}

void Chaos_SmokeMap(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_SmokeMap")) return;
	Log("[Chaos] Running: Chaos_SmokeMap");

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			CreateParticle("explosion_smokegrenade_fallback", vec);
		}
	}
	AnnounceChaos("Smoke Strat", -1.0);
}

Handle g_InfiniteAmmo_Timer = INVALID_HANDLE;
Action Chaos_InfiniteAmmo(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_infinite_ammo", "0");
		StopTimer(g_InfiniteAmmo_Timer);
		if(EndChaos) AnnounceChaos("Limited Ammo", -1.0, true);
	}
	if(DecidingChaos("Chaos_InfiniteAmmo")) return;
	if(CurrentlyActive(g_InfiniteAmmo_Timer)) return;

	Log("[Chaos] Running: Chaos_InfiniteAmmo");

	cvar("sv_infinite_ammo", "1");
	
	float duration = GetChaosTime("Chaos_InfiniteAmmo", 20.0);
	if(duration > 0) g_InfiniteAmmo_Timer = CreateTimer(duration, Chaos_InfiniteAmmo, true);
	
	AnnounceChaos("Infinite Ammo", duration);
}


void Chaos_DropCurrentWeapon(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_DropCurrentWeapon")) return;

	Log("[Chaos] Running: Chaos_DropCurrentWeapon");
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "drop");
		}
	}
	AnnounceChaos("Drop Current Weapon", -1.0);
}

void Chaos_DropPrimaryWeapon(){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos()){	}
	if(DecidingChaos("Chaos_DropPrimaryWeapon")) return;
	
	Log("[Chaos] Running: Chaos_DropPrimaryWeapon");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "slot2;slot1; drop"); //todo drop their pisol if no primary available
		}
	}
	AnnounceChaos("Drop Primary Weapon", -1.0);
}


Handle g_Invis_Timer = INVALID_HANDLE;

Action Chaos_Invis(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		for(int  client = 0;  client <= MaxClients;  client++){
			if(IsValidClient(client)){
				SetEntityRenderMode(client , RENDER_NORMAL);
				SetEntityRenderColor(client, 255, 255, 255, 255);
			}
		}
		StopTimer(g_Invis_Timer);
		if(EndChaos) AnnounceChaos("Where did everyone go?", -1.0, true);
	}
	if(DecidingChaos("Chaos_Invis")) return;
	if(CurrentlyActive(g_Invis_Timer)) return;

	Log("[Chaos] Running: Chaos_Invis");

	float duration = GetChaosTime("Chaos_Invis", 15.0);

	int alpha = 50;
	if(duration > 0) alpha = 0;

	cvar("sv_disable_immunity_alpha", "1");
	for(int  client = 0;  client <= MaxClients;  client++){
		if(IsValidClient(client)){
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 255, 255, alpha);
		}
	}
	
	//Perhaps it can fade in and out, full invis for 5 seconds, then transition to visible for 10 seconds, back to invis, etc.
	//Various timers that slowly increase or giveaway positions.
	if(duration > 0) g_Invis_Timer = CreateTimer(duration, Chaos_Invis, true);
	
	AnnounceChaos("Where did everyone go?", duration);
}


Handle DiscoPlayers_Timer = INVALID_HANDLE;
Handle DiscoPlayers_TimerRepeat = INVALID_HANDLE;
bool g_bDiscoPlayers = false;
Action Chaos_DiscoPlayers(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bDiscoPlayers = true;
		StopTimer(DiscoPlayers_Timer);
		delete DiscoPlayers_TimerRepeat; //todo? wtf stray delete
		if(EndChaos) AnnounceChaos("Disco Players", -1.0, true);
	}
	if(DecidingChaos("Chaos_DiscoPlayers")) return;
	if(CurrentlyActive(DiscoPlayers_Timer)) return;

	Log("[Chaos] Running: Chaos_DiscoPlayers");

	delete DiscoPlayers_TimerRepeat;
	g_bDiscoPlayers = true;
	Timer_DiscoPlayers();

	float duration = GetChaosTime("Chaos_DiscoPlayers", 30.0);
	if(duration > 0) DiscoPlayers_Timer = CreateTimer(duration, Chaos_DiscoPlayers, true);
	DiscoPlayers_TimerRepeat = CreateTimer(1.0, Timer_DiscoPlayers, _, TIMER_REPEAT);

	AnnounceChaos("Disco Players", duration);
}

Action Timer_DiscoPlayers(Handle timer = null){
	if(g_bDiscoPlayers){
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
	}else{
		StopTimer(DiscoPlayers_TimerRepeat);
	}
}


//todo, doesnt always work?
public void Chaos_RandomInvisiblePlayer(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){

	}
	if(DecidingChaos("Chaos_RandomInvisiblePlayer")) return;
	Log("[Chaos] Running: Chaos_RandomInvisiblePlayer");
	int alivePlayers = GetAliveCTCount() + GetAliveTCount();
	int target = GetRandomInt(0, alivePlayers - 1);
	int count = -1;
	bool setPlayer = false;
	if(alivePlayers > 1){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i) && !setPlayer){
				count++;
				if(count == target){
					setPlayer = true;
					target = i;
					SetEntityRenderMode(target, RENDER_TRANSCOLOR);
					SetEntityRenderColor(target, 255, 255, 255, 0);
					//todo: shorten player names if its too high
					char chaosMsg[256];
					FormatEx(chaosMsg, sizeof(chaosMsg), "{orange}%N {default}has been made invisible!", target);
					AnnounceChaos(chaosMsg, -1.0);
				}
			}
		}
	}else{
		RetryEvent();
	}
}



//todo, delay each mega effect by half a second rather than blindly spawn it in 5 at a time
public void Chaos_MEGACHAOS(){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos()){

	}
	if(DecidingChaos("Chaos_MEGACHAOS")) return;
	Log("[Chaos] Running: Chaos_MEGACHAOS");
	
	g_bMegaChaos = true; 
	AnnounceChaos("MEGA CHAOS", -1.0, true, true);
	g_bDisableRetryEvent = false;
	CreateTimer(0.0, DecideEvent, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.5, DecideEvent, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.0, DecideEvent, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.5, DecideEvent, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.0, DecideEvent, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.5, Timer_CompleteMegaChaos);

}
public Action Timer_CompleteMegaChaos(Handle timer){
	AnnounceChaos("MEGA CHAOS", -1.0, true, true);
	g_bMegaChaos = false; 
}