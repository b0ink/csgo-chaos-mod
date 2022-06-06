bool g_bForce_Reload[MAXPLAYERS+1];

public void Chaos_ForceReload_START(){
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) g_bForce_Reload[i] = true;
}

public Action Chaos_ForceReload_RESET(bool EndChaos){
	for(int i = 0; i <= MaxClients; i++) g_bForce_Reload[i] = false;
}

public Action Chaos_ForceReload_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if (g_bForce_Reload[client]) {
		buttons |= IN_RELOAD;
		g_bForce_Reload[client] = false;
		//return Plugin_Changed;
	}
}


public bool Chaos_ForceReload_HasNoDuration(){
	return false;
}

public bool Chaos_ForceReload_Conditions(){
	return true;
}