#pragma semicolon 1

bool BreakTime = false;


public void Chaos_BreakTime(EffectData effect){
	effect.Title = "Take a Break";
	effect.Duration = 15;
	effect.IncompatibleWith("Chaos_KeyStuckA");
	effect.IncompatibleWith("Chaos_KeyStuckD");
	effect.IncompatibleWith("Chaos_KeyStuckS");
	effect.IncompatibleWith("Chaos_KeyStuckW");
	effect.AddFlag("movement");
	effect.BlockInCoopStrike = true;
}

public void Chaos_BreakTime_START(){
	BreakTime = true;
	HookBlockAllGuns();

	LoopAlivePlayers(i){
		SwitchToKnife(i);
	}
}

public void Chaos_BreakTime_OnPlayerSpawn(int client){
	if(!BreakTime) return;

	HookBlockAllGuns(client);
	SwitchToKnife(client);
}


public void Chaos_BreakTime_RESET(int ResetType){
	BreakTime = false;
	UnhookBlockAllGuns(ResetType);
}

public void Chaos_BreakTime_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if(BreakTime){
		vel[0] = 0.0;
		vel[1] = 0.0;
	}
}

public bool Chaos_BreakTime_Conditions(bool EffectRunRandomly){
	if(GetBotCount() > 0){
		return false;
	}
	if(GetRoundTime() < 15 && EffectRunRandomly){
		return false;
	}
	return true;
}