Handle g_RapidFire_Timer = INVALID_HANDLE;
bool g_bRapidFire = false;
float g_RapidFire_Rate = 0.7;
Action Chaos_RapidFire(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		ResetCvar("weapon_accuracy_nospread", "0", "1");
		ResetCvar("weapon_recoil_scale", "2", "0.2");
		g_bRapidFire = false;
		StopTimer(g_RapidFire_Timer);
		if(EndChaos) AnnounceChaos("Rapid Fire", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_RapidFire")) return;
	if(CurrentlyActive(g_RapidFire_Timer)) return; //will retry event in that function
	

	g_bRapidFire = true;
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0.5");

	float duration = GetChaosTime("Chaos_RapidFire", 25.0);
	if(duration > 0) g_RapidFire_Timer = CreateTimer(duration, Chaos_RapidFire, true);

	AnnounceChaos(GetChaosTitle("Chaos_RapidFire"), duration);
}


Handle FakeTeleport_Timer = INVALID_HANDLE;
float FakeTelport_loc[MAXPLAYERS+1][3];
void Chaos_FakeTeleport(){
	if(ClearChaos()){
		StopTimer(FakeTeleport_Timer);
	}
	if(NotDecidingChaos("Chaos_FakeTeleport")) return;
	if(CurrentlyActive(FakeTeleport_Timer)) return;

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
	AnnounceChaos(GetChaosTitle("Chaos_FakeTeleport"), -1.0);

	FakeTeleport_Timer = INVALID_HANDLE;
}

void Chaos_Soccerballs(){
	if(ClearChaos()){

	}
	if(NotDecidingChaos("Chaos_Soccerballs")) return;
	
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

	AnnounceChaos(GetChaosTitle("Chaos_Soccerballs"), -1.0);

}

Handle g_NoCrossHair_Timer = INVALID_HANDLE;
Action Chaos_NoCrosshair(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_NoCrossHair_Timer);
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
			}
		}
		if(EndChaos) AnnounceChaos("No Crosshair", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_NoCrosshair")) return;
	if(CurrentlyActive(g_NoCrossHair_Timer)) return;


	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
		}
	}

	float duration = GetChaosTime("Chaos_NoCrosshair", 25.0);
	if(duration > 0) g_NoCrossHair_Timer = CreateTimer(duration, Chaos_NoCrosshair, true);

	AnnounceChaos(GetChaosTitle("Chaos_NoCrosshair"), duration);

}

bool g_bLag = true;
void Chaos_FakeCrash(){
	if(ClearChaos()){    }
	if(NotDecidingChaos("Chaos_FakeCrash")) return;
	AnnounceChaos("Fake Crash", -1.0);
	g_sCustomEffect = "";
	g_sSelectedChaosEffect = "";
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
	if(ClearChaos(EndChaos)){
		ResetCvar("sv_disable_radar", "0", "1");
		StopTimer(g_DisableRadar_Timer);
	}
	if(NotDecidingChaos("Chaos_DisableRadar.NoRadar")) return;
	if(CurrentlyActive(g_DisableRadar_Timer)) return;

	cvar("sv_disable_radar", "1");
	
	float duration = GetChaosTime("Chaos_DisableRadar", 20.0);
	if(duration > 0) g_DisableRadar_Timer = CreateTimer(duration, Chaos_DisableRadar, true);

	AnnounceChaos(GetChaosTitle("Chaos_DisableRadar"), duration);

}

void Chaos_SpawnFlashbangs(){
	if(ClearChaos()){    }
	if(NotDecidingChaos("Chaos_SpawnFlashbangs")) return;

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

	AnnounceChaos(GetChaosTitle("Chaos_SpawnFlashbangs"), -1.0);

}

Handle g_SuperJump_Timer = INVALID_HANDLE;
Action Chaos_SuperJump(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		ResetCvar("sv_jump_impulse", "301", "590");
		StopTimer(g_SuperJump_Timer);
	}
	if(NotDecidingChaos("Chaos_SuperJump")) return;
	if(CurrentlyActive(g_SuperJump_Timer)) return;

	cvar("sv_jump_impulse", "590");
	
	float duration = GetChaosTime("Chaos_SuperJump", 20.0);
	if(duration > 0.0) g_SuperJump_Timer = CreateTimer(duration, Chaos_SuperJump, true);

	AnnounceChaos(GetChaosTitle("Chaos_SuperJump"), duration);

}


Handle g_Juggernaut_Timer = INVALID_HANDLE;
char g_OriginalModels_Jugg[MAXPLAYERS + 1][PLATFORM_MAX_PATH+1];
//https://forums.alliedmods.net/showthread.php?t=307674 thanks for prop_send 
bool g_bSetJuggernaut = false;
Action Chaos_Juggernaut(Handle timer = null, bool EndChaos = false){
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
		ResetCvar("mp_weapons_allow_heavyassaultsuit", "0", "1");
	}
	if(NotDecidingChaos("Chaos_Juggernaut")) return;
	if(CurrentlyActive(g_Juggernaut_Timer)) return;

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

	AnnounceChaos(GetChaosTitle("Chaos_Juggernaut"), duration);

}


void Chaos_SpawnExplodingBarrels(){
	if(ClearChaos()){    }
	if(NotDecidingChaos("Chaos_SpawnExplodingBarrels")) return;

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

	AnnounceChaos(GetChaosTitle("Chaos_SpawnExplodingBarrels"), -1.0);

}


Handle g_InsaneStrafe_Timer = INVALID_HANDLE;
Action Chaos_InsaneAirSpeed(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		ResetCvar("sv_air_max_wishspeed", "30", "2000");
		ResetCvar("sv_airaccelerate", "12", "2000");
		if(g_MaxAirAcc > 0) g_MaxAirAcc--;
		StopTimer(g_InsaneStrafe_Timer);
	}
	if(NotDecidingChaos("Chaos_InsaneAirSpeed.WishSpeed")) return;
	if(CurrentlyActive(g_InsaneStrafe_Timer)) return;
	
	cvar("sv_air_max_wishspeed", "2000");
	cvar("sv_airaccelerate", "2000");
	g_MaxAirAcc++;

	float duration = GetChaosTime("Chaos_InsaneAirSpeed", 20.0);
	if(duration > 0) g_InsaneStrafe_Timer = CreateTimer(duration, Chaos_InsaneAirSpeed, true);

	AnnounceChaos(GetChaosTitle("Chaos_InsaneAirSpeed"), duration);

}

void Chaos_RespawnDead_LastLocation(){
	if(ClearChaos()){    }
	if(NotDecidingChaos("Chaos_RespawnDead_LastLocation")) return;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			if(g_PlayerDeathLocations[i][0] != 0.0 && g_PlayerDeathLocations[i][1] != 0.0 && g_PlayerDeathLocations[i][2] != 0.0){ //safety net for any players that joined mid round
				TeleportEntity(i, g_PlayerDeathLocations[i], NULL_VECTOR, NULL_VECTOR);
			}
		}
	}
	AnnounceChaos(GetChaosTitle("Chaos_RespawnDead_LastLocation"), -1.0);

}

Handle g_Drugs_Timer = INVALID_HANDLE;
Action Chaos_Drugs(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		KillAllDrugs();
		StopTimer(g_Drugs_Timer);
	}
	if(NotDecidingChaos("Chaos_Drugs")) return;
	if(CurrentlyActive(g_Drugs_Timer)) return;

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) CreateDrug(i);

	float duration = GetChaosTime("Chaos_Drugs", 10.0);
	if(duration > 0) g_Drugs_Timer = CreateTimer(duration, Chaos_Drugs, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_Drugs"), duration);

}


