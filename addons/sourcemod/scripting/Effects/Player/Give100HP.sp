public void Chaos_Give100HP_START(){
	LoopAlivePlayers(i){
		int currenthealth = GetClientHealth(i);
		SetEntityHealth(i, currenthealth + 100);
	}
}

public Action Chaos_Give100HP_RESET(bool HasTimerEnded){

}

public bool Chaos_Give100HP_HasNoDuration(){
	return true;
}

public bool Chaos_Give100HP_Conditions(){
	return true;
}