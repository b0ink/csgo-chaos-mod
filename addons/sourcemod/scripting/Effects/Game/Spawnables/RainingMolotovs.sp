float g_RandomMolotovSpawn_Interval = 5.0; //5+ recommended for bomb plants

int g_MolotovSpawn_Count = 0;

public void Chaos_RainingMolotovs(effect_data effect){
	effect.Title = "Raining Fire";
	effect.Duration = 30;

}

public void Chaos_RainingMolotovs_START(){
	g_MolotovSpawn_Count = 0;
	CreateTimer(g_RandomMolotovSpawn_Interval, Timer_SpawnMolotov, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public void Chaos_RainingMolotovs_RESET(bool HasTimerEnded){
	g_MolotovSpawn_Count = 100; // Stop spawning any more
}

public Action Timer_SpawnMolotov(Handle timer){
	if(g_MolotovSpawn_Count > 5){ 
		g_MolotovSpawn_Count = 0;
		return Plugin_Stop;
	}

	g_MolotovSpawn_Count++;

	float vec[3];
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, vec);
		vec[2] = vec[2] + 100; //anything bigger and things like vents or ct spawn will spawn molotov in other areas of the map
		int ent = CreateEntityByName("molotov_projectile");
		if(ent == -1) continue;
		TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(ent);
		AcceptEntityInput(ent, "InitializeSpawnFromWorld"); 
	}
	return Plugin_Continue;
}