Handle g_EnemyRadar_Timer = INVALID_HANDLE;
Action Chaos_EnemyRadar(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		ResetCvar("mp_radar_showall", "0", "1");
		StopTimer(g_EnemyRadar_Timer);
	}
	if(NotDecidingChaos("Chaos_EnemyRadar")) return;
	if(CurrentlyActive(g_EnemyRadar_Timer)) return;

	cvar("mp_radar_showall", "1");

	float duration = GetChaosTime("Chaos_EnemyRadar", 25.0);
	if(duration > 0) g_EnemyRadar_Timer = CreateTimer(duration, Chaos_EnemyRadar, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_EnemyRadar"), duration);

}

void Chaos_Give100HP(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_Give100HP")) return;
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			int currenthealth = GetClientHealth(i);
			SetEntityHealth(i, currenthealth + 100);
		}
	}

	AnnounceChaos(GetChaosTitle("Chaos_Give100HP"), -1.0);
}


void Chaos_HealAllPlayers(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_HealAllPlayers")) return;

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntityHealth(i, 100);
		}
	}
	
	AnnounceChaos(GetChaosTitle("Chaos_HealAllPlayers"), -1.0);

}

Handle g_BuyAnywhere_Timer = INVALID_HANDLE;
Action Chaos_BuyAnywhere(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		ResetCvar("mp_buy_anywhere", "0", "1");
		ResetCvar("mp_buytime", "20", "999");
		StopTimer(g_BuyAnywhere_Timer);
	}
	if(NotDecidingChaos("Chaos_BuyAnywhere")) return;
	if(CurrentlyActive(g_BuyAnywhere_Timer)) return;
	
	cvar("mp_buy_anywhere", "1");
	cvar("mp_buytime", "999");

	float duration = GetChaosTime("Chaos_BuyAnywhere", 20.0);
	if(duration > 0.0) g_BuyAnywhere_Timer = CreateTimer(duration, Chaos_BuyAnywhere, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_BuyAnywhere"), duration);
}

// float g_SimonSays_Duration = 10.0;
void Chaos_SimonSays(){
	if(ClearChaos()){
		g_bSimon_Active = false;
		KillMessageTimer();
	}
	if(NotDecidingChaos("Chaos_SimonSays")) return;
	if(CurrentlyActive(g_SimonSays_Timer)) return;

	// float duration = GetChaosTime("Chaos_SimonSays", 10.0);
	float duration = 10.0;
	GenerateSimonOrder(duration);
	StartMessageTimer();
	g_bSimon_Active = true;
}

Handle g_ExplosiveBullets_Timer = INVALID_HANDLE;
Action Chaos_ExplosiveBullets(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_ExplosiveBullets_Timer);
		g_bExplosiveBullets = false;
	}
	if(NotDecidingChaos("Chaos_ExplosiveBullets")) return;
	if(CurrentlyActive(g_ExplosiveBullets_Timer)) return;
	
	g_bExplosiveBullets = true;
	
	float duration = GetChaosTime("Chaos_ExplosiveBullets", 15.0);
	if(duration > 0) g_ExplosiveBullets_Timer = CreateTimer(duration, Chaos_ExplosiveBullets, true);

	AnnounceChaos(GetChaosTitle("Chaos_ExplosiveBullets"), duration);

}

bool g_bSpeedShooter = false;
Handle g_bSpeedShooter_Timer = INVALID_HANDLE;
//todo, if someone has speed once this ends, they still have speed
// > try saving their old speed but itll still be fucky
Action Chaos_SpeedShooter(Handle timer = null, bool EndChaos = false){
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
	if(NotDecidingChaos("Chaos_SpeedShooter")) return;
	if(CurrentlyActive(g_bSpeedShooter_Timer)) return;

	g_bSpeedShooter = true;

	float duration = GetChaosTime("Chaos_SpeedShooter", 10.0);
	if(duration > 0) g_bSpeedShooter_Timer = CreateTimer(duration, Chaos_SpeedShooter, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_SpeedShooter"), duration);

}

float zero_vector[3] = {0.0, 0.0, 0.0};
void Chaos_ResetSpawns(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_ResetSpawns")) return;

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			if(g_OriginalSpawnVec[i][0] != 0.0 && g_OriginalSpawnVec[i][1] != 0.0 && g_OriginalSpawnVec[i][2] != 0.0){
				TeleportEntity(i, g_OriginalSpawnVec[i], NULL_VECTOR, zero_vector);
			}
		}
	}
	
	AnnounceChaos(GetChaosTitle("Chaos_ResetSpawns"), -1.0);

}

int g_bNoStrafe = 0;
Handle g_NoStrafe_Timer = INVALID_HANDLE;
Action Chaos_DisableStrafe(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		if(g_bNoStrafe > 0) g_bNoStrafe--;
		StopTimer(g_NoStrafe_Timer);
		if(EndChaos) AnnounceChaos("Normal Left/Right Movement", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_DisableStrafe.NoLeftRight")) return;
	if(CurrentlyActive(g_NoStrafe_Timer)) return;
	
	g_bNoStrafe++;
	float duration = GetChaosTime("Chaos_DisableStrafe", 20.0);
	if(duration > 0.0) g_NoStrafe_Timer = CreateTimer(duration, Chaos_DisableStrafe, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_DisableStrafe"), duration);

}

int g_bNoForwardBack = 0;
Handle g_NoForwardBack_Timer = INVALID_HANDLE;
Action Chaos_DisableForwardBack(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		if(g_bNoForwardBack > 0) g_bNoForwardBack--;
		StopTimer(g_NoForwardBack_Timer);
		if(EndChaos) AnnounceChaos("Normal Forward/Backward Movement", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_DisableForwardBack")) return;
	if(CurrentlyActive(g_NoForwardBack_Timer)) return;
	
	g_bNoForwardBack++;
	
	float duration = GetChaosTime("Chaos_DisableForwardBack", 20.0);
	if(duration > 0) g_NoForwardBack_Timer = CreateTimer(duration, Chaos_DisableForwardBack, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_DisableForwardBack"), duration);

}

bool g_bJumping = false;
Handle g_Jumping_Timer_Repeat = INVALID_HANDLE;
Handle g_Jumping_Timer = INVALID_HANDLE;
Action Chaos_Jumping(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		g_bJumping = false;
		StopTimer(g_Jumping_Timer_Repeat);
		StopTimer(g_Jumping_Timer);
	}
	if(NotDecidingChaos("Chaos_Jumping")) return;
	if(CurrentlyActive(g_Jumping_Timer)) return;

	StopTimer(g_Jumping_Timer_Repeat);
	g_bJumping = true;
	
	float duration = GetChaosTime("Chaos_Jumping", 15.0);
	if(duration > 0) g_Jumping_Timer = CreateTimer(duration, Chaos_Jumping, true);
	g_Jumping_Timer_Repeat = CreateTimer(0.3, Timer_ForceJump, _, TIMER_REPEAT);
	
	AnnounceChaos(GetChaosTitle("Chaos_Jumping"), duration);

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
	if(ClearChaos(EndChaos)){
		StopTimer(g_DiscoFog_Timer_Repeat);
		StopTimer(g_DiscoFog_Timer);
		g_bDiscoFog = false;
		Fog_OFF();
	}
	if(NotDecidingChaos("Chaos_DiscoFog")) return;
	if(CurrentlyActive(g_DiscoFog_Timer)) return;

	DiscoFog();

	g_bDiscoFog = true;
	g_DiscoFog_Timer_Repeat = CreateTimer(1.0, Timer_NewFogColor, _,TIMER_REPEAT);

	float duration = GetChaosTime("Chaos_DiscoFog", 25.0);
	if(duration > 0) g_DiscoFog_Timer = CreateTimer(duration, Chaos_DiscoFog, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_DiscoFog"), duration);

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
	if(ClearChaos(EndChaos)){
		g_bOneBulletOneGun = false;
		StopTimer(g_OneBuilletOneGun_Timer);
		if(EndChaos) AnnounceChaos("One Bullet One Gun", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_OneBulletOneGun")) return;
	if(CurrentlyActive(g_OneBuilletOneGun_Timer)) return;

	g_bOneBulletOneGun = true; //handled somehwere in events.sp

	float duration = GetChaosTime("Chaos_OneBulletOneGun", 15.0);
	if(duration > 0) g_OneBuilletOneGun_Timer = CreateTimer(duration, Chaos_OneBulletOneGun, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_OneBulletOneGun"), duration);

}

float g_Earthquake_Duration = 7.0;
void Chaos_Earthquake(){
	if(ClearChaos()){    }
	if(NotDecidingChaos("Chaos_Earthquake")) return;

	g_Earthquake_Duration = GetChaosTime("Chaos_Earthquake", 5.0);
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ScreenShake(i, _, g_Earthquake_Duration);
		}
	}

	AnnounceChaos(GetChaosTitle("Chaos_Earthquake"), -1.0);

}


Handle g_ChickenPlayers_Timer = INVALID_HANDLE;
Action Chaos_ChickenPlayers(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_ChickenPlayers_Timer);
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) DisableChicken(i);
		}
	}
	if(NotDecidingChaos("Chaos_ChickenPlayers")) return;
	if(CurrentlyActive(g_ChickenPlayers_Timer)) return;

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetChicken(i);

	float duration = GetChaosTime("Chaos_ChickenPlayers", 20.0);
	if(duration > 0) g_ChickenPlayers_Timer = CreateTimer(duration, Chaos_ChickenPlayers, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_ChickenPlayers"), duration);

}


void Chaos_IgniteAllPlayers(){
	if(ClearChaos()){    }
	if(NotDecidingChaos("Chaos_IgniteAllPlayers")) return;

	// int randomchance = GetRandomInt(1,100);
	// if(randomchance <= 25 || forceAllPlayers){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			IgniteEntity(i, 10.0);
		}
	}
	AnnounceChaos(GetChaosTitle("Chaos_IgniteAllPlayers"), -1.0);

	// }
	// else{
	// 	int player = getRandomAlivePlayer();
	// 	if(player != -1 && ValidAndAlive(player)){
	// 		IgniteEntity(player, 10.0);
	// 		char msg[128];
	// 		FormatEx(msg, sizeof(msg), "Ignite {orange}%N", player);
	// 		AnnounceChaos(msg, -1.0);
	// 	}else{
	// 		Chaos_IgniteAllPlayers(true);
	// 	}
	// }
}

