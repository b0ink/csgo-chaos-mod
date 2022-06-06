public void Chaos_BlindPlayers_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)) PerformBlind(i, 255);
	}
}

public Action Chaos_BlindPlayers_RESET(bool EndChaos){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			PerformBlind(i, 0);
		}
	}
}

public bool Chaos_BlindPlayers_HasNoDuration(){
	return false;
}

public bool Chaos_BlindPlayers_Conditions(){
	return true;
}