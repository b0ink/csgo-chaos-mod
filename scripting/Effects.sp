float g_RapidFire_Expire = 25.0;
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
	
	g_RapidFire_Expire = GetChaosTime("Chaos_RapidFire", 25.0);
	Log("[Chaos] Running: Rapid Fire");

	if(g_RapidFire_Expire > 0.0) g_RapidFire_Timer = CreateTimer(g_RapidFire_Expire, Chaos_RapidFire, true);
	g_bRapidFire = true;
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");
	AnnounceChaos("Rapid Fire", g_RapidFire_Expire);
}

float g_BreakTime_Expire = 10.0;
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

	g_BreakTime_Expire = GetChaosTime("Chaos_BreakTime", 10.0);
	Log("[Chaos] Running: Chaos_BreakTime");

	if(g_BreakTime_Expire > 0.0) g_BreakTime_Timer = CreateTimer(g_BreakTime_Expire, Chaos_BreakTime, true);
	cvar("sv_accelerate", "0");
	cvar("sv_airaccelerate", "0");
	
	//todo set m_movement to 0 so no one can do anything, potentially stop shooting?
	AnnounceChaos("Break Time!", g_BreakTime_Expire);
}

float FakeTeleport_Expire = 3.0;
Handle FakeTeleport_Timer = INVALID_HANDLE;
float FakeTelport_loc[MAXPLAYERS+1][3];
void Chaos_FakeTeleport(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
		StopTimer(FakeTeleport_Timer);
	}
	if(DecidingChaos("Chaos_FakeTeleport")) return;
	Log("[Chaos] Running: Fake Teleport");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			FakeTelport_loc[i] = vec;
		}
	}
	DoRandomTeleport();
	FakeTeleport_Timer = CreateTimer(FakeTeleport_Expire, Timer_ResetFakeTeleport);
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
	if(g_bClearChaos){

	}
	if(DecidingChaos("Chaos_Soccerballs")) return;

	Log("[Chaos] Running: Chaos_Soccerballs");
	
	cvar("sv_turbophysics", "100");

	char MapName[128];
	GetCurrentMap(MapName, sizeof(MapName));
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			int ent = CreateEntityByName("prop_physics_multiplayer"); 
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
			SetEntityMoveType(ent, MOVETYPE_VPHYSICS);   
		}
	}
	AnnounceChaos("Soccer balls", -1.0);

}

float g_NoCrosshair_Expire = 25.0;
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

	g_NoCrosshair_Expire = GetChaosTime("Chaos_NoCrosshair", 25.0);
	Log("[Chaos] Running: Chaos_NoCrosshair");

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
		}
	}
	if(g_NoCrosshair_Expire > 0.0) g_NoCrossHair_Timer = CreateTimer(g_NoCrosshair_Expire, Chaos_NoCrosshair, true);
	AnnounceChaos("No Crosshair", g_NoCrosshair_Expire);
}

bool g_bLag = true;
void Chaos_FakeCrash(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){    }
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


float g_DisableRadar_Expire = 20.0;
Handle g_DisableRadar_Timer = INVALID_HANDLE;
Action Chaos_DisableRadar(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_disable_radar", "0");

		StopTimer(g_DisableRadar_Timer);
	}
	if(DecidingChaos("Chaos_DisableRadar")) return;

	g_DisableRadar_Expire = GetChaosTime("Chaos_DisableRadar", 20.0);
	Log("[Chaos] Running: Chaos_DisableRadar");

	cvar("sv_disable_radar", "1");
	if(g_DisableRadar_Expire > 0.0) g_DisableRadar_Timer = CreateTimer(g_DisableRadar_Expire, Chaos_DisableRadar, true);
	AnnounceChaos("No Radar", g_DisableRadar_Expire);
}

void Chaos_SpawnFlashbangs(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){    }
	if(DecidingChaos("Chaos_SpawnFlashbangs")) return;

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
	AnnounceChaos("Spawn Flashbangs", -1.0);
}

float g_SuperJump_Expire = 20.0;
Handle g_SuperJump_Timer = INVALID_HANDLE;
Action Chaos_SuperJump(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_jump_impulse", "301");

		StopTimer(g_SuperJump_Timer);
	}
	if(DecidingChaos("Chaos_SuperJump")) return;

	g_SuperJump_Expire = GetChaosTime("Chaos_SuperJump", 20.0);
	Log("[Chaos] Running: Chaos_SuperJump");
	
	cvar("sv_jump_impulse", "590");
	if(g_SuperJump_Expire > 0.0) g_SuperJump_Timer = CreateTimer(g_SuperJump_Expire, Chaos_SuperJump, true);
	AnnounceChaos("Super Jump", g_SuperJump_Expire);
}



float g_Juggernaut_Expire = 30.0;
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

	g_Juggernaut_Expire = GetChaosTime("Chaos_Juggernaut", 30.0);
	Log("[Chaos] Running: Chaos_Juggernaut");

	cvar("mp_weapons_allow_heavyassaultsuit", "1");
	g_bSetJuggernaut = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientModel(i, g_OriginalModels_Jugg[i], sizeof(g_OriginalModels_Jugg[]));
			GivePlayerItem(i, "item_heavyassaultsuit");
		}
	}
	if(g_Juggernaut_Expire > 0.0) g_Juggernaut_Timer = CreateTimer(g_Juggernaut_Expire, Chaos_Juggernaut, true);
	AnnounceChaos("Juggernauts", g_Juggernaut_Expire);
}


void Chaos_SpawnExplodingBarrels(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){

	}
	if(DecidingChaos("Chaos_SpawnExplodingBarrels")) return;
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
	AnnounceChaos("Exploding Barrels", -1.0);
}


float g_InsaneStrafe_Expire = 20.0;
Handle g_InsaneStrafe_Timer = INVALID_HANDLE;
Action Chaos_InsaneAirSpeed(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_air_max_wishspeed", "30");
		cvar("sv_airaccelerate", "12");

		StopTimer(g_InsaneStrafe_Timer);

	}
	if(DecidingChaos("Chaos_InsaneAirSpeed")) return;
	g_InsaneStrafe_Expire = GetChaosTime("Chaos_InsaneAirSpeed", 20.0);
	Log("[Chaos] Running: Chaos_InsaneAirSpeed");
	cvar("sv_air_max_wishspeed", "2000");
	cvar("sv_airaccelerate", "2000");
	if(g_InsaneStrafe_Expire > 0.0) g_InsaneStrafe_Timer = CreateTimer(g_InsaneStrafe_Expire, Chaos_InsaneAirSpeed, true);
	AnnounceChaos("Extreme Strafe Acceleration", g_InsaneStrafe_Expire);
}

void Chaos_RespawnDead_LastLocation(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){    }
	if(DecidingChaos("Chaos_RespawnDead_LastLocation")) return;
	Log("[Chaos] Running: Chaos_RespawnDead_LastLocation");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			TeleportEntity(i, g_PlayerDeathLocations[i], NULL_VECTOR, NULL_VECTOR);
		}
	}
	AnnounceChaos("Resurrect players where they died", -1.0);
}