Handle g_LockPlayersAim_Timer = INVALID_HANDLE; //keeps track of when to end the event
bool g_bLockPlayersAim_Active = false;
float g_LockPlayersAim_Angles[MAXPLAYERS+1][3];
Action Chaos_LockPlayersAim(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		g_bLockPlayersAim_Active = false;
		StopTimer(g_LockPlayersAim_Timer);
		if(EndChaos) AnnounceChaos("Lock Mouse Movement", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_LockPlayersAim.LockMouseMovement")) return;
	if(CurrentlyActive(g_LockPlayersAim_Timer)) return;

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GetClientEyeAngles(i, g_LockPlayersAim_Angles[i]);

	g_bLockPlayersAim_Active  = true;

	float duration = GetChaosTime("Chaos_LockPlayersAim", 20.0);
	if(duration > 0) g_LockPlayersAim_Timer = CreateTimer(duration, Chaos_LockPlayersAim, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_LockPlayersAim"), duration);

}


Handle g_SlowSpeed_Timer = INVALID_HANDLE;
Action Chaos_SlowSpeed(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		if(EndChaos) {
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			AnnounceChaos("Normal Movement Speed", -1.0, true);
		}
		StopTimer(g_SlowSpeed_Timer);
	}
	if(NotDecidingChaos("Chaos_SlowSpeed")) return;
	if(CurrentlyActive(g_SlowSpeed_Timer)) return;

	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.5);

	float duration = GetChaosTime("Chaos_SlowSpeed", 20.0);
	if(duration > 0) g_SlowSpeed_Timer = CreateTimer(duration, Chaos_SlowSpeed, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_SlowSpeed"), duration);

}

Handle g_FastSpeed_Timer = INVALID_HANDLE;
Action Chaos_FastSpeed(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			AnnounceChaos("Normal Movement Speed", -1.0, true);
		}
		StopTimer(g_FastSpeed_Timer);
	}
	if(NotDecidingChaos("Chaos_FastSpeed")) return;
	if(CurrentlyActive(g_FastSpeed_Timer)) return;
	
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 3.0);

	float duration = GetChaosTime("Chaos_FastSpeed", 20.0);
	if(duration > 0) g_FastSpeed_Timer = CreateTimer(duration, Chaos_FastSpeed, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_FastSpeed"), duration);

}

void Chaos_RespawnTheDead(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_RespawnTheDead")) return;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)) CS_RespawnPlayer(i);
	}
	AnnounceChaos(GetChaosTitle("Chaos_RespawnTheDead"), -1.0);

}

void Chaos_RespawnTheDead_Randomly(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_RespawnTheDead_Randomly")) return;

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			DoRandomTeleport(i);
		}
	}

	AnnounceChaos(GetChaosTitle("Chaos_RespawnTheDead_Randomly"), -1.0);

}

void Chaos_Bumpmines(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_Bumpmines")) return;
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GivePlayerItem(i, "weapon_bumpmine");
	AnnounceChaos(GetChaosTitle("Chaos_Bumpmines"), -1.0);

}

Action Chaos_Spin180(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_Spin180.180Spin")) return;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float angs[3];
			GetClientEyeAngles(i, angs);
			angs[1] = angs[1] + 180;
			TeleportEntity(i, NULL_VECTOR, angs, NULL_VECTOR);
		}
	}
	AnnounceChaos(GetChaosTitle("Chaos_Spin180"), -1.0);

}

bool g_bPortalGuns = false;
Handle g_PortalGuns_Timer = INVALID_HANDLE;
Action Chaos_PortalGuns(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			TeleportPlayersToClosestLocation();
			AnnounceChaos("Portal Guns", -1.0, true);
		}
		g_bPortalGuns = false;
		StopTimer(g_PortalGuns_Timer);
	}
	if(NotDecidingChaos("Chaos_PortalGuns")) return;
	if(CurrentlyActive(g_PortalGuns_Timer)) return;
	
	g_bPortalGuns = true;
	SavePlayersLocations();

	float duration = GetChaosTime("Chaos_PortalGuns", 20.0);
	if(duration > 0) g_PortalGuns_Timer = CreateTimer(duration, Chaos_PortalGuns, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_PortalGuns"), duration);

}


void Chaos_TeleportFewMeters(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_TeleportFewMeters")) return;
	
	SavePlayersLocations();
	TeleportPlayersToClosestLocation(-1, 350); //250 units of minimum teleport distance
	AnnounceChaos("Teleport Players A Few Meters", -1.0);
}



Handle g_InfiniteGrenade_Timer = INVALID_HANDLE;
Action Chaos_InfiniteGrenades(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_InfiniteGrenade_Timer);
		ResetCvar("sv_infinite_ammo", "0", "2");
		if(EndChaos) AnnounceChaos("Infinite Grenades", -1.0,  true);
	}
	if(NotDecidingChaos("Chaos_InfiniteGrenades")) return;
	if(CurrentlyActive(g_InfiniteGrenade_Timer)) return;
	
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

	AnnounceChaos(GetChaosTitle("Chaos_InfiniteGrenades"), duration);

}

