public void Chaos_LittleChooks(effect_data effect){
	effect.title = "Lil' Chooks";
	effect.HasNoDuration = true;
}

public void Chaos_LittleChooks_START(){
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
}

public Action Chaos_LittleChooks_RESET(bool HasTimerEnded){
	RemoveChickens();
	g_bCanSpawnChickens = true;
}

public bool Chaos_LittleChooks_Conditions(){
	if(!g_bCanSpawnChickens) return false;
	return true;
}