public void Chaos_MamaChook(effect_data effect){
	effect.Title = "Mama Chook";
	effect.AddAlias("Chicken");
	effect.HasNoDuration = true;
}

public void Chaos_MamaChook_START(){
	int randomIndex = GetRandomInt(0, GetArraySize(g_MapCoordinates) - 1);
	int ent = CreateEntityByName("chicken");
	if(ent != -1){
		float vec[3];
		GetArrayArray(g_MapCoordinates, randomIndex, vec);
		TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(ent);
		SetEntPropFloat(ent, Prop_Data, "m_flModelScale", 100.0);
	}
}

public Action Chaos_MamaChook_RESET(bool HasTimerEnded){
	RemoveChickens();
}