public void Chaos_RespawnTheDead_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)) if(GetClientTeam(i) == CS_TEAM_CT || GetClientTeam(i) == CS_TEAM_T) CS_RespawnPlayer(i);
	}
}

public Action Chaos_RespawnTheDead_RESET(bool EndChaos){

}

// public Action Chaos_RespawnTheDead_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_RespawnTheDead_HasNoDuration(){
	return true;
}

public bool Chaos_RespawnTheDead_Conditions(){
	if(g_iChaos_Round_Time <= 30) return false;
	return true;
}