void Chaos_Shields(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_Shields")) return;
	char playerWeapon[62];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientWeapon(i, playerWeapon, sizeof(playerWeapon));
			int entity = CreateEntityByName("weapon_shield");
			if (entity > 0) {
				EquipPlayerWeapon(i, entity);
				SetEntPropEnt(i, Prop_Data, "m_hActiveWeapon" , entity);
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
	AnnounceChaos(GetChaosTitle("Chaos_Shields"), -1.0);

}


Handle g_IsThisMexico_Timer = INVALID_HANDLE;
Action Chaos_IsThisMexico(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		Fog_OFF();
		if(EndChaos) AnnounceChaos("Is This What Mexico Looks Like?", -1.0, true);
		StopTimer(g_IsThisMexico_Timer);
	}
	if(NotDecidingChaos("Chaos_IsThisMexico.IsThisWhatMexicoLooksLike")) return;
	if(CurrentlyActive(g_IsThisMexico_Timer)) return;
	
	Mexico();

	float duration = GetChaosTime("Chaos_IsThisMexico", 30.0);
	if(duration > 0) g_IsThisMexico_Timer = CreateTimer(duration, Chaos_IsThisMexico, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_IsThisMexico"), duration);

}

Handle g_OneWeaponOnly_Timer = INVALID_HANDLE;
Action Chaos_OneWeaponOnly(Handle timer = null, bool EndChaos = false){
	//todo; change chaos name, but its an event to pick a random weapon, and players are restricted to that weapon for the rest of the round.
	if(ClearChaos(EndChaos)){
		StopTimer(g_OneWeaponOnly_Timer);
		g_bPlayersCanDropWeapon = true;
		if(EndChaos) AnnounceChaos("Weapon Drop Re-enabled", -1.0,  true);
	}
	if(NotDecidingChaos("Chaos_OneWeaponOnly")) return;
	if(CurrentlyActive(g_OneWeaponOnly_Timer)) return;

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
	FormatEx(chaosMsg, sizeof(chaosMsg), "%s's Only", randomWeapon[7]); //strip weapon_ from name;
	// chaosMsg[0] = CharToUpper(chaosMsg[0]);

	float duration = GetChaosTime("Chaos_OneWeaponOnly", 30.0);
	if(duration > 0) g_OneWeaponOnly_Timer = CreateTimer(duration, Chaos_OneWeaponOnly, true);
	
	AnnounceChaos(chaosMsg, duration);
	//todo translation;
}

void Chaos_AutoPlantC4(){
	if(ClearChaos()){
		AutoPlantRoundEnd();
	}

	if(
		(g_PlantedSite != BOMBSITE_A) && (bombSiteB == INVALID_HANDLE) &&
		(g_PlantedSite != BOMBSITE_B) && (bombSiteA == INVALID_HANDLE) &&
		(g_PlantedSite != -1)
	){
		return;
	}

	if(NotDecidingChaos("Chaos_AutoPlantC4")) return;

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
		RetryEffect();
		return;
	}
	AutoPlantC4();
	CreateTimer(0.6, Timer_EnsureSpawnedAutoPlant);

}

public Action Timer_EnsureSpawnedAutoPlant(Handle timer){
	if(g_PlantedSite == BOMBSITE_A){
		AnnounceChaos(GetChaosTitle("Chaos_AutoPlantC4_A"), -1.0);
	}else if(g_PlantedSite == BOMBSITE_B){
		AnnounceChaos(GetChaosTitle("Chaos_AutoPlantC4_B"), -1.0);
	}else{
		AnnounceChaos(GetChaosTitle("Chaos_AutoPlantC4"), -1.0);
	}
}

public void Chaos_Impostors(){
	//not to be confused with players into chickesn..
	if(ClearChaos()){
		RemoveChickens();
	}
	if(NotDecidingChaos("Chaos_Impostors")) return;

	SpawnImpostors();

	AnnounceChaos(GetChaosTitle("Chaos_Impostors"), -1.0);
}

public void Chaos_MamaChook(){
	if(ClearChaos()){
		RemoveChickens();
	}
	if(NotDecidingChaos("Chaos_MamaChook")) return;

	int randomIndex = GetRandomInt(0, GetArraySize(g_MapCoordinates) - 1);
	int ent = CreateEntityByName("chicken");
	if(ent != -1){
		float vec[3];
		GetArrayArray(g_MapCoordinates, randomIndex, vec);
		TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(ent);
		SetEntPropFloat(ent, Prop_Data, "m_flModelScale", 100.0);
	}
	
	AnnounceChaos(GetChaosTitle("Chaos_MamaChook"), -1.0);

}

public void Chaos_BigChooks(){
	if(ClearChaos()){
		RemoveChickens();
		g_bCanSpawnChickens = true;
	}
	if(NotDecidingChaos("Chaos_BigChooks")) return;

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
	AnnounceChaos(GetChaosTitle("Chaos_BigChooks"), -1.0);

}

public void Chaos_LittleChooks(){
	if(ClearChaos()){
		RemoveChickens();
		g_bCanSpawnChickens = true;

	}
	if(NotDecidingChaos("Chaos_LittleChooks")) return;

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
	AnnounceChaos(GetChaosTitle("Chaos_LittleChooks"), -1.0);

}


bool g_bOneBulletMag = false;
Handle g_OneBulletMag_Timer = INVALID_HANDLE;
Action Chaos_OneBulletMag(Handle timer = null, bool EndChaos = false){
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
	if(NotDecidingChaos("Chaos_OneBulletMag")) return;
	if(CurrentlyActive(g_OneBulletMag_Timer)) return;


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
	
	AnnounceChaos(GetChaosTitle("Chaos_OneBulletMag"), duration);

}

