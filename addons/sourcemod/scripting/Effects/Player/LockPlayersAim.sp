#pragma semicolon 1

float g_LockPlayersAim_Angles[MAXPLAYERS+1][3];

public void Chaos_LockPlayersAim(EffectData effect){
	effect.Title = "Lock Mouse Movement";
	effect.Duration = 30;
	effect.AddAlias("Lock Mouse Movement");
}


public void Chaos_LockPlayersAim_START(){
	LoopAlivePlayers(i){
		GetClientEyeAngles(i, g_LockPlayersAim_Angles[i]);
	}
}

public void Chaos_LockPlayersAim_OnGameFrame(){
	LoopAlivePlayers(i){
		TeleportEntity(i, NULL_VECTOR, g_LockPlayersAim_Angles[i], NULL_VECTOR);
	}
}

public void Chaos_LockPlayersAim_OnPlayerSpawn(int client){
	GetClientEyeAngles(client, g_LockPlayersAim_Angles[client]);
}