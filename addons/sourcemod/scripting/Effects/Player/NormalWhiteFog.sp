public void Chaos_NormalWhiteFog_START(){
	NormalWhiteFog();
}

public Action Chaos_NormalWhiteFog_RESET(bool HasTimerEnded){
	NormalWhiteFog(true);
	// Fog_OFF();
}

// public Action Chaos_NormalWhiteFog_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_NormalWhiteFog_HasNoDuration(){
	return false;
}

public bool Chaos_NormalWhiteFog_Conditions(){
	return true;
}