#define EFFECTNAME InsaneAirSpeed

SETUP(effect_data effect){
	effect.Title = "Extreme Strafe Acceleration";
	effect.Duration = 30;
	effect.AddAlias("Wish");
}

START(){
	cvar("sv_air_max_wishspeed", "2000");
	cvar("sv_airaccelerate", "2000");

}

RESET(bool HasTimerEnded){
	ResetCvar("sv_air_max_wishspeed", "30", "2000");
	ResetCvar("sv_airaccelerate", "12", "2000");
}