Handle g_CrabPeople_Timer = INVALID_HANDLE;
bool g_bForceCrouch = false;
Action Chaos_CrabPeople(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		g_bForceCrouch = false;
		StopTimer(g_CrabPeople_Timer);
		if(EndChaos) AnnounceChaos("Crab People", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_CrabPeople")) return;
	if(CurrentlyActive(g_CrabPeople_Timer)) return;

	g_bForceCrouch = true;
	
	float duration = GetChaosTime("Chaos_CrabPeople", 15.0);
	if(duration > 0) g_CrabPeople_Timer = CreateTimer(duration, Chaos_CrabPeople, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_CrabPeople"), duration);

}

bool g_bNoscopeOnly = false;
Handle g_NoscopeOnly_Timer = INVALID_HANDLE;
Action Chaos_NoScopeOnly(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_NoscopeOnly_Timer);
		g_bNoscopeOnly = false;
		if(EndChaos) AnnounceChaos("You can now scope again", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_NoScopeOnly.NoScopesOnly")) return;
	if(CurrentlyActive(g_NoscopeOnly_Timer)) return;

	g_bNoscopeOnly = true;

	float duration = GetChaosTime("Chaos_NoScopeOnly", 20.0);
	if(duration > 0) g_NoscopeOnly_Timer = CreateTimer(duration, Chaos_NoScopeOnly, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_NoScopeOnly"), duration);

}

void Chaos_MoneyRain(){
	if(ClearChaos()){ ResetCvar("sv_dz_cash_bundle_size", "50", "500"); }
	if(NotDecidingChaos("Chaos_MoneyRain.FreeCash.SpawnCash.item_cash")) return;

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
	AnnounceChaos(GetChaosTitle("Chaos_MoneyRain"), -1.0);

}

bool g_bVampireRound = false;
Handle g_Vampire_Timer = INVALID_HANDLE;
Action Chaos_VampireHeal(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_Vampire_Timer);
		g_bVampireRound = false;
		if(EndChaos) AnnounceChaos("Vampires", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_VampireHeal.Vampires")) return;
	if(CurrentlyActive(g_Vampire_Timer)) return;

	g_bVampireRound = true;

	float duration = GetChaosTime("Chaos_VampireHeal", 30.0);
	if(duration > 0) g_Vampire_Timer = CreateTimer(duration, Chaos_VampireHeal, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_VampireHeal"), duration);

}


void Chaos_C4Chicken(){
	if(ClearChaos()){
		g_bC4Chicken = false;
		RemoveChickens();
		g_iC4ChickenEnt = -1;
	}
	if(NotDecidingChaos("Chaos_C4Chicken")) return;

	g_bC4Chicken = true;
	C4Chicken(); //convert any planted c4's to chicken
	AnnounceChaos(GetChaosTitle("Chaos_C4Chicken"), -1.0);

}

//tood; buggy if you still have other nades?
bool g_bDecoyDodgeball = false;
Handle g_DecoyDodgeball_Timer = INVALID_HANDLE;
Handle g_DecoyDodgeball_CheckDecoyTimer = INVALID_HANDLE;
Action Chaos_DecoyDodgeball(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		if(g_bDecoyDodgeball && EndChaos){
			for(int i = 0; i <= MaxClients; i++){
				if(ValidAndAlive(i)){
					StripPlayer(i, true, true, true); //strip grenades only
					SetEntityHealth(i, 100);
					if(!HasMenuOpen(i)){
						ClientCommand(i, "slot2");
						ClientCommand(i, "slot1");
					}
					// FakeClientCommand(i, "use weapon_knife");
				}
			}
		}
		g_bDecoyDodgeball = false;
		StopTimer(g_DecoyDodgeball_Timer);
		delete g_DecoyDodgeball_CheckDecoyTimer;

	}
	if(NotDecidingChaos("Chaos_DecoyDodgeball")) return;
	if(CurrentlyActive(g_DecoyDodgeball_Timer)) return;

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

	AnnounceChaos(GetChaosTitle("Chaos_DecoyDodgeball"), duration);
	
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
	if(ClearChaos(EndChaos)){
		StopTimer(g_bHeadshotOnly_Timer);
		ResetCvar("mp_damage_headshot_only", "0", "1");
	}
	if(NotDecidingChaos("Chaos_HeadshotOnly.HeadshotsOnly")) return;
	if(CurrentlyActive(g_bHeadshotOnly_Timer)) return;

	cvar("mp_damage_headshot_only", "1");
	
	float duration = GetChaosTime("Chaos_HeadshotOnly", 20.0);
	if(duration > 0) g_bHeadshotOnly_Timer = CreateTimer(duration, Chaos_HeadshotOnly, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_HeadshotOnly"), duration);

}

Handle g_ohko_Timer = INVALID_HANDLE;
Action Chaos_OHKO(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 100);
			AnnounceChaos("1 HP", -1.0, true);
		}
		StopTimer(g_ohko_Timer);
	}
	if(NotDecidingChaos("Chaos_OHKO")) return;
	if(CurrentlyActive(g_ohko_Timer)) return;
	
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 1);
	
	float duration = GetChaosTime("Chaos_OHKO", 15.0);
	if(duration > 0) g_ohko_Timer = CreateTimer(duration, Chaos_OHKO, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_OHKO"), duration);

}

Handle g_InsaneGravityTimer = INVALID_HANDLE;
int g_NoFallDamage = 0;
Action Chaos_InsaneGravity(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){	
		StopTimer(g_InsaneGravityTimer);
		SetPlayersGravity(1.0);
		if(g_NoFallDamage > 0) g_NoFallDamage--;
		if(EndChaos) AnnounceChaos("Insane Gravity", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_InsaneGravity")) return;
	if(CurrentlyActive(g_InsaneGravityTimer)) return;

	SetPlayersGravity(15.0);
	g_NoFallDamage++;
	
	float duration = GetChaosTime("Chaos_InsaneGravity", 20.0);
	if(duration > 0) g_InsaneGravityTimer = CreateTimer(duration, Chaos_InsaneGravity, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_InsaneGravity"), duration);

}

void Chaos_Nothing(){
	if(NotDecidingChaos("Chaos_Nothing")) return;
	AnnounceChaos("Nothing", -1.0);
}

Handle g_IceySurface_Timer = INVALID_HANDLE;
Action Chaos_IceySurface(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_IceySurface_Timer);
		ResetCvar("sv_friction", "5.2", "0");
		if(EndChaos) AnnounceChaos("Icey Ground", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_IceySurface.IceyGround.IcyGround")) return;
	if(CurrentlyActive(g_IceySurface_Timer)) return;

	cvar("sv_friction", "0");
	
	float duration = GetChaosTime("Chaos_IceySurface", 20.0);
	if(duration > 0) g_IceySurface_Timer = CreateTimer(duration, Chaos_IceySurface, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_IceySurface"), duration);

}

Handle Chaos_RandomSlap_Timer = INVALID_HANDLE;
float g_Chaos_RandomSlap_Interval = 7.0;
Handle g_RandomSlapDuration_Timer = INVALID_HANDLE;
Action Chaos_RandomSlap(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(Chaos_RandomSlap_Timer);
		StopTimer(g_RandomSlapDuration_Timer);
		// cvar("sv_falldamage_scale", "1");
		if(g_NoFallDamage > 0) g_NoFallDamage--;
		if(EndChaos) AnnounceChaos("Ghost Slaps", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_RandomSlap.GhostSlaps")) return;
	if(CurrentlyActive(g_RandomSlapDuration_Timer)) return;

	// cvar("sv_falldamage_scale", "0");
	g_NoFallDamage++;
	Chaos_RandomSlap_Timer = CreateTimer(g_Chaos_RandomSlap_Interval, Timer_RandomSlap, _,TIMER_REPEAT);
	
	float duration = GetChaosTime("Chaos_RandomSlap", 30.0);
	if(duration > 0) g_RandomSlapDuration_Timer = CreateTimer(duration, Chaos_RandomSlap, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_RandomSlap"), duration);

}

float g_maxRange = 750.0;
float g_minRange = -750.0;
Action Timer_RandomSlap(Handle timer){
	//play sound? or do ghost slaps make no noise at all? { o.o }
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
	if(ClearChaos(EndChaos)){
		ResetCvar("mp_taser_recharge_time", "-1", "0.5");
		ResetCvar("sv_party_mode", "0", "1");
		g_bTaserRound = false;
		StopTimer(g_TaserParty_Timer);
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i) && !HasMenuOpen(i)) ClientCommand(i, "slot2;slot1");
			AnnounceChaos("Taser Party", -1.0, true);
		}
	}
	if(NotDecidingChaos("Chaos_TaserParty")) return;
	if(CurrentlyActive(g_TaserParty_Timer)) return;

	g_bTaserRound = true;
	cvar("mp_taser_recharge_time", "0.5");
	cvar("sv_party_mode", "1");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GivePlayerItem(i, "weapon_taser");
			FakeClientCommand(i, "use weapon_taser");
		}
	}

	float duration = GetChaosTime("Chaos_TaserParty", 10.0);
	if(duration > 0) g_TaserParty_Timer = CreateTimer(duration, Chaos_TaserParty, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_TaserParty"), duration);

}

int g_bKnifeFight = 0;
Handle g_KnifeFight_Timer = INVALID_HANDLE;
Action Chaos_KnifeFight(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_KnifeFight_Timer);
		if(g_bKnifeFight > 0) g_bKnifeFight--;
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i) && !HasMenuOpen(i)) ClientCommand(i, "slot1");
			AnnounceChaos("Knife Fight", -1.0, true);
		}
	}
	if(NotDecidingChaos("Chaos_KnifeFight")) return;
	if(CurrentlyActive(g_KnifeFight_Timer)) return;

	g_bKnifeFight++;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			FakeClientCommand(i, "use weapon_knife");
		}
	}
	
	float duration = GetChaosTime("Chaos_KnifeFight", 15.0);
	if(duration > 0) g_KnifeFight_Timer = CreateTimer(duration, Chaos_KnifeFight, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_KnifeFight"), duration);

}

