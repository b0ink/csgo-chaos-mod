public void Chaos_HealAllPlayers_START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, 100);
	}
}

public Action Chaos_HealAllPlayers_RESET(bool HasTimerEnded){

}


public bool Chaos_HealAllPlayers_HasNoDuration(){
	return true;
}

public bool Chaos_HealAllPlayers_Conditions(){
	return true;
}