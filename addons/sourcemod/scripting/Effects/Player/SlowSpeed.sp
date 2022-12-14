SETUP(effect_data effect){
	effect.Title = "Slow Speed";
	effect.Duration = 30;
	effect.AddFlag("movement");
}

START(){
	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.5);
	}
}

RESET(bool HasTimerEnded){
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