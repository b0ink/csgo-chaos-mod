bool WKeyStuck = false;

SETUP(effect_data effect){
	effect.Title = "Help my W key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
}


START(){
	WKeyStuck = true;
}

public Action Chaos_WKeyStuck_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(WKeyStuck) fVel[0] = 400.0;
}

RESET(bool HasTimerEnded){
	WKeyStuck = false;
}

CONDITIONS(){
	return true;
}
