#pragma semicolon 1

public void Chaos_SlowSpeed(effect_data effect){
	effect.Title = "Slow Speed";
	effect.Duration = 30;
	effect.AddFlag("movement");
}

public void Chaos_SlowSpeed_START(){
	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.5);
	}
}

public void Chaos_SlowSpeed_RESET(int ResetType){
	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}

public void Chaos_SlowSpeed_OnPlayerSpawn(int client){
	SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 0.5);
}