bool AKeyStuck = false;

public void Chaos_KeyStuckA(effect_data effect){
	effect.Title = "Help my A key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_DisableStrafe");
	effect.IncompatibleWith("Chaos_KeyStuckD");
}

public void Chaos_KeyStuckA_START(){
	AKeyStuck = true;
}

public void Chaos_KeyStuckA_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(AKeyStuck) fVel[1] = -400.0;
}

public void Chaos_KeyStuckA_RESET(bool HasTimerEnded){
	AKeyStuck = false;
}