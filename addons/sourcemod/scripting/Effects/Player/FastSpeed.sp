public void Chaos_FastSpeed(effect_data effect){
	effect.Title = "3x Movement Speed";
	effect.Duration = 30;
}

public void Chaos_FastSpeed_START(){
	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 3.0);
	}
}

public Action Chaos_FastSpeed_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);	
		}
	}
}