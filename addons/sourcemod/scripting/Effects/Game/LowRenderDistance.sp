public void Chaos_LowRenderDistance_START(){
	LowRenderDistance();
}

public Action Chaos_LowRenderDistance_RESET(bool HasTimerEnded){
	ResetRenderDistance();
}

// public Action Chaos_LowRenderDistance_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_LowRenderDistance_HasNoDuration(){
	return false;
}

public bool Chaos_LowRenderDistance_Conditions(){
	return true;
}