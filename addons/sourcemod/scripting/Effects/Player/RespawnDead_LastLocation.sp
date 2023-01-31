#pragma semicolon 1

float 	g_PlayerDeathLocations[MAXPLAYERS+1][3];

public void Chaos_RespawnDead_LastLocation(effect_data effect){
	effect.Title = "Resurrect players where they died";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
	effect.AddFlag("respawn");
}

public void Chaos_RespawnDead_LastLocation_INIT(){
	HookEvent("player_death", Chaos_RespawnDead_LastLocation_Event_PlayerDeath);
}

public void Chaos_RespawnDead_LastLocation_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	GetClientAbsOrigin(client, g_PlayerDeathLocations[client]);
}

public void Chaos_RespawnDead_LastLocation_START(){
	LoopValidPlayers(i){
		if(!IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			if(g_PlayerDeathLocations[i][0] != 0.0 && g_PlayerDeathLocations[i][1] != 0.0 && g_PlayerDeathLocations[i][2] != 0.0){ //safety net for any players that joined mid round
				TeleportEntity(i, g_PlayerDeathLocations[i], NULL_VECTOR, NULL_VECTOR);
			}
		}
	}
}

public bool Chaos_RespawnDead_LastLocation_Conditions(bool EffectRunRandomly){
	if(GetRoundTime() <= 30 && EffectRunRandomly) return false;
	return true;
}