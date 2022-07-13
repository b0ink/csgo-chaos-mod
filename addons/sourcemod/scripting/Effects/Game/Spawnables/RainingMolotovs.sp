Handle Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
float g_RandomMolotovSpawn_Interval = 5.0; //5+ recommended for bomb plants
int g_MolotovSpawn_Count = 0;
public void Chaos_RainingMolotovs_START(){
	g_MolotovSpawn_Count = 0;
	cvar("inferno_flame_lifetime", "4");
	
	Chaos_MolotovSpawn_Timer = CreateTimer(g_RandomMolotovSpawn_Interval, Timer_SpawnMolotov, _, TIMER_REPEAT);
}
//TODO: use the map coordinates to make it look like cool raining in another effect

public Action Chaos_RainingMolotovs_RESET(bool EndChaos){
		StopTimer(Chaos_MolotovSpawn_Timer);
		ResetCvar("inferno_flame_lifetime", "7", "4");

}

public Action Chaos_RainingMolotovs_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_RainingMolotovs_HasNoDuration(){
	return false;
}

public bool Chaos_RainingMolotovs_Conditions(){
	return true;
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
			//TODO: offset x and z
			int ent = CreateEntityByName("molotov_projectile");
			TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(ent);
			AcceptEntityInput(ent, "InitializeSpawnFromWorld"); 
		}
	}
}
