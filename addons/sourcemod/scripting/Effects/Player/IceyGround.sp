public void Chaos_IceyGround_START(){
	cvar("sv_friction", "0");

}

public Action Chaos_IceyGround_RESET(bool EndChaos){
	ResetCvar("sv_friction", "5.2", "0");
}

public bool Chaos_IceyGround_Conditions(){
	return true;
}