bool BreakTime = false;


public void Chaos_BreakTime(effect_data effect){
	effect.Title = "Take a Break";
	effect.Duration = 15;
	effect.IncompatibleWith("Chaos_KeyStuckA");
	effect.IncompatibleWith("Chaos_KeyStuckD");
	effect.IncompatibleWith("Chaos_KeyStuckS");
	effect.IncompatibleWith("Chaos_KeyStuckW");
	effect.AddFlag("movement");
}

public void Chaos_BreakTime_START(){
	BreakTime = true;
	HookBlockAllGuns();

	LoopAlivePlayers(i){
		FakeClientCommand(i, "use weapon_knife");
	}
}

public void Chaos_BreakTime_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(!BreakTime) return;

	HookBlockAllGuns(client);
	FakeClientCommand(client, "use weapon_knife");
}


public void Chaos_BreakTime_RESET(bool HasTimerEnded){
	BreakTime = false;
	UnhookBlockAllGuns();
}

public void Chaos_BreakTime_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(BreakTime){
		fVel[0] = 0.0;
		fVel[1] = 0.0;
	}
}

public bool Chaos_BreakTime_Conditions(){
	if(g_iChaosRoundTime < 15){
		return false;
	}
	return true;
}