float g_Drugs_Expire = 10.0;
Handle g_Drugs_Timer = INVALID_HANDLE;
Action Chaos_Drugs(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		KillAllDrugs();
		StopTimer(g_Drugs_Timer);
	}
	if(DecidingChaos("Chaos_Drugs")) return;

	g_Drugs_Expire = GetChaosTime("Chaos_Drugs", 10.0);
	Log("[Chaos] Running: Chaos_Drugs");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			CreateDrug(i);
		}
	}
	if(g_Drugs_Expire > 0.0) g_Drugs_Timer = CreateTimer(g_Drugs_Expire, Chaos_Drugs, true);
	AnnounceChaos("Drugs", g_Drugs_Expire);
}


float g_EnemyRadar_Expire = 25.0;
Handle g_EnemyRadar_Timer = INVALID_HANDLE;
Action Chaos_EnemyRadar(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("mp_radar_showall", "0");
		StopTimer(g_EnemyRadar_Timer);
	}
	if(DecidingChaos("Chaos_EnemyRadar")) return;

	g_EnemyRadar_Expire = GetChaosTime("Chaos_EnemyRadar", 25.0);
	Log("[Chaos] Running: Chaos_EnemyRadar");
	
	if(g_EnemyRadar_Expire > 0.0) g_EnemyRadar_Timer = CreateTimer(g_EnemyRadar_Expire, Chaos_EnemyRadar, true);
	cvar("mp_radar_showall", "1");
	AnnounceChaos("Enemy Radar", g_EnemyRadar_Expire);
}

void Chaos_Give100HP(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){

	}
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
	if(g_bClearChaos){

	}
	if(DecidingChaos("Chaos_HealAllPlayers")) return;

	Log("[Chaos] Running: Chaos_HealAllPlayers");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntityHealth(i, 100);
		}
	}
	AnnounceChaos("Set all players health to 100", -1.0);
}

float g_BuyAnywhere_Expire = 20.0;
Handle g_BuyAnywhere_Timer = INVALID_HANDLE;
Action Chaos_BuyAnywhere(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("mp_buy_anywhere", "0");
		cvar("mp_buytime", "20");

		StopTimer(g_BuyAnywhere_Timer);
	}
	if(DecidingChaos("Chaos_BuyAnywhere")) return;

	g_BuyAnywhere_Expire = GetChaosTime("Chaos_BuyAnywhere", 20.0);
	Log("[Chaos] Running: Chaos_BuyAnywhere");
	
	cvar("mp_buy_anywhere", "1");
	cvar("mp_buytime", "999");
	AnnounceChaos("Buy Anywhere Enabled!", g_BuyAnywhere_Expire);
	if(g_BuyAnywhere_Expire > 0.0) g_BuyAnywhere_Timer = CreateTimer(g_BuyAnywhere_Expire, Chaos_BuyAnywhere, true);
}

// float g_SimonSays_Duration = 10.0;
void Chaos_SimonSays(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
		g_bSimon_Active = false;
		KillMessageTimer();
	}
	if(DecidingChaos("Chaos_SimonSays")) return;
	g_SimonSays_Duration = GetChaosTime("Chaos_SimonSays", 10.0);
	Log("[Chaos] Running: Chaos_SimonSays");
	GenerateSimonOrder();
	StartMessageTimer();
	g_bSimon_Active = true;
}

float g_ExplosBullets_Duration = 15.0;
Handle g_ExplosBullets_Timer = INVALID_HANDLE;
Action Chaos_ExplosiveBullets(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_ExplosBullets_Timer);
		g_bExplosiveBullets = false;
	}
	if(DecidingChaos("Chaos_ExplosiveBullets")) return;
	g_ExplosBullets_Duration = GetChaosTime("Chaos_ExplosiveBullets", 15.0);
	Log("[Chaos] Running: Chaos_ExplosiveBullets");
	g_bExplosiveBullets = true;
	if(g_ExplosBullets_Duration > 0.0) g_ExplosBullets_Timer = CreateTimer(g_ExplosBullets_Duration, Chaos_ExplosiveBullets, true);
	AnnounceChaos("Explosive Bullets", g_ExplosBullets_Duration);
}

bool g_bSpeedShooter = false;
float g_bSpeedShooter_Expire = 10.0;
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

	g_bSpeedShooter_Expire = GetChaosTime("Chaos_SpeedShooter", 10.0);
	Log("[Chaos] Running: Chaos_SpeedShooter");

	g_bSpeedShooter = true;
	AnnounceChaos("Speed Shooter", g_bSpeedShooter_Expire);
	if(g_bSpeedShooter_Expire > 0.0) g_bSpeedShooter_Timer = CreateTimer(g_bSpeedShooter_Expire, Chaos_SpeedShooter, true);
}

float zero_vector[3] = {0.0, 0.0, 0.0};
void Chaos_ResetSpawns(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){

	}
	if(DecidingChaos("Chaos_ResetSpawns")) return;
	Log("[Chaos] Running: Chaos_ResetSpawns");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			TeleportEntity(i, g_OriginalSpawnVec[i], NULL_VECTOR, zero_vector);
		}
	}
	
	AnnounceChaos("Teleport all players back to spawn", -1.0);
}

bool g_bNoStrafe = false;
float g_fNoStrafe_Expire = 20.0;
Handle g_NoStrafe_Timer = INVALID_HANDLE;
Action Chaos_DisableStrafe(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bNoStrafe = false;

		StopTimer(g_NoStrafe_Timer);
		if(EndChaos) AnnounceChaos("Normal Left/Right Movement", -1.0, true);
	}
	if(DecidingChaos("Chaos_DisableStrafe")) return;
	g_fNoStrafe_Expire = GetChaosTime("Chaos_DisableStrafe", 20.0);
	Log("[Chaos] Running: Chaos_DisableStrafe");
	g_bNoStrafe = true;
	if(g_fNoStrafe_Expire > 0.0) g_NoStrafe_Timer = CreateTimer(g_fNoStrafe_Expire, Chaos_DisableStrafe, true);
	AnnounceChaos("Disable Left/Right Movement", g_fNoStrafe_Expire);
}

bool g_bNoForwardBack = false;
float g_fNoForwardBack_Expire = 20.0;
Handle g_bNoForwardBack_Timer = INVALID_HANDLE;
Action Chaos_DisableForwardBack(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bNoForwardBack = false;

		StopTimer(g_bNoForwardBack_Timer);
		if(EndChaos) AnnounceChaos("Normal Forward/Backward Movement", -1.0, true);
	}
	if(DecidingChaos("Chaos_DisableForwardBack")) return;
	g_fNoForwardBack_Expire = GetChaosTime("Chaos_DisableForwardBack", 20.0);
	Log("[Chaos] Running: Chaos_DisableForwardBack");
	g_bNoForwardBack = true;
	if(g_fNoForwardBack_Expire > 0.0) g_bNoForwardBack_Timer = CreateTimer(g_fNoForwardBack_Expire, Chaos_DisableForwardBack, true);
	AnnounceChaos("Disable Forward/Backward Movement", g_fNoForwardBack_Expire);
}

