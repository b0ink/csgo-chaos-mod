public void Chaos_OHKO_START(){
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 1);
}

public Action Chaos_OHKO_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityHealth(i, 100);
	}
}

public bool Chaos_OHKO_Conditions(){
	return true;
}