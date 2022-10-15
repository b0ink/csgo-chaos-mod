public void Chaos_RainingMolotovs(effect_data effect){
	effect.Title = "Raining Fire";
	effect.Duration = 30;
}


Handle Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
float g_RandomMolotovSpawn_Interval = 5.0; //5+ recommended for bomb plants
int g_MolotovSpawn_Count = 0;
public void Chaos_RainingMolotovs_START(){
	g_MolotovSpawn_Count = 0;
	cvar("inferno_flame_lifetime", "4");
	
	Chaos_MolotovSpawn_Timer = CreateTimer(g_RandomMolotovSpawn_Interval, Timer_SpawnMolotov, _, TIMER_REPEAT);
}
//TODO: use the map coordinates to make it look like cool raining in another effect

public Action Chaos_RainingMolotovs_RESET(bool HasTimerEnded){
		StopTimer(Chaos_MolotovSpawn_Timer);
		ResetCvar("inferno_flame_lifetime", "7", "4");
}


public Action Timer_SpawnMolotov(Handle timer){
	if(g_MolotovSpawn_Count > 5){ 
		g_MolotovSpawn_Count = 0;
		StopTimer(Chaos_MolotovSpawn_Timer);
		Chaos_MolotovSpawn_Timer = INVALID_HANDLE;
		// AnnounceChaos("Raining Fire Ended", -1.0, true);
		return;
	}
	g_MolotovSpawn_Count++;
	float vec[3];
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, vec);
		vec[2] = vec[2] + 100; //anything bigger and things like vents or ct spawn will spawn molotov in other areas of the map
		int ent = CreateEntityByName("molotov_projectile");
		TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(ent);
		AcceptEntityInput(ent, "InitializeSpawnFromWorld"); 
	}
}
