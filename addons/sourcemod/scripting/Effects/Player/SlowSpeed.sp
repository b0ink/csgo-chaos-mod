public void Chaos_SlowSpeed_START(){
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.5);
}

public Action Chaos_SlowSpeed_RESET(bool HasTimerEnded){
	if(HasTimerEnded) {
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}

public bool Chaos_SlowSpeed_HasNoDuration(){
	return false;
}

public bool Chaos_SlowSpeed_Conditions(){
	return true;
}