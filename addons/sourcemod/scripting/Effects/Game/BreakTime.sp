public void Chaos_BreakTime_START(){
	g_bKnifeFight++;
	g_bNoForwardBack++;
	g_bNoStrafe++;

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			FakeClientCommand(i, "use weapon_knife");
		}
	}
	//todo switch to knife
}

public Action Chaos_BreakTime_RESET(bool EndChaos){
	if(g_bKnifeFight > 0) g_bKnifeFight--;
	if(g_bNoForwardBack > 0) g_bNoForwardBack--;
	if(g_bNoStrafe > 0) g_bNoStrafe--;
}

public Action Chaos_BreakTime_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_BreakTime_HasNoDuration(){
	return false;
}

public bool Chaos_BreakTime_Conditions(){
	return true;
}