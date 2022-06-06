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

public Action Chaos_MamaChook_RESET(bool EndChaos){
	RemoveChickens();
}

public Action Chaos_MamaChook_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_MamaChook_HasNoDuration(){
	return false;
}

public bool Chaos_MamaChook_Conditions(){
	return true;
}