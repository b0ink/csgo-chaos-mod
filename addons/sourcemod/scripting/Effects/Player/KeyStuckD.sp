#pragma semicolon 1

public void Chaos_KeyStuckD(EffectData effect){
	effect.Title = "Help my D key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_DisableStrafe");
	effect.IncompatibleWith("Chaos_KeyStuckA");
}

public void Chaos_KeyStuckD_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	vel[1] = 400.0;
}

public bool Chaos_KeyStuckD_Conditions(bool EffectRunRandomly){
	if(EffectRunRandomly){
		return CanRunKeyStuckEffect();
	}
	return true;
}