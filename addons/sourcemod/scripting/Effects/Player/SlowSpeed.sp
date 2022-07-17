public void Chaos_SlowSpeed_START(){
	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.5);
	}
}

public Action Chaos_SlowSpeed_RESET(bool HasTimerEnded){
	if(HasTimerEnded) {
		LoopAlivePlayers(i){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
		}
	}
}

public bool Chaos_SlowSpeed_HasNoDuration(){
	return false;
}

public bool Chaos_SlowSpeed_Conditions(){
	return true;
}