public void Chaos_Saturation_START(){
	CREATE_CC("saturation");
}

public Action Chaos_Saturation_RESET(bool EndChaos){
	CLEAR_CC("saturation.raw");
}

public Action Chaos_Saturation_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_Saturation_HasNoDuration(){
	return false;
}

public bool Chaos_Saturation_Conditions(){
	
	return true;
}