bool g_bJumping = false;
float g_bJumping_Expire = 15.0;
Handle g_bJumping_Timer_Repeat = INVALID_HANDLE;
Handle g_bJumping_Time = INVALID_HANDLE;
Action Chaos_Jumping(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bJumping = false;

		StopTimer(g_bJumping_Timer_Repeat);
		StopTimer(g_bJumping_Time);

	}
	if(DecidingChaos("Chaos_Jumping")) return;

	g_bJumping_Expire = GetChaosTime("Chaos_Jumping", 15.0);
	Log("[Chaos] Running: Chaos_Jumping");

	StopTimer(g_bJumping_Timer_Repeat);
	g_bJumping = true;
	g_bJumping_Timer_Repeat = CreateTimer(0.3, Timer_ForceJump, _,TIMER_REPEAT);
	if(g_bJumping_Expire > 0.0) g_bJumping_Time = CreateTimer(g_bJumping_Expire, Chaos_Jumping, true);
	AnnounceChaos("Jumping!", g_bJumping_Expire);
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
		StopTimer(g_bJumping_Timer_Repeat);
	}
}


bool g_bDiscoFog = false;
Handle g_bDiscoFog_Timer_Repeat = INVALID_HANDLE;
float g_fDiscoFog_Expire = 25.0;
Handle g_bDiscoFog_Timer = INVALID_HANDLE;
Action Chaos_DiscoFog(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_bDiscoFog_Timer_Repeat);
		StopTimer(g_bDiscoFog_Timer);
		g_bDiscoFog = false;
		Fog_OFF();
	}
	if(DecidingChaos("Chaos_DiscoFog")) return;

	g_fDiscoFog_Expire = GetChaosTime("Chaos_DiscoFog", 25.0);
	Log("[Chaos] Running: Chaos_DiscoFog");
	
	DiscoFog();

	AnnounceChaos("Disco Fog", g_fDiscoFog_Expire);
	g_bDiscoFog = true;
	g_bDiscoFog_Timer_Repeat = CreateTimer(1.0, Timer_NewFogColor, _,TIMER_REPEAT);
	if(g_fDiscoFog_Expire > 0) g_bDiscoFog_Timer = CreateTimer(g_fDiscoFog_Expire, Chaos_DiscoFog, true);
}

public Action Timer_NewFogColor(Handle timer){
	if(g_bDiscoFog){
		char color[32];
		FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
		DispatchKeyValue(g_iFog, "fogcolor", color);
	}else{
		StopTimer(g_bDiscoFog_Timer_Repeat);
	}
}


float g_bOneBulletOneGun_Expire = 15.0;
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

	g_bOneBulletOneGun_Expire = GetChaosTime("Chaos_OneBulletOneGun", 15.0);
	Log("[Chaos] Running: Chaos_OneBulletOneGun");

	g_bOneBulletOneGun = true; //handled somehwere in events.sp
	AnnounceChaos("One Bullet One Gun", g_bOneBulletOneGun_Expire);
	if(g_bOneBulletOneGun_Expire > 0.0) g_OneBuilletOneGun_Timer = CreateTimer(g_bOneBulletOneGun_Expire, Chaos_OneBulletOneGun, true);
}

float g_Earthquake_Duration = 7.0;
void Chaos_Earthquake(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){    }
	if(DecidingChaos("Chaos_Earthquake")) return;

	g_Earthquake_Duration = GetChaosTime("Chaos_Earthquake", 5.0);
	Log("[Chaos] Running: Chaos_Earthquake");
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ScreenShake(i, _, g_Earthquake_Duration);
		}
	}
	AnnounceChaos("Earthquake", -1.0);
}

stock int ScreenShake(int iClient, float fAmplitude = 50.0, float duration = 7.0){
	Handle hMessage = StartMessageOne("Shake", iClient, 1);
	
	PbSetInt(hMessage, "command", 0);
	PbSetFloat(hMessage, "local_amplitude", fAmplitude);
	PbSetFloat(hMessage, "frequency", 255.0);
	PbSetFloat(hMessage, "duration", duration);
	
	EndMessage();
}


float g_ChickenPlayers_Expire = 20.0;
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

	g_ChickenPlayers_Expire = GetChaosTime("Chaos_ChickenPlayers", 20.0);
	Log("[Chaos] Running: Chaos_ChickenPlayers");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetChicken(i);
	if(g_ChickenPlayers_Expire > 0) g_ChickenPlayers_Timer = CreateTimer(g_ChickenPlayers_Expire, Chaos_ChickenPlayers, true);
	AnnounceChaos("Make all players a chicken", g_ChickenPlayers_Expire);
}


void Chaos_IgnitePlayer(bool forceAllPlayers = false){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){    }
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

float g_LockPlayersAim_Expire = 20.0;
Handle g_LockPlayersAim_Timer_Expire = INVALID_HANDLE; //keeps track of when to end the event
Handle g_LockPlayersAim_Timer_Enforce = INVALID_HANDLE; //enforces locked aim
bool g_bLockPlayersAim_Active = false;
float g_LockPlayersAim_Angles[MAXPLAYERS+1][3];
Action Chaos_LockPlayersAim(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		g_bLockPlayersAim_Active = false;
		StopTimer(g_LockPlayersAim_Timer_Expire);
		StopTimer(g_LockPlayersAim_Timer_Enforce);
		if(EndChaos) AnnounceChaos("Lock Mouse Movement", -1.0, true);
	}
	if(DecidingChaos("Chaos_LockPlayersAim")) return;

	g_LockPlayersAim_Expire = GetChaosTime("Chaos_LockPlayersAim", 20.0);
	Log("[Chaos] Running: Chaos_LockPlayersAim");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GetClientEyeAngles(i, g_LockPlayersAim_Angles[i]);
	// g_LockPlayersAim_Timer_Enforce = CreateTimer(0.01, Timer_EnforcePlayerLock, _, TIMER_REPEAT);
	g_bLockPlayersAim_Active  = true;
	if(g_LockPlayersAim_Expire > 0) g_LockPlayersAim_Timer_Expire = CreateTimer(g_LockPlayersAim_Expire, Chaos_LockPlayersAim, true);
	AnnounceChaos("Lock Mouse Movement", g_LockPlayersAim_Expire);
}
//potentially to add in OnPlayerRunCmd?

// Action Timer_EnforcePlayerLock(Handle timer){
// 	if(g_bLockPlayersAim_Active){
// 		for(int i = 0; i <= MaxClients; i++){
// 			if(ValidAndAlive(i)){
// 				TeleportEntity(i, NULL_VECTOR, g_LockPlayersAim_Angles[i], NULL_VECTOR);
// 			}
// 		}
// 	}else{
// 		StopTimer(g_LockPlayersAim_Timer_Enforce);
// 	}
// }

float g_SlowSpeed_Expire = 20.0;
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

	g_SlowSpeed_Expire = GetChaosTime("Chaos_SlowSpeed", 20.0);
	Log("[Chaos] Running: Chaos_SlowSpeed");

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.5);
	AnnounceChaos("0.5x Movement Speed", g_SlowSpeed_Expire);
	if(g_SlowSpeed_Expire > 0) g_SlowSpeed_Timer = CreateTimer(g_SlowSpeed_Expire, Chaos_SlowSpeed, true);
}

float g_FastSpeed_Expire = 20.0;
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

	g_FastSpeed_Expire = GetChaosTime("Chaos_FastSpeed", 20.0);
	Log("[Chaos] Running: Chaos_FastSpeed");
	
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 3.0);
	AnnounceChaos("3x Movement Speed", g_FastSpeed_Expire);
	if(g_FastSpeed_Expire > 0) g_FastSpeed_Timer = CreateTimer(g_FastSpeed_Expire, Chaos_FastSpeed, true);
}

