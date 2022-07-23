bool g_bLockPlayersAim_Active = false;
float g_LockPlayersAim_Angles[MAXPLAYERS+1][3];

public void Chaos_LockPlayersAim_OnGameFrame(){
	LoopAlivePlayers(i){
		if(g_bLockPlayersAim_Active) TeleportEntity(i, NULL_VECTOR, g_LockPlayersAim_Angles[i], NULL_VECTOR);
	}
}

public void Chaos_LockPlayersAim_START(){
	LoopAlivePlayers(i){
		GetClientEyeAngles(i, g_LockPlayersAim_Angles[i]);
	}

	g_bLockPlayersAim_Active  = true;
}

public Action Chaos_LockPlayersAim_RESET(bool HasTimerEnded){
	g_bLockPlayersAim_Active = false;
}