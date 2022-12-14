#define EFFECTNAME MamaChook

SETUP(effect_data effect){
	effect.Title = "Mama Chook";
	effect.AddAlias("Chicken");
	effect.Duration = 60;
	effect.AddFlag("chicken");
}

START(){
	int randomIndex = GetRandomInt(0, GetArraySize(g_MapCoordinates) - 1);
	int ent = CreateEntityByName("chicken");
	if(ent != -1){
		float vec[3];
		GetArrayArray(g_MapCoordinates, randomIndex, vec);
		TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(ent, "targetname", "MamaChook");
		DispatchSpawn(ent);
		SetEntPropFloat(ent, Prop_Data, "m_flModelScale", 100.0);
	}
}

RESET(bool HasTimerEnded){
	RemoveChickens(.chickenName="MamaChook");
}