public void Chaos_IgniteAllPlayers_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			IgniteEntity(i, 10.0);
		}
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