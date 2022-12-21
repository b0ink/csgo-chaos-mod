#define EFFECTNAME LockPlayersAim

bool g_bLockPlayersAim_Active = false;
float g_LockPlayersAim_Angles[MAXPLAYERS+1][3];

SETUP(effect_data effect){
	effect.Title = "Lock Mouse Movement";
	effect.Duration = 30;
	effect.AddAlias("Lock Mouse Movement");
}

public void Chaos_LockPlayersAim_OnGameFrame(){
	LoopAlivePlayers(i){
		if(g_bLockPlayersAim_Active) TeleportEntity(i, NULL_VECTOR, g_LockPlayersAim_Angles[i], NULL_VECTOR);
	}
}

START(){
	LoopAlivePlayers(i){
		GetClientEyeAngles(i, g_LockPlayersAim_Angles[i]);
	}

	g_bLockPlayersAim_Active  = true;
}

public void Chaos_LockPlayersAim_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		GetClientEyeAngles(client, g_LockPlayersAim_Angles[client]);
	}
}

RESET(bool HasTimerEnded){
	g_bLockPlayersAim_Active = false;
}