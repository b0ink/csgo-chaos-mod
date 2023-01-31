#pragma semicolon 1

public void Chaos_LavaFloor(effect_data effect){
	effect.Title = "FLOOR IS LAVA";
	effect.HasNoDuration = true;
}

public void Chaos_LavaFloor_START(){
	for(int i = 0; i <=  GetArraySize(g_MapCoordinates)-1; i++){
		int spawnChance = GetRandomInt(0,100);
		if(spawnChance <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			// vec[2] = vec[2]; //anything bigger and things like vents or ct spawn will spawn molotov in other areas of the map
			int ent = CreateEntityByName("molotov_projectile");
			TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(ent);
			AcceptEntityInput(ent, "InitializeSpawnFromWorld"); 
		}
	}
}

public bool Chaos_LavaFloor_Conditions(bool EffectRunRandomly){
	if(g_iChaosRoundTime < 10 && EffectRunRandomly) return false;
	return true;
}