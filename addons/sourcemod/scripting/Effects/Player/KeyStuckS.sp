#pragma semicolon 1

bool SKeyStuck = false;

public void Chaos_KeyStuckS(effect_data effect){
	effect.Title = "Help my S key is stuck";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_DisableForwardBack");
	effect.IncompatibleWith("Chaos_KeyStuckW");
}

public void Chaos_KeyStuckS_START(){
	SKeyStuck = true;
}

public void Chaos_KeyStuckS_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if(SKeyStuck) fVel[0] = -400.0;
}

public void Chaos_KeyStuckS_RESET(int ResetType){
	SKeyStuck = false;
}

public bool Chaos_KeyStuckS_Conditions(bool EffectRunRandomly){
	if(EffectRunRandomly){
		return CanRunKeyStuckEffect();
	}
	return true;
}