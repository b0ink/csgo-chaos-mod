public void Chaos_IsThisMexico_START(){
	Mexico();
}

public Action Chaos_IsThisMexico_RESET(bool HasTimerEnded){
	Mexico(true);
	// Fog_OFF();
}

// public Action Chaos_IsThisMexico_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_IsThisMexico_HasNoDuration(){
	return false;
}

public bool Chaos_IsThisMexico_Conditions(){
	return true;
}