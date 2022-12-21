#define EFFECTNAME BreakTime

bool BreakTime = false;


SETUP(effect_data effect){
	effect.Title = "Take a Break";
	effect.Duration = 15;
	effect.IncompatibleWith("Chaos_WKeyStuck");
	effect.AddFlag("movement");
}

START(){
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


RESET(bool HasTimerEnded){
	BreakTime = false;
	UnhookBlockAllGuns();
}

public Action Chaos_BreakTime_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(BreakTime){
		fVel[0] = 0.0;
		fVel[1] = 0.0;
	}
}

CONDITIONS(){
	return true;
}