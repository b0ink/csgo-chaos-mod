public void Chaos_BlindPlayers(effect_data effect){
	effect.title = "Blind";
	effect.duration = 7;
}

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