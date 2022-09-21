public void Chaos_MoonGravity(effect_data effect){
	effect.title = "Low Gravity";
	effect.duration = 30;
	effect.AddAlias("LowGravity");
}

public void Chaos_MoonGravity_START(){
	SetPlayersGravity(0.3);
}
//TODO: fluctuating gravity thoughout the round?

public Action Chaos_MoonGravity_RESET(bool HasTimerEnded){
	SetPlayersGravity(1.0);
}