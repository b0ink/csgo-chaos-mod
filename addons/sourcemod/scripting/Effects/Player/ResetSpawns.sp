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

public bool Chaos_ResetSpawns_HasNoDuration(){
	return true;
}

public bool Chaos_ResetSpawns_Conditions(){
	if(g_iChaos_Round_Time <= 25) return false;
	return true;
}