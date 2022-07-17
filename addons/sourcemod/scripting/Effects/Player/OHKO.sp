public void Chaos_OHKO_START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, 1);
	}
}

public Action Chaos_OHKO_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			SetEntityHealth(i, 100);
		}
	}
}

public bool Chaos_OHKO_Conditions(){
	return true;
}