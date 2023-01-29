#pragma semicolon 1

bool DKeyStuck = false;

public void Chaos_KeyStuckD(effect_data effect){
	effect.Title = "Help my D key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_DisableStrafe");
	effect.IncompatibleWith("Chaos_KeyStuckA");
}


public void Chaos_KeyStuckD_START(){
	DKeyStuck = true;
}

public void Chaos_KeyStuckD_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(DKeyStuck) fVel[1] = 400.0;
}

public void Chaos_KeyStuckD_RESET(bool HasTimerEnded){
	DKeyStuck = false;
}