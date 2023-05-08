#pragma semicolon 1

ArrayList barrels;
public void Chaos_SpawnExplodingBarrels(EffectData effect){
	effect.Title = "Exploding Barrels";
	effect.Duration = 60;

	barrels = new ArrayList();
}

public void Chaos_SpawnExplodingBarrels_START(){
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec, sizeof(vec));
			if(IsCoopStrike() && DistanceToClosestPlayer(vec) > MAX_COOP_SPAWNDIST) continue;
			if(DistanceToClosestPlayer(vec) > 50 && DistanceToClosestEntity(vec, "planted_c4") > 50){ //* Won't spawn on planted c4s
				int barrel = CreateEntityByName("prop_exploding_barrel");
				DispatchKeyValue(barrel, "targetname", "ExplodingBarrel");
				TeleportEntity(barrel, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(barrel);
				barrels.Push(EntIndexToEntRef(barrel));
			}
		}
	}
}

public void Chaos_SpawnExplodingBarrels_RESET(){
	RemoveEntitiesInArray(barrels);
}

public bool Chaos_SpawnExplodingBarrels_Conditions(bool EffectRunRandomly){
	if(!ValidMapPoints()) return false;
	return true;
}