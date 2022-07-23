public void Chaos_HeadshotOnly_START(){
	cvar("mp_damage_headshot_only", "1");
	//?: through SM
}

public Action Chaos_HeadshotOnly_RESET(bool HasTimerEnded){
	ResetCvar("mp_damage_headshot_only", "0", "1");
}