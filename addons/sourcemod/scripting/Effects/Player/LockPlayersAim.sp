bool g_bLockPlayersAim_Active = false;
float g_LockPlayersAim_Angles[MAXPLAYERS+1][3];

public void Chaos_LockPlayersAim_OnGameFrame(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			if(g_bLockPlayersAim_Active) TeleportEntity(i, NULL_VECTOR, g_LockPlayersAim_Angles[i], NULL_VECTOR);
		}
	}
}

public void Chaos_LockPlayersAim_START(){
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GetClientEyeAngles(i, g_LockPlayersAim_Angles[i]);

	g_bLockPlayersAim_Active  = true;

}

public Action Chaos_LockPlayersAim_RESET(bool HasTimerEnded){
	g_bLockPlayersAim_Active = false;
}

public Action Chaos_LockPlayersAim_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_LockPlayersAim_HasNoDuration(){
	return false;
}

public bool Chaos_LockPlayersAim_Conditions(){
	return true;
}