Handle g_Funky_Timer = INVALID_HANDLE;
int g_AutoBunnyhop = 0;
Action Chaos_Funky(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		// cvar("sv_enablebunnyhopping", "0");
		// cvar("sv_autobunnyhopping", "0");
		if(g_AutoBunnyhop > 0) g_AutoBunnyhop--;
		ResetCvar("sv_airaccelerate", "12", "1999");
		StopTimer(g_Funky_Timer);
		if(g_MaxAirAcc > 0) g_MaxAirAcc--;
		if(EndChaos) AnnounceChaos("No more {orchid}funky{default}?", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_Funky.AutoBhop.Bhop")) return;
	if(CurrentlyActive(g_Funky_Timer)) return;

	g_AutoBunnyhop++;
	g_MaxAirAcc++;
	cvar("sv_airaccelerate", "1999");
	// cvar("sv_enablebunnyhopping", "1");
	// cvar("sv_autobunnyhopping", "1");

	float duration = GetChaosTime("Chaos_Funky", 30.0);
	if(duration > 0) g_Funky_Timer = CreateTimer(duration, Chaos_Funky, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_Funky"), duration);

}

// bool g_bRandomWeaponRound = false;
Handle g_RandWep_Timer = INVALID_HANDLE;
float g_fRandomWeapons_Interval = 5.0; //5+ recommended for bomb plants
Action Chaos_RandomWeapons(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		g_bPlayersCanDropWeapon = true;
		StopTimer(g_RandomWeapons_Timer_Repeat);
		StopTimer(g_RandWep_Timer);
	}
	if(NotDecidingChaos("Chaos_RandomWeapons")) return;
	if(CurrentlyActive(g_RandWep_Timer)) return;

	StopTimer(g_RandomWeapons_Timer_Repeat);
	g_bPlayersCanDropWeapon = false;
	Timer_GiveRandomWeapon();
	g_RandomWeapons_Timer_Repeat = CreateTimer(g_fRandomWeapons_Interval, Timer_GiveRandomWeapon, _, TIMER_REPEAT);

	float duration = GetChaosTime("Chaos_RandomWeapons", 30.0);
	if(duration > 0) g_RandWep_Timer = CreateTimer(duration, Chaos_RandomWeapons, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_RandomWeapons"), duration);

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
	if(ClearChaos(EndChaos)){
		StopTimer(g_MoonGravity_Timer);
		SetPlayersGravity(1.0);
		if(EndChaos) AnnounceChaos("Moon Gravity", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_MoonGravity")) return;
	if(CurrentlyActive(g_MoonGravity_Timer)) return;

	//TODO fluctuating gravity thoughout the round?

	SetPlayersGravity(0.6);

	float duration = GetChaosTime("Chaos_MoonGravity", 30.0);
	if(duration > 0) g_MoonGravity_Timer = CreateTimer(duration, Chaos_MoonGravity, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_MoonGravity"), duration);

}


//TODO use the map coordinates to make it look like cool raining in another effect
Handle Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
float g_RandomMolotovSpawn_Interval = 5.0; //5+ recommended for bomb plants
int g_MolotovSpawn_Count = 0;
public void Chaos_RandomMolotovSpawn(){
	if(ClearChaos()){
		ResetCvar("inferno_flame_lifetime", "7", "4");
		StopTimer(Chaos_MolotovSpawn_Timer);
	}		
	if(NotDecidingChaos("Chaos_RandomMolotovSpawn.RainingFire")) return;
	if(CurrentlyActive(Chaos_MolotovSpawn_Timer)) return;

	g_MolotovSpawn_Count = 0;
	cvar("inferno_flame_lifetime", "4");
	
	Chaos_MolotovSpawn_Timer = CreateTimer(g_RandomMolotovSpawn_Interval, Timer_SpawnMolotov, _, TIMER_REPEAT);

	AnnounceChaos(GetChaosTitle("Chaos_RandomMolotovSpawn"), 25.0);

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
	if(ClearChaos(EndChaos)){	
		StopTimer(g_ESP_Timer);
		ResetCvar("sv_force_transmit_players", "0", "1");
		destroyGlows();
		if(EndChaos) AnnounceChaos("Wall Hacks", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_ESP.WallHacks")) return;
	if(CurrentlyActive(g_ESP_Timer)) return;

	cvar("sv_force_transmit_players", "1");
	createGlows();
	
	float duration = GetChaosTime("Chaos_ESP", 30.0);
	if(duration > 0) g_ESP_Timer = CreateTimer(duration, Chaos_ESP, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_ESP"), duration);

}


Handle TPos = INVALID_HANDLE;
Handle CTPos = INVALID_HANDLE;
Handle tIndex = INVALID_HANDLE;
Handle ctIndex = INVALID_HANDLE;

public void TEAMMATESWAP_INIT(){
	if(TPos == INVALID_HANDLE) TPos = CreateArray(3);
	if(CTPos == INVALID_HANDLE) CTPos = CreateArray(3);
	if(tIndex == INVALID_HANDLE) tIndex = CreateArray(1);
	if(ctIndex == INVALID_HANDLE) ctIndex = CreateArray(1);
}

void Chaos_TeammateSwap(){
	if(ClearChaos()){		}
	if(NotDecidingChaos("Chaos_TeammateSwap")) return;

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

	AnnounceChaos(GetChaosTitle("Chaos_TeammateSwap"), -1.0);

}

//Allows nowclippers to take damage
bool g_bActiveNoclip = false;
Handle g_ResetNoclipTimer = INVALID_HANDLE;

Action Chaos_Flying(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		if(EndChaos){
			for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityMoveType(i, MOVETYPE_WALK);
			TeleportPlayersToClosestLocation();
			AnnounceChaos("Flying", -1.0, true);
		}
		ResetCvar("sv_noclipspeed", "5", "2");
		g_bActiveNoclip = false;	
		StopTimer(g_ResetNoclipTimer);
	}
	if(NotDecidingChaos("Chaos_Flying.Noclip")) return;
	if(CurrentlyActive(g_ResetNoclipTimer)) return;

	g_bActiveNoclip = true;	
	SavePlayersLocations();
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityMoveType(i, MOVETYPE_NOCLIP);
	cvar("sv_noclipspeed", "2");

	float duration = GetChaosTime("Chaos_Flying", 10.0);
	if(duration > 0) g_ResetNoclipTimer = CreateTimer(duration, Chaos_Flying, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_Flying"), duration);

}

void Chaos_RandomTeleport(){
	if(ClearChaos()){		}
	if(NotDecidingChaos("Chaos_RandomTeleport")) return;
	DoRandomTeleport();
	AnnounceChaos(GetChaosTitle("Chaos_RandomTeleport"), -1.0);

}

void Chaos_LavaFloor(){
	if(ClearChaos()){		}
	if(NotDecidingChaos("Chaos_LavaFloor.FloorIsLava")) return;

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
	
	AnnounceChaos(GetChaosTitle("Chaos_LavaFloor"), -1.0);

}

Handle g_Quake_Timer = INVALID_HANDLE;
Action Chaos_QuakeFOV(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){	
		StopTimer(g_Quake_Timer);
		ResetPlayersFOV();
	}
	if(NotDecidingChaos("Chaos_QuakeFOV")) return;
	if(CurrentlyActive(g_Quake_Timer)) return;
	
	int RandomFOV = GetRandomInt(110,160);
	SetPlayersFOV(RandomFOV);

	float duration = GetChaosTime("Chaos_QuakeFOV", 25.0);
	if(duration > 0) g_Quake_Timer = CreateTimer(duration, Chaos_QuakeFOV, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_QuakeFOV"), duration);

}

Handle g_Binoculars_Timer = INVALID_HANDLE;
Action Chaos_Binoculars(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){	
		StopTimer(g_Binoculars_Timer);
		ResetPlayersFOV();
		Remove_Overlay("/Chaos/binoculars.vtf");
	}
	if(NotDecidingChaos("Chaos_Binoculars")) return;
	if(CurrentlyActive(g_Binoculars_Timer)) return;

	int RandomFOV = GetRandomInt(20,50);
	SetPlayersFOV(RandomFOV);

	Add_Overlay("/Chaos/binoculars.vtf");

	float duration = GetChaosTime("Chaos_Binoculars", 25.0);
	if(duration > 0) g_Binoculars_Timer = CreateTimer(duration, Chaos_Binoculars, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_Binoculars"), duration);

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
	if(ClearChaos(EndChaos)){	
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				PerformBlind(i, 0);
			}
		}
		StopTimer(g_BlindPlayers_Timer);
	}
	if(NotDecidingChaos("Chaos_BlindPlayers")) return;
	if(CurrentlyActive(g_BlindPlayers_Timer)) return;

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)) PerformBlind(i, 255);
	}

	float duration = GetChaosTime("Chaos_BlindPlayers", 7.0);
	g_BlindPlayers_Timer = CreateTimer(duration, Chaos_BlindPlayers, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_BlindPlayers"), duration);
}

Handle g_Aimbot_Timer = INVALID_HANDLE;
Action Chaos_Aimbot(Handle timer = null, bool EndChaos = false){
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
	if(NotDecidingChaos("Chaos_Aimbot")) return;
	if(CurrentlyActive(g_Aimbot_Timer)) return;

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			Aimbot_SDKHOOKS(i);
			ToggleAim(i, true);
		}
	}

	float duration = GetChaosTime("Chaos_Aimbot", 30.0);
	if(duration > 0) g_Aimbot_Timer = CreateTimer(duration, Chaos_Aimbot, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_Aimbot"), duration);
}

Handle g_NoSpread_Timer = INVALID_HANDLE;
Action Chaos_NoSpread(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){	
		StopTimer(g_NoSpread_Timer);
		ResetCvar("weapon_accuracy_nospread", "0", "1");
		ResetCvar("weapon_recoil_scale", "2", "0");
		if(EndChaos) AnnounceChaos("100\% Weapon Accuracy", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_NoSpread.100\%WeaponAccuracy")) return;
	if(CurrentlyActive(g_NoSpread_Timer)) return;
	
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");

	float duration = GetChaosTime("Chaos_NoSpread", 25.0);
	if(duration > 0) g_NoSpread_Timer = CreateTimer(duration, Chaos_NoSpread, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_NoSpread"), duration);

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
	if(ClearChaos(EndChaos)){	
		StopTimer(g_IncRecoil_Timer);
		ResetCvar("weapon_recoil_scale", "2", "10");
		if(EndChaos) AnnounceChaos("Increased Recoil", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_IncreasedRecoil")) return;
	if(CurrentlyActive(g_IncRecoil_Timer)) return;

	cvar("weapon_recoil_scale", "10");

	float duration = GetChaosTime("Chaos_IncreasedRecoil", 25.0);
	if(duration > 0) g_IncRecoil_Timer = CreateTimer(duration, Chaos_IncreasedRecoil, true);

	AnnounceChaos(GetChaosTitle("Chaos_IncreasedRecoil"), duration);

}

Handle g_ReverseRecoil_Timer = INVALID_HANDLE;
Action Chaos_ReversedRecoil(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){	
		StopTimer(g_ReverseRecoil_Timer);
		ResetCvar("weapon_recoil_scale", "2", "-5");
		if(EndChaos) AnnounceChaos("Reversed Recoil", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_ReversedRecoil")) return;
	if(CurrentlyActive(g_ReverseRecoil_Timer)) return;

	cvar("weapon_recoil_scale", "-5");

	float duration = GetChaosTime("Chaos_ReversedRecoil", 25.0);
	if(duration > 0) g_ReverseRecoil_Timer = CreateTimer(duration, Chaos_ReversedRecoil, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_ReversedRecoil"), duration);

}

void Chaos_Jackpot(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_Jackpot")) return;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			EmitSoundToClient(i, SOUND_MONEY, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
			SetClientMoney(i, 16000);
		}
	}

	AnnounceChaos(GetChaosTitle("Chaos_Jackpot"), -1.0);

}

void Chaos_Bankrupt(){
	if(ClearChaos()){}
	if(NotDecidingChaos("Chaos_Bankrupt")) return;
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetClientMoney(i, 0, true);
	AnnounceChaos(GetChaosTitle("Chaos_Bankrupt"), -1.0);

}

//TODO: chnage to a giverandomplayer function so i can ignite random player or something
void Chaos_SlayRandomPlayer(){
	if(ClearChaos()){}
	if(NotDecidingChaos("Chaos_SlayRandomPlayer")) return;

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

	AnnounceChaos(GetChaosTitle("Chaos_SlayRandomPlayer"), -1.0);

}


void Chaos_Healthshot(){
	if(NotDecidingChaos("Chaos_Healthshot")) return;
	int amount = GetRandomInt(1,3);
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			for(int j = 1; j <= amount; j++){
				GivePlayerItem(i, "weapon_healthshot");
			}
		}
	}
	AnnounceChaos(GetChaosTitle("Chaos_Healthshot"), -1.0);

}

Handle g_AlienKnifeFightTimer = INVALID_HANDLE;
Action Chaos_AlienModelKnife(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_AlienKnifeFightTimer);
		if(g_bKnifeFight > 0) g_bKnifeFight--;
		// if(EndChaos){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				if(!HasMenuOpen(i)) ClientCommand(i, "slot1");
				SetEntPropFloat(i, Prop_Send, "m_flModelScale", 1.0);
				SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0);
				SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			}
		}	
		// }
		if(EndChaos) AnnounceChaos("Alien Knife Fight", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_AlienModelKnife.AlienKnifeFight")) return;
	if(CurrentlyActive(g_AlienKnifeFightTimer)) return;


	//hitboxes are tiny, but knives work fine
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntPropFloat(i, Prop_Send, "m_flModelScale", 0.5);
			// SetEntProp(i, Prop_Send, "m_ScaleType", 5); //TODO EXPERIEMNT WITH
			SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0*0.55);
		}
	}

	g_bKnifeFight++;
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 2.0);
			FakeClientCommand(i, "use weapon_knife");
		}
	}

	float duration = GetChaosTime("Chaos_AlienModelKnife", 15.0);
	if(duration > 0) g_AlienKnifeFightTimer = CreateTimer(duration, Chaos_AlienModelKnife, true);

	AnnounceChaos(GetChaosTitle("Chaos_AlienModelKnife"), duration);

}

