#pragma semicolon 1

bool TradeLives = false;

public void Chaos_TradeLives(EffectData effect){
	effect.Title = "Respawn Teammate On Enemy Kill";
	effect.Duration = 30;

	HookEvent("player_death", TradeLives_Event_PlayerDeath);
}

public void Chaos_TradeLives_START(){
	TradeLives = true;
}

public void Chaos_TradeLives_RESET(int ResetType){
	TradeLives = false;
}

public void TradeLives_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	if(!TradeLives) return;
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if(IsValidClient(victim) && IsValidClient(attacker)){
		int teamToRevive = GetClientTeam(victim) == CS_TEAM_CT ? CS_TEAM_T : CS_TEAM_CT;
		if(IsCoopStrike()){
			if(teamToRevive == CS_TEAM_CT){
				ServerCommand("script \"ScriptCoopMissionRespawnDeadPlayers()\"");
			}else{
				return;
			}
		}else{
			LoopValidPlayers(i){
				if(!IsPlayerAlive(i) && GetClientTeam(i) == teamToRevive){
					CS_RespawnPlayer(i);
					break;
				}
			}
		}

	}
}