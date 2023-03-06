#pragma semicolon 1

public void Chaos_ReversedMovement(EffectData effect){
	effect.Title = "Reversed Movement";
	effect.Duration = 30;
}

public void Chaos_ReversedMovement_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	vel[1] = -vel[1];
	vel[0] = -vel[0];
}