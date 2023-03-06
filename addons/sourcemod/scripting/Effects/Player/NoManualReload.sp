#pragma semicolon 1

public void Chaos_NoManualReload(EffectData effect){
	effect.Title = "No Manual Reload";
	effect.Duration = 30;
}

public Action Chaos_NoManualReload_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if(!(buttons & IN_RELOAD)){
		return Plugin_Continue;
	} else {
		buttons &= ~IN_RELOAD;
		return Plugin_Changed;
	}
}