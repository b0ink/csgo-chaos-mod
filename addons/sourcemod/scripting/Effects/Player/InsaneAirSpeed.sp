public void Chaos_InsaneAirSpeed_START(){
	cvar("sv_air_max_wishspeed", "2000");
	cvar("sv_airaccelerate", "2000");

}

public Action Chaos_InsaneAirSpeed_RESET(bool EndChaos){
	ResetCvar("sv_air_max_wishspeed", "30", "2000");
	ResetCvar("sv_airaccelerate", "12", "2000");
}


public bool Chaos_InsaneAirSpeed_HasNoDuration(){
	return false;
}

public bool Chaos_InsaneAirSpeed_Conditions(){
	return true;
}