void Chaos_RespawnTheDead(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){	}
	if(DecidingChaos("Chaos_RespawnTheDead")) return;
	Log("[Chaos] Running: Chaos_RespawnTheDead");
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			if(!IsPlayerAlive(i)){
				CS_RespawnPlayer(i);
			}
		}
	}
	// AnnounceChaos("The Dead Have Awaken");
	AnnounceChaos("Resurrect dead players", -1.0);
}

void Chaos_RespawnTheDead_Randomly(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){	}
	if(DecidingChaos("Chaos_RespawnTheDead_Randomly")) return;
	Log("[Chaos] Running: Chaos_RespawnTheDead_Randomly");

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			if(!IsPlayerAlive(i)){
				CS_RespawnPlayer(i);
				DoRandomTeleport(i);
			}
		}
	}
	AnnounceChaos("Resurrect dead players in random locations", -1.0);
}

void Chaos_Bumpmines(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){	}
	if(DecidingChaos("Chaos_Bumpmines")) return;
	Log("[Chaos] Running: Chaos_Bumpmines");
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GivePlayerItem(i, "weapon_bumpmine");
	AnnounceChaos("Bumpmines", -1.0);
}

Action Chaos_Spin180(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){	}
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
float g_fPortalGuns_Expire = 20.0; //config
Handle g_bPortalGuns_Timer = INVALID_HANDLE;
Action Chaos_PortalGuns(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			TeleportPlayersToClosestLocation();
			AnnounceChaos("Portal Guns", -1.0, true);
		}
		g_bPortalGuns = false;
		StopTimer(g_bPortalGuns_Timer);
	}
	if(DecidingChaos("Chaos_PortalGuns")) return;

	g_fPortalGuns_Expire = GetChaosTime("Chaos_PortalGuns", 20.0);
	Log("[Chaos] Running: Chaos_PortalGuns");
	
	g_bPortalGuns = true;
	AnnounceChaos("Portal Guns", g_fPortalGuns_Expire);
	SavePlayersLocations();
	if(g_fPortalGuns_Expire > 0) g_bPortalGuns_Timer = CreateTimer(g_fPortalGuns_Expire, Chaos_PortalGuns, true);
}


// Action Chaos_TeleportFewMeters(Handle timer = null, bool EndChaos = false){
void Chaos_TeleportFewMeters(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){	}
	if(DecidingChaos("Chaos_TeleportFewMeters")) return;

	Log("[Chaos] Running: Chaos_TeleportFewMeters");
	
	SavePlayersLocations();
	TeleportPlayersToClosestLocation(-1, 250); //250 units of minimum teleport distance
	AnnounceChaos("Teleport Players A Few Meters", -1.0);
}



float g_InfiniteGrenades_Expire = 20.0; //config
Handle g_InfiniteGrenade_Timer = INVALID_HANDLE;
Action Chaos_InfiniteGrenades(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_InfiniteGrenade_Timer);
		cvar("sv_infinite_ammo", "0");
		if(EndChaos) AnnounceChaos("Infinite Grenades", -1.0,  true);
	}
	if(DecidingChaos("Chaos_InfiniteGrenades")) return;
	
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
	AnnounceChaos("Infinite Grenades", g_InfiniteGrenades_Expire);
	if(g_InfiniteGrenades_Expire > 0) g_InfiniteGrenade_Timer = CreateTimer(g_InfiniteGrenades_Expire, Chaos_InfiniteGrenades, true);
}

void Chaos_Shields(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){	}
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
				}else{
					FakeClientCommand(i, "use %s", playerWeapon);
				}
			}
		}
	}
	AnnounceChaos("Shields", -1.0);
}


float g_IsThisMexico_Expire = 30.0;
Handle g_IsThisMexico_Timer = INVALID_HANDLE;
Action Chaos_IsThisMexico(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		Fog_OFF();
		if(EndChaos) AnnounceChaos("Is This What Mexico Looks Like?", -1.0, true);
		StopTimer(g_IsThisMexico_Timer);
	}
	if(DecidingChaos("Chaos_IsThisMexico")) return;
	g_IsThisMexico_Expire = GetChaosTime("Chaos_IsThisMexico", 30.0);
	Log("[Chaos] Running: Chaos_IsThisMexico");
	Mexico();
	AnnounceChaos("Is This What Mexico Looks Like?", g_IsThisMexico_Expire);
	if(g_IsThisMexico_Expire > 0) g_IsThisMexico_Timer = CreateTimer(g_IsThisMexico_Expire, Chaos_IsThisMexico, true);
}

float g_OneWeaponOnly_Expire = 30.0;
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

	g_OneWeaponOnly_Expire = GetChaosTime("Chaos_OneWeaponOnly", 30.0);
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
	AnnounceChaos(chaosMsg, g_OneWeaponOnly_Expire);
	if(g_OneWeaponOnly_Expire > 0) g_OneWeaponOnly_Timer = CreateTimer(g_OneWeaponOnly_Expire, Chaos_OneWeaponOnly, true);
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
		newBombPosition[2] = newBombPosition[2] - 64;
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
	if(g_bClearChaos){
		RemoveChickens();
	}
	if(DecidingChaos("Chaos_Impostors")) return;
	Log("[Chaos] Running: Chaos_Impostors");

	SpawnImpostors();

	AnnounceChaos("Impostors", -1.0);
}

public void Chaos_MamaChook(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){
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
	if(g_bClearChaos){
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
	if(g_bClearChaos){
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
float g_OneBuilletMag_Expire = 20.0; //config
Handle g_bOneBulletMagTimer = INVALID_HANDLE;
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

		StopTimer(g_bOneBulletMagTimer);
	}
	if(DecidingChaos("Chaos_OneBulletMag")) return;
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
	g_bOneBulletMag = true;
	if(g_OneBuilletMag_Expire > 0) g_bOneBulletMagTimer = CreateTimer(g_OneBuilletMag_Expire, Chaos_OneBulletMag, true);
	AnnounceChaos("One Bullet Mags", g_OneBuilletMag_Expire);
}

float g_CrabPeople_Expire = 15.0;
Handle g_CrabPeopleTimer = INVALID_HANDLE;
bool g_bForceCrouch = false;
Action Chaos_CrabPeople(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		g_bForceCrouch = false;
		StopTimer(g_CrabPeopleTimer);
		if(EndChaos) AnnounceChaos("Crab People", -1.0, true);
	}
	if(DecidingChaos("Chaos_CrabPeople")) return;
	g_CrabPeople_Expire = GetChaosTime("Chaos_CrabPeople", 15.0);
	Log("[Chaos] Running: Chaos_CrabPeople");
	g_bForceCrouch = true;
	AnnounceChaos("Crab People", g_CrabPeople_Expire);
	if(g_CrabPeople_Expire > 0) g_CrabPeopleTimer = CreateTimer(g_CrabPeople_Expire, Chaos_CrabPeople, true);
}

