#pragma semicolon 1

int timeSinceLastKeyStuckEffect = -1;

public void Chaos_KeyStuckA(EffectData effect){
	effect.Title = "Help my A key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_DisableStrafe");
	effect.IncompatibleWith("Chaos_KeyStuckD");
}

public void Chaos_KeyStuckA_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	vel[1] = -400.0;
}

public bool Chaos_KeyStuckA_Conditions(bool EffectRunRandomly){
	if(EffectRunRandomly){
		return CanRunKeyStuckEffect();
	}
	return true;
}

//TODO: merge this into the .AddFlag() system
bool CanRunKeyStuckEffect(){
	if((GetTime() - timeSinceLastKeyStuckEffect) > 200){
		timeSinceLastKeyStuckEffect = GetTime();
		return true;
	}
	return false;
}
