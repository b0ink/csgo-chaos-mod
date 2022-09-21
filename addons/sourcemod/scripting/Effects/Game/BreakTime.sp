public void Chaos_BreakTime(effect_data effect){
	effect.title = "Take a Break";
	effect.duration = 15;
	effect.IncompatibleWith("Chaos_WKeyStuck");
}


bool BreakTime = false;
public void Chaos_BreakTime_START(){
	BreakTime = true;
	LoopAlivePlayers(i){
		FakeClientCommand(i, "use weapon_knife");
	}
}


public Action Chaos_BreakTime_RESET(bool HasTimerEnded){
	BreakTime = false;
	if(g_bKnifeFight > 0) g_bKnifeFight--;
	if(g_bNoForwardBack > 0) g_bNoForwardBack--;
	if(g_bNoStrafe > 0) g_bNoStrafe--;
}

public Action Chaos_BreakTime_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(BreakTime){
		fVel[0] = 0.0;
		fVel[1] = 0.0;
	}
}


public bool Chaos_BreakTime_HasNoDuration(){
	return false;
}

public bool Chaos_BreakTime_Conditions(){
	return true;
}