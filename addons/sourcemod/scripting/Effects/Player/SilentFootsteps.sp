public void Chaos_SilentFootsteps_START(){
	cvar("sm_footsteps", "0");
}

public Action Chaos_SilentFootsteps_RESET(bool HasTimerEnded){
	ResetCvar("sm_footsteps", "0", "1");
}