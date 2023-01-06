public void Chaos_IceyGround(effect_data effect){
	effect.Title = "Icy Ground";
	effect.Duration = 30;
}

public void Chaos_IceyGround_START(){
	cvar("sv_friction", "0");
}

public void Chaos_IceyGround_RESET(bool HasTimerEnded){
	ResetCvar("sv_friction", "5.2", "0");
}