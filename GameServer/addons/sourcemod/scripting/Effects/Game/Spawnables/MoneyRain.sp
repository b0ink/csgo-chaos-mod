#define EFFECTNAME MoneyRain

SETUP(effect_data effect){
	effect.Title = "Make it Rain";
	effect.HasNoDuration = true;
}


START(){
	cvar("sv_dz_cash_bundle_size", "500");

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		float vec[3];
		GetArrayArray(g_MapCoordinates, i, vec);
		vec[2] = vec[2] + GetRandomInt(50, 200);
		SpawnItemCash(vec);
	}

}

void SpawnItemCash(float vec[3]){
	int ent = CreateEntityByName("item_cash");
	
	if(ent == -1) return;

	vec[2] = vec[2] + GetRandomInt(50, 200);
	float rotation[3];
	rotation[0] = GetRandomFloat(0.0, 360.0);
	rotation[1] = GetRandomFloat(0.0, 360.0);
	rotation[2] = GetRandomFloat(0.0, 360.0);

	TeleportEntity(ent, vec, rotation, NULL_VECTOR);
	DispatchSpawn(ent);
}


RESET(bool HasTimerEnded){
	ResetCvar("sv_dz_cash_bundle_size", "50", "500");
}

CONDITIONS(){
	if(g_MapCoordinates == INVALID_HANDLE) return false;
	if(GetArraySize(g_MapCoordinates) == 0) return false;
	return true;
}