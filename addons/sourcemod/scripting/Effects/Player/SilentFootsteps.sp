SETUP(effect_data effect){
	effect.Title = "Silent Footsteps";
	effect.Duration = 30;
}

START(){
	cvar("sv_footsteps", "0");
	cvar("sv_min_jump_landing_sound", "999");
}

RESET(bool HasTimerEnded){
	ResetCvar("sv_footsteps", "1", "0");
	ResetCvar("sv_min_jump_landing_sound", "260", "999");
}