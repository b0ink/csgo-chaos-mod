//TODO: breaktime doesnt stop you from walking
bool WKeyStuck = false;

public void Chaos_WKeyStuck_START(){
	WKeyStuck = true;
}

public Action Chaos_WKeyStuck_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(WKeyStuck) fVel[0] = 400.0;
}

public void Chaos_WKeyStuck_RESET(bool HasTimerEnded){
	WKeyStuck = false;
}

public bool Chaos_WKeyStuck_Conditions(){
	return true;
}
