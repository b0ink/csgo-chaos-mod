#pragma semicolon 1

public void Chaos_NoManualReload(EffectData effect){
	effect.Title = "No Manual Reload";
	effect.Duration = 30;
}

public Action Chaos_NoManualReload_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if(!(buttons & IN_RELOAD)){
		return Plugin_Continue;
	} else {
		buttons &= ~IN_RELOAD;
		return Plugin_Changed;
	}
}