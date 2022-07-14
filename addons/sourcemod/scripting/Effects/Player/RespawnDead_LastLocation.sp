public void Chaos_RespawnDead_LastLocation_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)){
			if(GetClientTeam(i) == CS_TEAM_CT || GetClientTeam(i) == CS_TEAM_T){
				CS_RespawnPlayer(i);
				if(g_PlayerDeathLocations[i][0] != 0.0 && g_PlayerDeathLocations[i][1] != 0.0 && g_PlayerDeathLocations[i][2] != 0.0){ //safety net for any players that joined mid round
					TeleportEntity(i, g_PlayerDeathLocations[i], NULL_VECTOR, NULL_VECTOR);
				}
			}
		}
	}
}

public Action Chaos_RespawnDead_LastLocation_RESET(bool EndChaos){

}

// public Action Chaos_RespawnDead_LastLocation_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_RespawnDead_LastLocation_HasNoDuration(){
	return true;
}

public bool Chaos_RespawnDead_LastLocation_Conditions(){
	if(g_iChaos_Round_Time <= 30) return false;
	return true;
}