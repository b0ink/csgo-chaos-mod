#pragma semicolon 1

public void Chaos_SilentFootsteps(effect_data effect){
	effect.Title = "Silent Footsteps";
	effect.Duration = 30;
}

public void Chaos_SilentFootsteps_START(){
	cvar("sv_footsteps", "0");
	cvar("sv_min_jump_landing_sound", "999");
}

public void Chaos_SilentFootsteps_RESET(int ResetType){
	ResetCvar("sv_footsteps", "1", "0");
	ResetCvar("sv_min_jump_landing_sound", "260", "999");
}