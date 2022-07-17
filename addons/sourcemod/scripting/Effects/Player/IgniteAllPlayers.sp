public void Chaos_IgniteAllPlayers_START(){
	LoopAlivePlayers(i){
		IgniteEntity(i, 10.0);
	}
}

public Action Chaos_IgniteAllPlayers_RESET(bool HasTimerEnded){

}


public bool Chaos_IgniteAllPlayers_HasNoDuration(){
	return true;
}

public bool Chaos_IgniteAllPlayers_Conditions(){
	return true;
}