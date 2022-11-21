public void Chaos_BreakTime(effect_data effect){
	effect.Title = "Take a Break";
	effect.Duration = 15;
	effect.IncompatibleWith("Chaos_WKeyStuck");
}


bool BreakTime = false;
//TODO: Re-apply effect when player respawns

public void Chaos_BreakTime_START(){
	BreakTime = true;
	HookBlockAllGuns();

	LoopAlivePlayers(i){
		FakeClientCommand(i, "use weapon_knife");
	}
}


public Action Chaos_BreakTime_RESET(bool HasTimerEnded){
	BreakTime = false;
	UnhookBlockAllGuns();
}

public Action Chaos_BreakTime_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(BreakTime){
		fVel[0] = 0.0;
		fVel[1] = 0.0;
	}
}

public bool Chaos_BreakTime_Conditions(){
	return true;
}