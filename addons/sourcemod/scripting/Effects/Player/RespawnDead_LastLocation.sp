public void Chaos_RespawnDead_LastLocation(effect_data effect){
	effect.title = "Resurrect players where they died";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
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

public bool Chaos_RespawnDead_LastLocation_Conditions(){
	if(g_iChaos_Round_Time <= 30) return false;
	return true;
}