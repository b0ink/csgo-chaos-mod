public void Chaos_SlayRandomPlayer_START(){
	int aliveCT = GetAliveCTCount();
	int aliveT = GetAliveTCount();
	int RandomTSlay = GetRandomInt(1, aliveT);
	int RandomCTSlay = GetRandomInt(1, aliveCT);

	if(aliveT > 1){
		aliveT = 0;
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				if(GetClientTeam(i) == CS_TEAM_T){
					aliveT++;
					if(aliveT == RandomTSlay){
						ForcePlayerSuicide(i);
					}
				}
			}
		}
	}
	if(aliveCT > 1){
		aliveCT = 0;
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				if(GetClientTeam(i) == CS_TEAM_CT){
					aliveCT++;
					if(aliveCT == RandomCTSlay){
						if(aliveCT){
							ForcePlayerSuicide(i);
						}
					}
				}
			}
		}
	}
}

public Action Chaos_SlayRandomPlayer_RESET(bool EndChaos){

}

public Action Chaos_SlayRandomPlayer_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_SlayRandomPlayer_HasNoDuration(){
	return true;
}

public bool Chaos_SlayRandomPlayer_Conditions(){
	return true;
}