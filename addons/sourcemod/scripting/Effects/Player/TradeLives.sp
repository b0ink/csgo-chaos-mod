#pragma semicolon 1

bool TradeLives = false;

public void Chaos_TradeLives(effect_data effect){
	effect.Title = "Respawn Teammate On Enemy Kill";
	effect.Duration = 30;
}

public void Chaos_TradeLives_INIT(){
	HookEvent("player_death", TradeLives_Event_PlayerDeath);
}

public void Chaos_TradeLives_START(){
	TradeLives = true;
}

public void Chaos_TradeLives_RESET(bool HasTimerEnded){
	TradeLives = false;
}

public void TradeLives_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	if(!TradeLives) return;
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));

	if(IsClientInGame(victim) && IsClientInGame(attacker)){
		int teamToRevive = GetClientTeam(victim) == CS_TEAM_CT ? CS_TEAM_T : CS_TEAM_CT;
		LoopValidPlayers(i){
			if(!IsPlayerAlive(i) && GetClientTeam(i) == teamToRevive){
				CS_RespawnPlayer(i);
				break;
			}
		}
	}
}