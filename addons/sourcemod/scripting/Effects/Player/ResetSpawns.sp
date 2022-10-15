float 	g_OriginalSpawnVec[MAXPLAYERS+1][3];

public void Chaos_ResetSpawns(effect_data effect){
	effect.title = "Teleport all players back to spawn";
	effect.AddAlias("Teleport");
	effect.HasNoDuration = true;
}

public void Chaos_ResetSpawns_INIT(){
	HookEvent("round_start", Chaos_ResetSpawns_Event_RoundStart)
}

public Action Chaos_ResetSpawns_Event_RoundStart(Event event, char[] name, bool dontBroadcast){
	LoopAlivePlayers(client){
		GetClientAbsOrigin(client, g_OriginalSpawnVec[client]);
	}
}

public void Chaos_ResetSpawns_START(){
	float zero_vector[3] = {0.0, 0.0, 0.0};
	LoopAlivePlayers(i){
		if(g_OriginalSpawnVec[i][0] != 0.0 && g_OriginalSpawnVec[i][1] != 0.0 && g_OriginalSpawnVec[i][2] != 0.0){
			TeleportEntity(i, g_OriginalSpawnVec[i], NULL_VECTOR, zero_vector);
		}
	}
}

public bool Chaos_ResetSpawns_Conditions(){
	if(g_iChaos_Round_Time <= 25) return false;
	return true;
}