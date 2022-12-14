#define EFFECTNAME SpawnExplodingBarrels

SETUP(effect_data effect){
	effect.Title = "Exploding Barrels";
	effect.Duration = 60;
}

START(){
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec, sizeof(vec));
			if(DistanceToClosestPlayer(vec) > 50 && DistanceToClosestEntity(vec, "planted_c4") > 50){ //* Won't spawn on planted c4s
				int barrel = CreateEntityByName("prop_exploding_barrel");
				DispatchKeyValue(barrel, "targetname", "ExplodingBarrel");
				TeleportEntity(barrel, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(barrel);
			}
		}
	}
}

RESET(bool HasTimerEnded){
	char classname[64];
	char targetname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		if(StrEqual(classname, "prop_exploding_barrel") && GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == -1){
			GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
			if(StrEqual(targetname, "ExplodingBarrel", false)){
				RemoveEntity(ent);
			}else{
				continue;
			}	
		}
	}
}