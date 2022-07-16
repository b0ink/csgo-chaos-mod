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

public Action Chaos_MoneyRain_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_MoneyRain_HasNoDuration(){
	return true;
}

public bool Chaos_MoneyRain_Conditions(){
	return true;
}