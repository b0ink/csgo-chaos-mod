#pragma semicolon 1

public void Chaos_TeammateSwap(EffectData effect){
	effect.Title = "Teammate Swap";
	effect.HasNoDuration = true;
}

void SwapTeammates(int team){
	ArrayList players = new ArrayList();
	ArrayList swappedPlayers = new ArrayList();

	LoopAlivePlayers(i){
		if(GetClientTeam(i) == team){
			players.Push(i);
			swappedPlayers.Push(i);
		}
	}

	for(int i = 0; i < swappedPlayers.Length - 1; i++){
		swappedPlayers.SwapAt(i, i+1);
	}

	for(int i = 0; i < swappedPlayers.Length; i++){
		int client = players.Get(i);
		int target = swappedPlayers.Get(i);
		if(ValidAndAlive(client) && ValidAndAlive(target)){
			float clientPos[3];
			float targetPos[3];
			GetClientAbsOrigin(client, clientPos);
			GetClientAbsOrigin(target, targetPos);
			LerpToPoint(client, clientPos, targetPos, 0.5);
		}

	}
}

public void Chaos_TeammateSwap_START(){
	SwapTeammates(CS_TEAM_T);
	SwapTeammates(CS_TEAM_CT);
}

public bool Chaos_TeammateSwap_Conditions(bool EffectRunRandomly){
	if(GetAliveCTCount() <= 1 || GetAliveTCount() <= 1) return false;
	return true;
}
