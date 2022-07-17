public void Chaos_BlindPlayers_START(){
	LoopAlivePlayers(i){
		PerformBlind(i, 255);
	}
}

public Action Chaos_BlindPlayers_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		PerformBlind(i, 0);
	}
}

public bool Chaos_BlindPlayers_HasNoDuration(){
	return false;
}

public bool Chaos_BlindPlayers_Conditions(){
	return true;
}