public void Chaos_ResetSpawns_START(){
	float zero_vector[3] = {0.0, 0.0, 0.0};
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			if(g_OriginalSpawnVec[i][0] != 0.0 && g_OriginalSpawnVec[i][1] != 0.0 && g_OriginalSpawnVec[i][2] != 0.0){
				TeleportEntity(i, g_OriginalSpawnVec[i], NULL_VECTOR, zero_vector);
			}
		}
	}
}

public Action Chaos_ResetSpawns_RESET(bool EndChaos){

}

public Action Chaos_ResetSpawns_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_ResetSpawns_HasNoDuration(){
	return true;
}

public bool Chaos_ResetSpawns_Conditions(){
	//todo
	return true;
}