bool g_bNoscopeOnly = false;
float g_bNoscopeOnly_Expire = 20.0;
Handle g_bNoscopeOnly_Timer = INVALID_HANDLE;
Action Chaos_NoScopeOnly(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_bNoscopeOnly_Timer);
		g_bNoscopeOnly = false;
		if(EndChaos) AnnounceChaos("You can now scope again", -1.0, true);
	}
	if(DecidingChaos("Chaos_NoScopeOnly")) return;
	g_bNoscopeOnly_Expire = GetChaosTime("Chaos_NoScopeOnly", 20.0);
	Log("[Chaos] Running: Chaos_NoScopeOnly");
	g_bNoscopeOnly = true;
	if(g_bNoscopeOnly_Expire > 0) g_bNoscopeOnly_Timer = CreateTimer(g_bNoscopeOnly_Expire, Chaos_NoScopeOnly, true);
	AnnounceChaos("No scopes only", g_bNoscopeOnly_Expire);
}

void Chaos_MoneyRain(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){ cvar("sv_dz_cash_bundle_size", "50"); }
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
float g_Vampire_Expire = 30.0;
Handle g_Vampire_Timer = INVALID_HANDLE;
Action Chaos_VampireHeal(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_Vampire_Timer);
		g_bVampireRound = false;
		if(EndChaos) AnnounceChaos("Vampires", -1.0, true);
	}
	if(DecidingChaos("Chaos_VampireHeal")) return;

	g_Vampire_Expire = GetChaosTime("Chaos_VampireHeal", 30.0);
	Log("[Chaos] Running: Chaos_VampireHeal");

	g_bVampireRound = true;
	AnnounceChaos("Vampires", g_Vampire_Expire);
	if(g_Vampire_Expire > 0) g_Vampire_Timer = CreateTimer(g_Vampire_Expire, Chaos_VampireHeal, true);
}


void Chaos_C4Chicken(){
	if(CountingCheckDecideChaos()) return; 
	if(g_bClearChaos){
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
float g_DecoyDoge_Expire = 20.0;
Handle g_bDecoyDodgeballTimer = INVALID_HANDLE;
Handle g_bDecoyDodgeball_CheckDecoyTimer = INVALID_HANDLE;
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
		StopTimer(g_bDecoyDodgeballTimer);
		delete g_bDecoyDodgeball_CheckDecoyTimer;

	}
	if(DecidingChaos("Chaos_DecoyDodgeball")) return;
	g_DecoyDoge_Expire = GetChaosTime("Chaos_DecoyDodgeball", 20.0);
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
	AnnounceChaos("Decoy Dodgeball", g_DecoyDoge_Expire);
	if(g_DecoyDoge_Expire > 0) g_bDecoyDodgeballTimer = CreateTimer(g_DecoyDoge_Expire, Chaos_DecoyDodgeball, true);
	g_bDecoyDodgeball_CheckDecoyTimer = CreateTimer(5.0, Timer_CheckDecoys, _, TIMER_REPEAT);
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

float g_bHeadshotOnly_Expire = 20.0;
Handle g_bHeadshotOnly_Timer = INVALID_HANDLE;
Action Chaos_HeadshotOnly(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_bHeadshotOnly_Timer);
		cvar("mp_damage_headshot_only", "0");
	}
	if(DecidingChaos("Chaos_HeadshotOnly")) return;
	g_bHeadshotOnly_Expire = GetChaosTime("Chaos_HeadshotOnly", 20.0);
	Log("[Chaos] Running: Chaos_HeadshotOnly");
	cvar("mp_damage_headshot_only", "1");
	AnnounceChaos("Headshots Only", g_bHeadshotOnly_Expire);
	if(g_bHeadshotOnly_Expire > 0) g_bHeadshotOnly_Timer = CreateTimer(g_bHeadshotOnly_Expire, Chaos_HeadshotOnly, true);
}

float g_ohko_Expire = 15.0;
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
	g_ohko_Expire = GetChaosTime("Chaos_OHKO", 15.0);
	Log("[Chaos] Running: Chaos_OHKO");
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 1);
	AnnounceChaos("1 HP", g_ohko_Expire);
	if(g_ohko_Expire > 0) g_ohko_Timer = CreateTimer(g_ohko_Expire, Chaos_OHKO, true);
}

float g_InsaneGravity_Expire = 20.0;
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
	g_InsaneGravity_Expire = GetChaosTime("Chaos_InsaneGravity", 20.0);
	Log("[Chaos] Running: Chaos_InsaneGravity");
	cvar("sv_gravity", "3000");
	ServerCommand("sv_falldamage_scale 0");
	if(g_InsaneGravity_Expire > 0) g_InsaneGravityTimer = CreateTimer(g_InsaneGravity_Expire, Chaos_InsaneGravity, true);
	AnnounceChaos("Insane Gravity", g_InsaneGravity_Expire);
}

void Chaos_Nothing(){
	if(CountingCheckDecideChaos()) return;
	if(DecidingChaos("Chaos_Nothing")) return;
	Log("[Chaos] Running: Chaos_Nothing");
	AnnounceChaos("Nothing", -1.0);
}

Handle g_IceySurface_Timer = INVALID_HANDLE;
float g_IceySurface_Expire = 20.0;
Action Chaos_IceySurface(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return; 
	if(ClearChaos(EndChaos)){
		StopTimer(g_IceySurface_Timer);
		cvar("sv_friction", "5.2");
		if(EndChaos) AnnounceChaos("Icey Ground", -1.0, true);
	}
	if(DecidingChaos("Chaos_IceySurface")) return;
	g_IceySurface_Expire = GetChaosTime("Chaos_IceySurface", 20.0);
	Log("[Chaos] Running: Chaos_IceySurface");
	cvar("sv_friction", "0");
	AnnounceChaos("Icey Ground", g_IceySurface_Expire);
	if(g_IceySurface_Expire > 0) g_IceySurface_Timer = CreateTimer(g_IceySurface_Expire, Chaos_IceySurface, true);
}

Handle Chaos_RandomSlap_Timer = INVALID_HANDLE;
float g_Chaos_RandomSlap_Interval = 7.0;
float g_RandomSlap_Expire = 30.0;
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
	g_RandomSlap_Expire = GetChaosTime("Chaos_RandomSlap", 30.0);
	Log("[Chaos] Running: Chaos_RandomSlap");
	StopTimer(Chaos_RandomSlap_Timer);
	cvar("sv_falldamage_scale", "0");
	Chaos_RandomSlap_Timer = CreateTimer(g_Chaos_RandomSlap_Interval, Timer_RandomSlap, _,TIMER_REPEAT);
	if(g_RandomSlap_Expire > 0) g_RandomSlapDuration_Timer = CreateTimer(g_RandomSlap_Expire, Chaos_RandomSlap, true);
	AnnounceChaos("Ghost Slaps", g_RandomSlap_Expire);
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

	g_TaserParty_Expire = GetChaosTime("Chaos_TaserParty", 10.0);
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
	if(g_TaserParty_Expire > 0) g_TaserParty_Timer = CreateTimer(g_TaserParty_Expire, Chaos_TaserParty, true);
	AnnounceChaos("Taser Party!", g_TaserParty_Expire);
}

bool g_bKnifeFight = false;
float g_bKnifeFight_Expire = 15.0;
Handle g_bKnifeFight_Timer = INVALID_HANDLE;
Action Chaos_KnifeFight(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_bKnifeFight_Timer);
		g_bKnifeFight = false;
		
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) ClientCommand(i, "slot1");
			AnnounceChaos("Knife Fight", -1.0, true);
		}
	}
	if(DecidingChaos("Chaos_KnifeFight")) return;
	g_bKnifeFight_Expire = GetChaosTime("Chaos_KnifeFight", 15.0);
	Log("[Chaos] Running: Chaos_KnifeFight");
	g_bKnifeFight = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			FakeClientCommand(i, "use weapon_knife");
		}
	}
	if(g_bKnifeFight_Expire > 0) g_bKnifeFight_Timer = CreateTimer(g_bKnifeFight_Expire, Chaos_KnifeFight, true);
	AnnounceChaos("Knife Fight!", g_bKnifeFight_Expire);
}

