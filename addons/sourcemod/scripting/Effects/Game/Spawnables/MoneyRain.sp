public void Chaos_MoneyRain(effect_data effect){
	effect.title = "Make it Rain";
	effect.HasNoDuration = true;
}

public void Chaos_MoneyRain_START(){
	cvar("sv_dz_cash_bundle_size", "500");
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int ent = CreateEntityByName("item_cash");
		if(ent != -1){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			vec[2] = vec[2] + GetRandomInt(50, 200);
			//TODO:; randomise the rotation of the cash for extra bounce?
			TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(ent);
		}
	}
}

public Action Chaos_MoneyRain_RESET(bool HasTimerEnded){
	ResetCvar("sv_dz_cash_bundle_size", "50", "500");
}