public void Chaos_QuakeFOV(effect_data effect){
	effect.HasNoDuration = true;
}

public void Chaos_QuakeFOV_START(){
	int RandomFOV = GetRandomInt(130,160);
	SetPlayersFOV(RandomFOV);
}

public Action Chaos_QuakeFOV_RESET(bool HasTimerEnded){
	ResetPlayersFOV();
}