float g_Funky_Expire = 30.0;
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

	g_Funky_Expire = GetChaosTime("Chaos_Funky", 30.0);
	Log("[Chaos] Running: Chaos_Funky");
	
	cvar("sv_airaccelerate", "2000");
	cvar("sv_enablebunnyhopping", "1");
	cvar("sv_autobunnyhopping", "1");
	if(g_Funky_Expire > 0) g_Funky_Timer = CreateTimer(g_Funky_Expire, Chaos_Funky, true);
	AnnounceChaos("Are you feeling {orchid}funky{default}?", g_Funky_Expire);
}

// bool g_bRandomWeaponRound = false;
float g_RandWep_Expire = 30.0;
Handle g_RandWep_Timer = INVALID_HANDLE;
float g_fChaos_RandomWeapons_Interval = 5.0; //5+ recommended for bomb plants

Action Chaos_RandomWeapons(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		g_bPlayersCanDropWeapon = true;
		// g_RandomWeaponRound = false;
		StopTimer(g_Chaos_RandomWeapons_Timer);
		StopTimer(g_RandWep_Timer);
	}
	if(DecidingChaos("Chaos_RandomWeapons")) return;

	g_RandWep_Expire = GetChaosTime("Chaos_RandomWeapons", 30.0);
	Log("[Chaos] Running: Chaos_RandomWeapons");


	StopTimer(g_Chaos_RandomWeapons_Timer);
	// g_RandomWeaponRound = true;
	g_bPlayersCanDropWeapon = false;
	Timer_GiveRandomWeapon();
	g_Chaos_RandomWeapons_Timer = CreateTimer(g_fChaos_RandomWeapons_Interval, Timer_GiveRandomWeapon, _, TIMER_REPEAT);
	if(g_RandWep_Expire > 0) g_RandWep_Timer = CreateTimer(g_RandWep_Expire, Chaos_RandomWeapons, true);
	AnnounceChaos("Random Weapons!", g_RandWep_Expire);
}
Action Timer_GiveRandomWeapon(Handle timer = null){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			int randomWeaponIndex = GetRandomInt(0,sizeof(g_sWeapons)-1);	
			GiveAndSwitchWeapon(i, g_sWeapons[randomWeaponIndex]);
		}
	}
}

float g_MoonGravity_Duration = 30.0;
Handle g_MoonGravity_Timer = INVALID_HANDLE;
Action Chaos_MoonGravity(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_MoonGravity_Timer);
		cvar("sv_gravity", "800");
		if(EndChaos) AnnounceChaos("Moon Gravity", -1.0, true);
	}
	if(DecidingChaos("Chaos_MoonGravity")) return;

	g_MoonGravity_Duration = GetChaosTime("Chaos_MoonGravity", 30.0);
	Log("[Chaos] Running: Chaos_MoonGravity");
	//TODO fluctuating gravity thoughout the round?
	cvar("sv_gravity", "300");
	if(g_MoonGravity_Duration > 0) g_MoonGravity_Timer = CreateTimer(g_MoonGravity_Duration, Chaos_MoonGravity, true);
	AnnounceChaos("Moon Gravity", g_MoonGravity_Duration);
}


//TODO use the map coordinates to make it look like cool raining in another effect
Handle Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
float g_Chaos_RandomMolotovSpawn_Interval = 5.0; //5+ recommended for bomb plants

int g_MolotovSpawn_Count = 0;
bool g_bRainingFireEnabled = false;
public void Chaos_RandomMolotovSpawn(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
		cvar("inferno_flame_lifetime", "7");
		StopTimer(Chaos_MolotovSpawn_Timer);
		g_bRainingFireEnabled = false;
	}		
	if(DecidingChaos("Chaos_RandomMolotovSpawn")) return;
	if(!g_bRainingFireEnabled){
		g_bRainingFireEnabled = true;
		g_MolotovSpawn_Count = RoundToFloor(GetChaosTime("Chaos_RandomMolotovSpawn", 5.0));
		Log("[Chaos] Running: Chaos_RandomMolotovSpawn");
		g_MolotovSpawn_Count = 0;
		cvar("inferno_flame_lifetime", "4");
		Chaos_MolotovSpawn_Timer = CreateTimer(g_Chaos_RandomMolotovSpawn_Interval, Timer_SpawnMolotov, _, TIMER_REPEAT);
		AnnounceChaos("Raining Fire!", 25.0);
	}else{
		RetryEvent();
	}
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


float g_ESP_Duration = 30.0;
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
	g_ESP_Duration = GetChaosTime("Chaos_ESP", 30.0);
	Log("[Chaos] Running: Chaos_ESP");
	cvar("sv_force_transmit_players", "1");
	createGlows();
	AnnounceChaos("Wall Hacks", g_ESP_Duration);
	if(g_ESP_Duration > 0) g_ESP_Timer = CreateTimer(g_ESP_Duration, Chaos_ESP, true);
}

Handle g_ReversedMovementTimer = INVALID_HANDLE;
float g_ReversedMovement_Duration = 20.0;
Action Chaos_ReversedMovement(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		cvar("sv_accelerate", "5.5");
		// cvar("sv_airaccelerate", "12");

		StopTimer(g_ReversedMovementTimer);
		if(EndChaos) AnnounceChaos("Reversed Movement", -1.0, true);
	}
	if(DecidingChaos("Chaos_ReversedMovement")) return;
	g_ReversedMovement_Duration = GetChaosTime("Chaos_ReversedMovement", 20.0);
	Log("[Chaos] Running: Chaos_ReversedMovement");
	cvar("sv_accelerate", "-5.5");
	if(g_ReversedMovement_Duration > 0) g_ReversedMovementTimer = CreateTimer(g_ReversedMovement_Duration, Chaos_ReversedMovement, true);
	AnnounceChaos("Reversed Movement", g_ReversedMovement_Duration);
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
	if(g_bClearChaos){	

	}
	if(DecidingChaos("Chaos_TeammateSwap")) return;
	Log("[Chaos] Running: Chaos_TeammateSwap");

	ClearArray(TPos);
	ClearArray(CTPos);
	ClearArray(tIndex);
	ClearArray(ctIndex);

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_T){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			PushArrayArray(TPos, vec);
		}else if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_CT){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			PushArrayArray(CTPos, vec);
		} 
	}

	for(int i = MaxClients; i >= 0; i--){
		if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_T){
			PushArrayCell(tIndex, i);
		}else if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_CT){
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

	AnnounceChaos("Teammate Swap!", -1.0);
}

//Allows nowclippers to take damage
bool g_bActiveNoclip = false;
float g_Flying_Expire = 10.0;
Handle g_ResetNoclipTimer = INVALID_HANDLE;

