public void Chaos_Bumpmines_START(){
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_bumpmine");
	}
}

public Action Chaos_Bumpmines_RESET(bool HasTimerEnded){

}


public bool Chaos_Bumpmines_HasNoDuration(){
	return true;
}

public bool Chaos_Bumpmines_Conditions(){
	return true;
}