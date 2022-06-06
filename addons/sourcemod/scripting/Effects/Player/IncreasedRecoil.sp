public void Chaos_IncreasedRecoil_START(){
	cvar("weapon_recoil_scale", "10");
}

public Action Chaos_IncreasedRecoil_RESET(bool EndChaos){
	ResetCvar("weapon_recoil_scale", "2", "10");
}

public Action Chaos_IncreasedRecoil_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_IncreasedRecoil_HasNoDuration(){
	return false;
}

public bool Chaos_IncreasedRecoil_Conditions(){
	return true;
}