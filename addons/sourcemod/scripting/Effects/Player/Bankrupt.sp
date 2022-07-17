public void Chaos_Bankrupt_START(){
	LoopAlivePlayers(i){
		SetClientMoney(i, 0, true);
	}
}

public Action Chaos_Bankrupt_RESET(bool HasTimerEnded){

}

public bool Chaos_Bankrupt_HasNoDuration(){
	return true;
}

public bool Chaos_Bankrupt_Conditions(){
	return true;
}