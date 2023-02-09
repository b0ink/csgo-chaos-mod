#pragma semicolon 1

public void Chaos_FastSpeed(EffectData effect){
	effect.Title = "3x Movement Speed";
	effect.Duration = 30;
	effect.AddFlag("movement");
}

public void Chaos_FastSpeed_START(){
	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 3.0);
	}
}

public void Chaos_FastSpeed_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);	
		}
	}
}

public void Chaos_FastSpeed_OnPlayerSpawn(int client){
	SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 3.0);
}