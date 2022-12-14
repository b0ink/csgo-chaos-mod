SETUP(effect_data effect){
	effect.Title = "Lil' Chooks";
	effect.AddAlias("Chicken");
	effect.Duration = 60;
	effect.AddFlag("chicken");
}

START(){
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
				DispatchKeyValue(ent, "targetname", "LittleChooks");
			}
		}
	
	}
}

RESET(bool HasTimerEnded){
	RemoveChickens(.chickenName="LittleChooks");
	g_bCanSpawnChickens = true;
}

CONDITIONS(){
	if(!g_bCanSpawnChickens) return false;
	return true;
}