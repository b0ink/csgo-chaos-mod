#pragma semicolon 1

public void Chaos_KeyStuckW(EffectData effect){
	effect.Title = "Help my W key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_DisableForwardBack");
	effect.IncompatibleWith("Chaos_KeyStuckS");
}

public void Chaos_KeyStuckW_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	vel[0] = 400.0;
}

public bool Chaos_KeyStuckW_Conditions(bool EffectRunRandomly){
	if(EffectRunRandomly){
		return CanRunKeyStuckEffect();
	}
	return true;
}