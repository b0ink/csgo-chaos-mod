public void Chaos_SlowSpeed(effect_data effect){
	effect.Title = "Slow Speed";
	effect.Duration = 30;
}

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

public void Chaos_SlowSpeed_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 0.5);
	}
}