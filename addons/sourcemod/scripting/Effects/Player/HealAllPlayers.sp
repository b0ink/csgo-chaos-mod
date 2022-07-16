public void Chaos_HealAllPlayers_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntityHealth(i, 100);
		}
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