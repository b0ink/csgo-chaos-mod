bool NoManualReload = false;

public void Chaos_NoManualReload(effect_data effect){
	effect.Title = "No Manual Reload";
	effect.Duration = 30;
}

public void Chaos_NoManualReload_START(){
	NoManualReload = true;
}

public void Chaos_NoManualReload_RESET(){
	NoManualReload = false;
}

public Action Chaos_NoManualReload_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(!NoManualReload) return Plugin_Continue;

	if(!(buttons & IN_RELOAD)){
		return Plugin_Continue;
	} else {
		buttons &= ~IN_RELOAD;
		return Plugin_Changed;
	}
} 