public void Chaos_SuperJump(effect_data effect){
	effect.Title = "Super Jump";
	effect.Duration = 30;
}

public void Chaos_SuperJump_START(){
	cvar("sv_jump_impulse", "590");
}

public void Chaos_SuperJump_RESET(bool HasTimerEnded){
	ResetCvar("sv_jump_impulse", "301", "590");
}