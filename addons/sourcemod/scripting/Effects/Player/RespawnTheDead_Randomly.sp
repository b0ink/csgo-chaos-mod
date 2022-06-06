public void Chaos_RespawnTheDead_Randomly_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			DoRandomTeleport(i);
		}
	}
}

public Action Chaos_RespawnTheDead_Randomly_RESET(bool EndChaos){

}

public Action Chaos_RespawnTheDead_Randomly_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_RespawnTheDead_Randomly_HasNoDuration(){
	return false;
}

public bool Chaos_RespawnTheDead_Randomly_Conditions(){
	return true;
}