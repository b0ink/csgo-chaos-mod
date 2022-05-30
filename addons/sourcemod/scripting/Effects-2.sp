Handle g_LSD_Timer = INVALID_HANDLE;
Handle g_LSD_Timer_Repeat = INVALID_HANDLE;
bool g_LSD = false;
int g_Previous_LSD = -1;
Action Chaos_LSD(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_LSD_Timer);
		StopTimer(g_LSD_Timer_Repeat);
		CLEAR_CC("env_1.raw");
		CLEAR_CC("env_2.raw");
		CLEAR_CC("env_3.raw");
		CLEAR_CC("env_4.raw");
		CLEAR_CC("env_5.raw");
		g_LSD = false;
		g_Previous_LSD = -1;
	}
	if(NotDecidingChaos("Chaos_LSD")) return;
	if(CurrentlyActive(g_LSD_Timer)) return;

	g_LSD = true;
	g_Previous_LSD = 1;
	CREATE_CC("env_1");

	g_LSD_Timer_Repeat = CreateTimer(5.0, Timer_SpawnNewLSD);

	float duration = GetChaosTime("Chaos_LSD", 30.0);
	if(duration > 0) g_LSD_Timer = CreateTimer(duration, Chaos_LSD, true);
	
	AnnounceChaos("LSD", duration);
}

public Action Timer_SpawnNewLSD(Handle Timer){
	g_LSD_Timer_Repeat = INVALID_HANDLE;

	CLEAR_CC("env_1.raw");
	CLEAR_CC("env_2.raw");
	CLEAR_CC("env_3.raw");
	CLEAR_CC("env_4.raw");
	CLEAR_CC("env_5.raw");
	
	if(g_LSD){
		int test = g_Previous_LSD;
		while(test == g_Previous_LSD) test = GetRandomInt(1,5);

		if(test == 1) CREATE_CC("env_1");
		if(test == 2) CREATE_CC("env_2");
		if(test == 3) CREATE_CC("env_3");
		if(test == 4) CREATE_CC("env_4");
		if(test == 5) CREATE_CC("env_5");
		g_LSD_Timer_Repeat = CreateTimer(5.0, Timer_SpawnNewLSD);
	}
}


Handle g_BlackWhite_Timer = INVALID_HANDLE;
Action Chaos_BlackWhite(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_BlackWhite_Timer);
		CLEAR_CC("blackandwhite.raw");
	}
	if(NotDecidingChaos("Chaos_BlackWhite.Blackandwhite")) return;
	if(CurrentlyActive(g_BlackWhite_Timer)) return;

	CREATE_CC("blackandwhite");
	float duration = GetChaosTime("Chaos_BlackWhite", 15.0);
	if(duration > 0) g_BlackWhite_Timer = CreateTimer(duration, Chaos_BlackWhite, true);
	
	AnnounceChaos("Black & White", duration);
}

Handle g_Saturation_Timer = INVALID_HANDLE;
Action Chaos_Saturation(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_Saturation_Timer);
		CLEAR_CC("saturation.raw");
	}
	if(NotDecidingChaos("Chaos_Saturation")) return;
	if(CurrentlyActive(g_Saturation_Timer)) return;

	CREATE_CC("saturation");

	float duration = GetChaosTime("Chaos_BlackWhite", 15.0);
	if(duration > 0) g_Saturation_Timer = CreateTimer(duration, Chaos_Saturation, true);
	
	AnnounceChaos("Saturation", duration);
}

void Chaos_RevealEnemyLocation(){
	if(ClearChaos()){

	}
	if(NotDecidingChaos("Chaos_RevealEnemyLocation")) return;
	ConVar radar = FindConVar("mp_radar_showall");

	if(radar.IntValue == 0){
		cvar("mp_radar_showall", "1");
		CreateTimer(0.2, Chaos_EnemyRadar, true); //use already made timer;
	}

	AnnounceChaos("Reveal Enemies Location", -1.0);
}

Handle g_HealthRegen_Timer = INVALID_HANDLE;
bool g_HealthRegen = false;
Action Chaos_HealthRegen(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_HealthRegen_Timer);
		g_HealthRegen = false;
	}
	if(NotDecidingChaos("Chaos_HealthRegen")) return;
	if(CurrentlyActive(g_HealthRegen_Timer)) return;

	g_HealthRegen = true;
	CreateTimer(1.0, Timer_GiveHealthRegen);

	float duration = GetChaosTime("Chaos_HealthRegen", 20.0);
	if(duration > 0) g_HealthRegen_Timer = CreateTimer(duration, Chaos_HealthRegen, true);
	
	AnnounceChaos("Health Regen", duration);
}

