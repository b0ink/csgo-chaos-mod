bool ReversedStrafe = false;

public void Chaos_ReversedStrafe_START(){
	ReversedStrafe = true;
}

public Action Chaos_ReversedStrafe_RESET(bool EndChaos){
	ReversedStrafe = false;
}

public Action Chaos_ReversedStrafe_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(ReversedStrafe){
		fVel[1] = -fVel[1];
		// fVel[0] = -fVel[0];
	}
}