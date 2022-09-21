public void Chaos_SilentFootsteps(effect_data effect){
	effect.title = "Silent Footsteps";
	effect.duration = 30;
}

public void Chaos_SilentFootsteps_START(){
	cvar("sv_footsteps", "0");
}

public Action Chaos_SilentFootsteps_RESET(bool HasTimerEnded){
	ResetCvar("sv_footsteps", "0", "1");
}