public Action Timer_GiveHealthRegen(Handle timer){
	if(g_HealthRegen){
		int currenthealth = -1;
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				currenthealth = GetClientHealth(i);
				SetEntityHealth(i, currenthealth + 10);
			}
		}
		CreateTimer(1.0, Timer_GiveHealthRegen);
	}
}


Handle g_Thunder_Timer = INVALID_HANDLE; 

Action Chaos_Thunderstorm(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_Thunder_Timer);
		int iMaxEnts = GetMaxEntities(); // clearing rain
		char sClassName[64];
		for(int i=MaxClients;i<iMaxEnts;i++){
			if(IsValidEntity(i) && 
			IsValidEdict(i) && 
			GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
			StrEqual(sClassName, "func_precipitation")){
				RemoveEntity(i);
			}
		}
	}
	if(NotDecidingChaos("Chaos_Thunderstorm.Lightning")) return;
	if(CurrentlyActive(g_Thunder_Timer)) return;

	CreateTimer(0.1, Timer_LightningStrike); // starting lightning strikes

	//SPAWN_WEATHER(PARTICLE_SNOW);

	SPAWN_WEATHER(RAIN);

	DispatchKeyValue(0, "skyname", "sky_csgo_cloudy01"); // changing the skybot to rain (unrelated to rain entity)

	float duration = GetChaosTime("Chaos_Thunderstorm", 20.0);
	if(duration > 0) g_Thunder_Timer = CreateTimer(duration, Chaos_Thunderstorm, true);

	AnnounceChaos(GetChaosTitle("Chaos_Thunderstorm"), duration);
	
}

public Action Timer_LightningStrike(Handle timer) {
	if (!g_Thunder_Timer) {
		return;
	}
	
	CreateTimer(0.1, Timer_LightningStrike);

	float endpos[3];
	GetArrayArray(g_MapCoordinates, GetRandomInt(0, GetArraySize(g_MapCoordinates) - 1), endpos);

	endpos[0]    = endpos[0] + GetRandomInt(-30, 30);
	endpos[1]    = endpos[1] + GetRandomInt(-30, 30);

	float startpos[3];
	startpos = endpos;

	startpos[2]    = startpos[2] + 1000;
	startpos[0]    = startpos[0] + GetRandomInt(-200, 200);
	startpos[1]    = startpos[1] + GetRandomInt(-200, 200);

	int   color[4] = { 255, 255, 255, 255 };

	TE_SetupBeamPoints(startpos, endpos, LIGHTNING_sprite, 0, 0, 0, 1.0 /*beam life*/, 20.0, 10.0, 20, 1.0, color, 0);
	TE_SendToAll();

	if(GetRandomInt(0, 100) <= 50) { // 50/50 chance for slay or superslay boom
		EmitAmbientSound(EXPLOSION_HE, endpos, SOUND_FROM_PLAYER, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.5); // regular slay from os but much more quiet
	} else {
		EmitAmbientSound(SOUND_SUPERSLAY, endpos, SOUND_FROM_PLAYER, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.5); // one singular superslay boom
	}

	float pos[3];
	for(int i = 0; i <= MaxClients; i++){ // dealing damage to player if they are struck
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, pos);
			if (GetVectorDistance(pos, endpos) < 200.0){
				SlapPlayer(i, 30, false);
			}
		}
	}
}

bool g_bForce_Reload[MAXPLAYERS+1];

public void Chaos_ForceReload(){
	if(ClearChaos()){
		for(int i = 0; i <= MaxClients; i++) g_bForce_Reload[i] = false;
	}
	if(NotDecidingChaos("Chaos_ForceReload")) return;
	
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) g_bForce_Reload[i] = true;

	AnnounceChaos(GetChaosTitle("Chaos_ForceReload"), -1.0);

}

bool g_bLoose_Trigger = false;
bool g_bLast_Shot [MAXPLAYERS+1];

Handle g_LooseTrigger_Timer = INVALID_HANDLE;

Action Chaos_LooseTrigger(Handle timer = null, bool EndChaos = false){
	if(ClearChaos(EndChaos)){
		StopTimer(g_LooseTrigger_Timer);
		g_bLoose_Trigger = false;
	}
	if(NotDecidingChaos("Chaos_LooseTrigger.forceshoot")) return;
	if(CurrentlyActive(g_LooseTrigger_Timer)) return;

	for(int i = 0; i <= MaxClients; i++)  g_bLast_Shot[i] = true;
	g_bLoose_Trigger = true;

	float duration = GetChaosTime("Chaos_LooseTrigger", 5.0);
	if(duration > 0) g_LooseTrigger_Timer = CreateTimer(duration, Chaos_LooseTrigger, true);

	AnnounceChaos(GetChaosTitle("Chaos_LooseTrigger"), duration);
	
}