Action Chaos_Flying(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
	
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetEntityMoveType(i, MOVETYPE_WALK);
			TeleportPlayersToClosestLocation();
			AnnounceChaos("Flying", -1.0, true);
		}
		cvar("sv_noclipspeed", "5");
		g_bActiveNoclip = false;	
		StopTimer(g_ResetNoclipTimer);
	}
	if(DecidingChaos("Chaos_Flying")) return;
	g_Flying_Expire = GetChaosTime("Chaos_Flying", 10.0);
	Log("[Chaos] Running: Chaos_Flying");
	g_bActiveNoclip = true;	
	SavePlayersLocations();
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityMoveType(i, MOVETYPE_NOCLIP);
	cvar("sv_noclipspeed", "2");
	if(g_Flying_Expire > 0) g_ResetNoclipTimer = CreateTimer(g_Flying_Expire, Chaos_Flying, true);
	AnnounceChaos("Flying", g_Flying_Expire);
}

void Chaos_RandomTeleport(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){	
		// if(g_UnusedCoordinates != INVALID_HANDLE) g_UnusedCoordinates;
	}
	if(DecidingChaos("Chaos_RandomTeleport")) return;
	Log("[Chaos] Running: Chaos_RandomTeleport");
	DoRandomTeleport();

	AnnounceChaos("Random Teleport", -1.0);
}

void Chaos_LavaFloor(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){	
		// if(g_UnusedCoordinates != INVALID_HANDLE) g_UnusedCoordinates;
	}
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

float g_Quake_Duration = 25.0;
Handle g_Quake_Timer = INVALID_HANDLE;
Action Chaos_QuakeFOV(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_Quake_Timer);
		ResetPlayersFOV();
	}
	if(DecidingChaos("Chaos_QuakeFOV")) return;
	g_Quake_Duration = GetChaosTime("Chaos_QuakeFOV", 25.0);
	Log("[Chaos] Running: Chaos_QuakeFOV");
	int RandomFOV = GetRandomInt(110,160);
	SetPlayersFOV(RandomFOV);
	if(g_Quake_Duration > 0) g_Quake_Timer = CreateTimer(g_Quake_Duration, Chaos_QuakeFOV, true);
	AnnounceChaos("Quake FOV", g_Quake_Duration);
}

float g_Binoculars_Duration = 25.0;
Handle g_Binoculars_Timer = INVALID_HANDLE;
Action Chaos_Binoculars(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_Binoculars_Timer);
		ResetPlayersFOV();
	}
	if(DecidingChaos("Chaos_Binoculars")) return;
	g_Quake_Duration = GetChaosTime("Chaos_Binoculars", 25.0);
	Log("[Chaos] Running: Chaos_Binoculars");
	int RandomFOV = GetRandomInt(20,50);
	SetPlayersFOV(RandomFOV);
	if(g_Binoculars_Duration > 0) g_Binoculars_Timer = CreateTimer(g_Binoculars_Duration, Chaos_Binoculars, true);
	AnnounceChaos("Binoculars", g_Binoculars_Duration);
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
float g_Chaos_BlindLength = 7.0; //how long the player is blind for.
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

	g_Chaos_BlindLength = GetChaosTime("Chaos_BlindPlayers", 7.0);
	Log("[Chaos] Running: Chaos_BlindPlayers");

	for(int client = 0; client <= MaxClients; client++){
		if(IsValidClient(client)){
			PerformBlind(client, 255);
		}
	}
	g_BlindPlayers_Timer = CreateTimer(g_Chaos_BlindLength, Chaos_BlindPlayers, true);
	AnnounceChaos("Blind", g_Chaos_BlindLength);
}

float g_Aimbot_Duration = 30.0;
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

	g_Aimbot_Duration = GetChaosTime("Chaos_Aimbot", 30.0);
	Log("[Chaos] Running: Chaos_Aimbot");

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			Aimbot_SDKHOOKS(i);
			ToggleAim(i, true);
		}
	}
	if(g_Aimbot_Duration > 0) g_Aimbot_Timer = CreateTimer(g_Aimbot_Duration, Chaos_Aimbot, true);
	AnnounceChaos("Aimbot", g_Aimbot_Duration);
}

float g_NoSpread_Duration = 25.0;
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

	g_NoSpread_Duration = GetChaosTime("Chaos_NoSpread", 25.0);
	Log("[Chaos] Running: Chaos_NoSpread");
	
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");
	AnnounceChaos("100\% Weapon Accuracy", g_NoSpread_Duration);
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
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_IncRecoil_Timer);
		cvar("weapon_recoil_scale", "2");
		if(EndChaos) AnnounceChaos("Increased Recoil", -1.0, true);
	}
	if(DecidingChaos("Chaos_IncreasedRecoil")) return;
	Log("[Chaos] Running: Chaos_IncreasedRecoil");
	cvar("weapon_recoil_scale", "10");
	AnnounceChaos("Increased Recoil", g_IncRecoil_Duration);
	if(g_IncRecoil_Duration > 0) g_IncRecoil_Timer = CreateTimer(g_IncRecoil_Duration, Chaos_IncreasedRecoil, true);
}

float g_ReverseRecoil_Duration = 25.0;
Handle g_ReverseRecoil_Timer = INVALID_HANDLE;
Action Chaos_ReversedRecoil(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){	
		StopTimer(g_ReverseRecoil_Timer);
		cvar("weapon_recoil_scale", "2");
		if(EndChaos) AnnounceChaos("Reversed Recoil", -1.0, true);
	}
	if(DecidingChaos("Chaos_ReversedRecoil")) return;
	Log("[Chaos] Running: Chaos_ReversedRecoil");
	cvar("weapon_recoil_scale", "-5");
	AnnounceChaos("Reversed Recoil", g_ReverseRecoil_Duration);
	if(g_ReverseRecoil_Duration > 0) g_ReverseRecoil_Timer = CreateTimer(g_ReverseRecoil_Duration, Chaos_ReversedRecoil, true);
}

void Chaos_Jackpot(){
	if(CountingCheckDecideChaos()) return;
	// if(g_bClearChaos){	}
	if(DecidingChaos("Chaos_Jackpot")) return;
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetClientMoney(i, 16000);
	Log("[Chaos] Running: Chaos_Jackpot");
	AnnounceChaos("Jackpot", -1.0);
}

void Chaos_Bankrupt(){
	if(CountingCheckDecideChaos()) return;
	// if(g_bClearChaos){}
	if(DecidingChaos("Chaos_Bankrupt")) return;
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetClientMoney(i, 0, true);
	Log("[Chaos] Running: Chaos_Bankrupt");
	AnnounceChaos("Bankrupt", -1.0);
}

//TODO: chnage to a giverandomplayer function so i can ignite random player or something
void Chaos_SlayRandomPlayer(){
	if(CountingCheckDecideChaos()) return;
	// if(g_bClearChaos){}
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


float g_AlienKnifeFight_Expire = 15.0;
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
	g_AlienKnifeFight_Expire = GetChaosTime("Chaos_AlienModelKnife", 15.0);
	Log("[Chaos] Running: Chaos_AlienModelKnife");
	//hitboxes are tiny, but knives work fine
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntPropFloat(i, Prop_Send, "m_flModelScale", 0.5);
			// SetEntProp(i, Prop_Send, "m_ScaleType", 5); //TODO EXPERIEMNT WITH
			SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0*0.55);
		}
	}
	if(g_AlienKnifeFight_Expire > 0) g_AlienKnifeFightTimer = CreateTimer(g_AlienKnifeFight_Expire, Chaos_AlienModelKnife, true);
	g_bKnifeFight = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 2.0);
			FakeClientCommand(i, "use weapon_knife");
		}
	}
	AnnounceChaos("Alien Knife Fight", g_AlienKnifeFight_Expire);
}

