#pragma semicolon 1

public void Chaos_MoneyRain(EffectData effect){
	effect.Title = "Make it Rain";
	effect.HasNoDuration = true;
}


public void Chaos_MoneyRain_START(){
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


public void Chaos_MoneyRain_RESET(int ResetType){
	ResetCvar("sv_dz_cash_bundle_size", "50", "500");
}

public bool Chaos_MoneyRain_Conditions(bool EffectRunRandomly){
	if(!ValidMapPoints()) return false;
	if(GetArraySize(g_MapCoordinates) == 0) return false;
	return true;
}