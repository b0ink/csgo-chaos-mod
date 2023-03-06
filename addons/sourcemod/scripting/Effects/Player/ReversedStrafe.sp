#pragma semicolon 1

public void Chaos_ReversedStrafe(EffectData effect){
	effect.Title = "Reversed Strafe";
	effect.Duration = 30;
}

public void Chaos_ReversedStrafe_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	vel[1] = -vel[1];
}