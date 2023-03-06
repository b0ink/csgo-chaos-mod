#pragma semicolon 1

public void Chaos_DisableStrafe(EffectData effect){
	effect.Title = "Disable A / D Keys";
	effect.Duration = 30;
}

public void Chaos_DisableStrafe_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if(vel[1] != 0.0){
		vel[1] = 0.0;
	}
}