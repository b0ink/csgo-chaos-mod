public void Chaos_SilentFootsteps_START(){
	cvar("sv_footsteps", "0");
}

public Action Chaos_SilentFootsteps_RESET(bool HasTimerEnded){
	ResetCvar("sv_footsteps", "0", "1");
}