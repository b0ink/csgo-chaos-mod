public void Chaos_FastSpeed_START(){
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 3.0);
}

public Action Chaos_FastSpeed_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}

public bool Chaos_FastSpeed_HasNoDuration(){
	return false;
}

public bool Chaos_FastSpeed_Conditions(){
	return true;
}