float g_LightsOff_Duration = 30.0;
Handle g_LightsOff_Timer = INVALID_HANDLE;
Action Chaos_LightsOff(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_LightsOff_Timer);
		Fog_OFF();
	}
	if(DecidingChaos("Chaos_LightsOff")) return;

	g_LightsOff_Duration = GetChaosTime("Chaos_LightsOff", 30.0);
	Log("[Chaos] Running: Chaos_LightsOff");
	LightsOff();
	AnnounceChaos("Who turned the lights off?", g_LightsOff_Duration);
	if(g_LightsOff_Duration  > 0) g_LightsOff_Timer = CreateTimer(g_LightsOff_Duration, Chaos_LightsOff, true);
	//Random chance for night vision? or separate chaos

}

void Chaos_NightVision(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
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


float g_NormalWhiteFog_Duration = 45.0;
Handle g_NormalWhiteFog_Timer = INVALID_HANDLE;
Action Chaos_NormalWhiteFog(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_NormalWhiteFog_Timer);
		AcceptEntityInput(g_iFog, "TurnOff");
	}
	if(DecidingChaos("Chaos_NormalWhiteFog")) return;
	g_NormalWhiteFog_Duration = GetChaosTime("Chaos_NormalWhiteFog", 45.0);
	Log("[Chaos] Running: Chaos_NormalWhiteFog");
	NormalWhiteFog();

	AnnounceChaos("Fog", g_NormalWhiteFog_Duration);
	if(g_NormalWhiteFog_Duration > 0) g_NormalWhiteFog_Timer = CreateTimer(g_NormalWhiteFog_Duration, Chaos_NormalWhiteFog, true);

}

float g_ExtremeWhiteFog_Duration = 45.0;
Handle g_ExtremeWhiteFog_Timer = INVALID_HANDLE;
Action Chaos_ExtremeWhiteFog(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		Fog_OFF();
		StopTimer(g_ExtremeWhiteFog_Timer);
	}
	if(DecidingChaos("Chaos_ExtremeWhiteFog")) return;
	g_ExtremeWhiteFog_Duration = GetChaosTime("Chaos_NormalWhiteFog", 45.0);
	Log("[Chaos] Running: Chaos_NormalWhiteFog");
	ExtremeWhiteFog();
	AnnounceChaos("Extreme Fog", g_ExtremeWhiteFog_Duration);
	if(g_ExtremeWhiteFog_Duration > 0) g_ExtremeWhiteFog_Timer = CreateTimer(g_ExtremeWhiteFog_Duration, Chaos_ExtremeWhiteFog, true);

}


void Chaos_RandomSkybox(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
	}
	if(DecidingChaos("Chaos_RandomSkybox")) return;
	
	Log("[Chaos] Running: Chaos_RandomSkybox");
	int randomSkyboxIndex = GetRandomInt(0, sizeof(g_sSkyboxes)-1);
	DispatchKeyValue(0, "skyname", g_sSkyboxes[randomSkyboxIndex]);
	AnnounceChaos("Random Skybox", -1.0);

}

float g_LowRender_Duration = 30.0;
Handle g_LowRender_Timer = INVALID_HANDLE;
Action Chaos_LowRenderDistance(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		StopTimer(g_LowRender_Timer);
		ResetRenderDistance();
	}
	if(DecidingChaos("Chaos_LowRenderDistance")) return;
	g_LowRender_Duration = GetChaosTime("Chaos_LowRenderDistance", 30.0);
	Log("[Chaos] Running: Chaos_LowRenderDistance");
	LowRenderDistance();
	AnnounceChaos("Low Render Distance", g_LowRender_Duration);
	if(g_LowRender_Duration > 0 ) g_LowRender_Timer = CreateTimer(g_LowRender_Duration, Chaos_LowRenderDistance, true);

}


float g_Thirdperson_Expire = 15.0;
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
	AnnounceChaos("Thirdperson", g_Thirdperson_Expire);
}

void Chaos_SmokeMap(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){

	}
	if(DecidingChaos("Chaos_SmokeMap")) return;
	Log("[Chaos] Running: Chaos_SmokeMap");

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			// vec[2] = vec[2] - 64;
			CreateParticle("explosion_smokegrenade_fallback", vec);
		}
	}
	AnnounceChaos("Smoke Strat", -1.0);
}

float g_InfiniteAmmo_Expire = 20.0;
Handle g_ChaosInfiniteAmmoTimer = INVALID_HANDLE;
Action Chaos_InfiniteAmmo(Handle timer = null, bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(ClearChaos(EndChaos)){
		cvar("sv_infinite_ammo", "0");
		StopTimer(g_ChaosInfiniteAmmoTimer);
		if(EndChaos) AnnounceChaos("Limited Ammo", -1.0, true);
	}
	if(DecidingChaos("Chaos_InfiniteAmmo")) return;
	g_InfiniteAmmo_Expire = GetChaosTime("Chaos_InfiniteAmmo", 20.0);
	Log("[Chaos] Running: Chaos_InfiniteAmmo");
	cvar("sv_infinite_ammo", "1");
	if(g_InfiniteAmmo_Expire > 0) g_ChaosInfiniteAmmoTimer = CreateTimer(g_InfiniteAmmo_Expire, Chaos_InfiniteAmmo, true);
	AnnounceChaos("Infinite Ammo", g_InfiniteAmmo_Expire);
}


void Chaos_DropCurrentWeapon(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
	
	}
	if(DecidingChaos("Chaos_DropCurrentWeapon")) return;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "drop");
		}
	}
	AnnounceChaos("Drop Current Weapon", -1.0);
}

void Chaos_DropPrimaryWeapon(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
	
	}
	if(DecidingChaos("Chaos_DropPrimaryWeapon")) return;
	Log("[Chaos] Running: Chaos_DropPrimaryWeapon");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "slot2;slot1; drop"); //todo drop their pisol if no primary available
		}
	}
	AnnounceChaos("Drop Primary Weapon", -1.0);
}


float g_Invis_Expire = 15.0;
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
	AnnounceChaos("Where did everyone go?", g_Invis_Expire);
	if(g_Invis_Expire > 0) g_Invis_Timer = CreateTimer(g_Invis_Expire, Chaos_Invis, true);
}




float DiscoPlayers_Duration = 30.0;
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
	DiscoPlayers_Duration = GetChaosTime("Chaos_DiscoPlayers", 30.0);
	Log("[Chaos] Running: Chaos_DiscoPlayers");
	// StopTimer(DiscoPlayers_TimerRepeat);
	delete DiscoPlayers_TimerRepeat;
	g_bDiscoPlayers = true;
	Timer_DiscoPlayers();
	if(DiscoPlayers_Duration > 0) DiscoPlayers_Timer = CreateTimer(DiscoPlayers_Duration, Chaos_DiscoPlayers, true);
	DiscoPlayers_TimerRepeat = CreateTimer(1.0, Timer_DiscoPlayers, _, TIMER_REPEAT);
	AnnounceChaos("Disco Players", DiscoPlayers_Duration);
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
	if(g_bClearChaos){

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
	if(g_bClearChaos){

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