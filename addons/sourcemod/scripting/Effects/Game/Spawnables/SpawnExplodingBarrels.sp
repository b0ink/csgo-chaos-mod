public void Chaos_SpawnExplodingBarrels(effect_data effect){
	effect.title = "Exploding Barrels";
	effect.HasNoDuration = true;
}

public void Chaos_SpawnExplodingBarrels_START(){
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec, sizeof(vec));
			if(DistanceToClosestPlayer(vec) > 50 && DistanceToClosestEntity(vec, "planted_c4") > 50){ //* Won't spawn on planted c4s
				int barrel = CreateEntityByName("prop_exploding_barrel");
				TeleportEntity(barrel, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(barrel);
			}
		}
	}
}