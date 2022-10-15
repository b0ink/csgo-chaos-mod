public void Chaos_QuakeFOV(effect_data effect){
	effect.Title = "Quake FOV";
	effect.HasNoDuration = true;
}

public void Chaos_QuakeFOV_START(){
	int RandomFOV = GetRandomInt(130,160);
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", RandomFOV);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", RandomFOV);
	}
}

public Action Chaos_QuakeFOV_RESET(bool HasTimerEnded){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", 0);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", 90);
	}
}