Handle g_LightsOff_Timer = INVALID_HANDLE;
Action Chaos_LightsOff(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_LightsOff_Timer);
		Fog_OFF();
	}
	if(NotDecidingChaos("Chaos_LightsOff.Dark.NightTime")) return;
	if(CurrentlyActive(g_LightsOff_Timer)) return;

	LightsOff();
	
	float duration = GetChaosTime("Chaos_LightsOff", 30.0);
	if(duration  > 0) g_LightsOff_Timer = CreateTimer(duration, Chaos_LightsOff, true);
	//Random chance for night vision? or separate chaos

	AnnounceChaos(GetChaosTitle("Chaos_LightsOff"), duration);

}


//todo make timed
void Chaos_NightVision(){
	if(ClearChaos()){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
			}
		}
	}
	if(NotDecidingChaos("Chaos_NightVision")) return;
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GivePlayerItem(i, "item_nvgs");
			FakeClientCommand(i, "nightvision");
		}
	}

	AnnounceChaos(GetChaosTitle("Chaos_NightVision"), -1.0);

}


Handle g_NormalWhiteFog_Timer = INVALID_HANDLE;
Action Chaos_NormalWhiteFog(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_NormalWhiteFog_Timer);
		AcceptEntityInput(g_iFog, "TurnOff");
	}
	if(NotDecidingChaos("Chaos_NormalWhiteFog.NormalFog")) return;
	if(CurrentlyActive(g_NormalWhiteFog_Timer)) return;

	NormalWhiteFog();

	float duration = GetChaosTime("Chaos_NormalWhiteFog", 45.0);
	if(duration > 0) g_NormalWhiteFog_Timer = CreateTimer(duration, Chaos_NormalWhiteFog, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_NormalWhiteFog"), duration);

}

Handle g_ExtremeWhiteFog_Timer = INVALID_HANDLE;
Action Chaos_ExtremeWhiteFog(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		Fog_OFF();
		StopTimer(g_ExtremeWhiteFog_Timer);
	}
	if(NotDecidingChaos("Chaos_ExtremeWhiteFog.ExtremeFog")) return;
	if(CurrentlyActive(g_ExtremeWhiteFog_Timer)) return;

	ExtremeWhiteFog();
	float duration = GetChaosTime("Chaos_NormalWhiteFog", 45.0);
	if(duration > 0) g_ExtremeWhiteFog_Timer = CreateTimer(duration, Chaos_ExtremeWhiteFog, true);

	AnnounceChaos(GetChaosTitle("Chaos_ExtremeWhiteFog"), duration);

}


