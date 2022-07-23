public void Chaos_IceyGround_START(){
	cvar("sv_friction", "0");

}

public Action Chaos_IceyGround_RESET(bool HasTimerEnded){
	ResetCvar("sv_friction", "5.2", "0");
}