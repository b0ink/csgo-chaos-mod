#pragma semicolon 1

public void Chaos_DisableForwardBack(EffectData effect){
	effect.Title = "Disable W / S Keys";
	effect.Duration = 30;
}

public void Chaos_DisableForwardBack_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if(vel[0] != 0.0){
		vel[0] = 0.0;
	}
}