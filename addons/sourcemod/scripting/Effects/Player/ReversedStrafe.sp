bool ReversedStrafe = false;
public void Chaos_ReversedStrafe(effect_data effect){
	effect.title = "Reversed Strafe";
	effect.duration = 30;
}

public void Chaos_ReversedStrafe_START(){
	ReversedStrafe = true;
}

public Action Chaos_ReversedStrafe_RESET(bool HasTimerEnded){
	ReversedStrafe = false;
}

public Action Chaos_ReversedStrafe_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(ReversedStrafe){
		fVel[1] = -fVel[1];
	}
}