void Chaos_RandomSkybox(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_RandomSkybox")) return;

	int randomSkyboxIndex = GetRandomInt(0, sizeof(g_sSkyboxes)-1);
	DispatchKeyValue(0, "skyname", g_sSkyboxes[randomSkyboxIndex]);
	
	AnnounceChaos(GetChaosTitle("Chaos_RandomSkybox"), -1.0);

}

Handle g_LowRender_Timer = INVALID_HANDLE;
Action Chaos_LowRenderDistance(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_LowRender_Timer);
		ResetRenderDistance();
	}
	if(NotDecidingChaos("Chaos_LowRenderDistance")) return;
	if(CurrentlyActive(g_LowRender_Timer)) return;

	LowRenderDistance();
	
	float duration = GetChaosTime("Chaos_LowRenderDistance", 30.0);
	if(duration > 0 ) g_LowRender_Timer = CreateTimer(duration, Chaos_LowRenderDistance, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_LowRenderDistance"), duration);

}


Handle g_Thirdperson_Timer = INVALID_HANDLE;
Action Chaos_Thirdperson(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) ClientCommand(i, "firstperson");
		ResetCvar("sv_allow_thirdperson", "0", "1");
		StopTimer(g_Thirdperson_Timer);
		if(EndChaos) AnnounceChaos("Firstperson", -1.0);
	}
	if(NotDecidingChaos("Chaos_Thirdperson")) return;
	if(CurrentlyActive(g_Thirdperson_Timer)) return;

	cvar("sv_allow_thirdperson", "1");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)) ClientCommand(i, "thirdperson");
	}
	
	float duration = GetChaosTime("Chaos_Thirdperson", 15.0);
	if(duration > 0) g_Thirdperson_Timer = CreateTimer(duration, Chaos_Thirdperson, true);

	AnnounceChaos(GetChaosTitle("Chaos_Thirdperson"), duration);

}

void Chaos_SmokeMap(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_SmokeMap")) return;

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			CreateParticle("explosion_smokegrenade_fallback", vec);
		}
	}
	AnnounceChaos(GetChaosTitle("Chaos_SmokeMap"), -1.0);

}

Handle g_InfiniteAmmo_Timer = INVALID_HANDLE;
bool g_InfiniteAmmo = false;
Action Chaos_InfiniteAmmo(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_InfiniteAmmo_Timer);
		g_InfiniteAmmo = false;
		if(EndChaos) AnnounceChaos("Limited Ammo", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_InfiniteAmmo")) return;
	if(CurrentlyActive(g_InfiniteAmmo_Timer)) return;

	g_InfiniteAmmo = true;
	
	float duration = GetChaosTime("Chaos_InfiniteAmmo", 20.0);
	if(duration > 0) g_InfiniteAmmo_Timer = CreateTimer(duration, Chaos_InfiniteAmmo, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_InfiniteAmmo"), duration);
}


void Chaos_DropCurrentWeapon(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_DropCurrentWeapon")) return;

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "drop");
		}
	}
	AnnounceChaos(GetChaosTitle("Chaos_DropCurrentWeapon"), -1.0);

}

void Chaos_DropPrimaryWeapon(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_DropPrimaryWeapon")) return;

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i) && !HasMenuOpen(i)){
			ClientCommand(i, "slot2;slot1");
		}
	}
	CreateTimer(0.1, Timer_DropPrimary);
	AnnounceChaos(GetChaosTitle("Chaos_DropPrimaryWeapon"), -1.0);

}
public Action Timer_DropPrimary(Handle timer){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "drop");
		}
	}
}


Handle g_Invis_Timer = INVALID_HANDLE;

Action Chaos_Invis(Handle timer = null, bool EndChaos = false){
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
	if(NotDecidingChaos("Chaos_Invis")) return;
	if(CurrentlyActive(g_Invis_Timer)) return;

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
	
	AnnounceChaos(GetChaosTitle("Chaos_Invis"), duration);

}


Handle DiscoPlayers_Timer = INVALID_HANDLE;
Handle DiscoPlayers_TimerRepeat = INVALID_HANDLE;
bool g_bDiscoPlayers = false;
Action Chaos_DiscoPlayers(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		g_bDiscoPlayers = true;
		StopTimer(DiscoPlayers_Timer);
		StopTimer(DiscoPlayers_TimerRepeat);
		if(EndChaos) AnnounceChaos("Disco Players", -1.0, true);
	}
	if(NotDecidingChaos("Chaos_DiscoPlayers")) return;
	if(CurrentlyActive(DiscoPlayers_Timer)) return;

	g_bDiscoPlayers = true;
	Timer_DiscoPlayers();

	float duration = GetChaosTime("Chaos_DiscoPlayers", 30.0);
	if(duration > 0) DiscoPlayers_Timer = CreateTimer(duration, Chaos_DiscoPlayers, true);
	DiscoPlayers_TimerRepeat = CreateTimer(1.0, Timer_DiscoPlayers, _, TIMER_REPEAT);

	AnnounceChaos(GetChaosTitle("Chaos_DiscoPlayers"), duration);

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
	if(ClearChaos()){	}

	Handle players_array = CreateArray(4);
	int playerCount = -1;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)) PushArrayCell(players_array, i);
	}
	playerCount = GetArraySize(players_array);
	if(playerCount <= 1) {
		delete players_array;
		return;
	}
	
	
	if(NotDecidingChaos("Chaos_RandomInvisiblePlayer")) return;
	
	int target_index = GetRandomInt(0, playerCount - 1);
	int target = GetArrayCell(players_array, target_index);

	SetEntityRenderMode(target, RENDER_TRANSCOLOR);
	SetEntityRenderColor(target, 255, 255, 255, 0);

	char chaosMsg[MAX_NAME_LENGTH];
	FormatEx(chaosMsg, 	sizeof(chaosMsg), "%N", target);
	Format(chaosMsg, 	sizeof(chaosMsg), "%s...", Truncate(chaosMsg, 10));
	Format(chaosMsg, 	sizeof(chaosMsg), "{orange}%s {default}has been made invisible", chaosMsg);
	AnnounceChaos(chaosMsg, -1.0);
	//todo translation

	delete players_array;
}

Handle g_BreakTime_Timer = INVALID_HANDLE;

Action Chaos_BreakTime(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_BreakTime_Timer);
		if(g_bKnifeFight > 0) g_bKnifeFight--;
		if(g_bNoForwardBack > 0) g_bNoForwardBack--;
		if(g_bNoStrafe > 0) g_bNoStrafe--;
		if(EndChaos) AnnounceChaos("Break Over", -1.0,  true);
	}
	if(NotDecidingChaos("Chaos_BreakTime")) return;
	if(CurrentlyActive(g_BreakTime_Timer)) return;
	
	g_bKnifeFight++;
	g_bNoForwardBack++;
	g_bNoStrafe++;

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			FakeClientCommand(i, "use weapon_knife");
		}
	}
	
	float duration = GetChaosTime("Chaos_BreakTime", 10.0);
	if(duration > 0) g_BreakTime_Timer = CreateTimer(duration, Chaos_BreakTime, true);
	
	AnnounceChaos(GetChaosTitle("Chaos_BreakTime"), duration);

}

public void Chaos_MEGACHAOS(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_MEGACHAOS")) return;
	
	g_bMegaChaos = true; 

	AnnounceChaos(GetChaosTitle("Chaos_MEGACHAOS"), -1.0, true, true);

	g_bDisableRetryEffect = false;
	CreateTimer(0.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.5, Timer_CompleteMegaChaos);
}

public Action Timer_CompleteMegaChaos(Handle timer){
	AnnounceChaos(GetChaosTitle("Chaos_MEGACHAOS"), -1.0);
	g_bMegaChaos = false;
}
