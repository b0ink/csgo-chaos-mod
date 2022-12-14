SETUP(effect_data effect){
	effect.Title = "Disable Radar";
	effect.Duration = 30;
}

START(){
	cvar("sv_disable_radar", "1");
}

RESET(bool HasTimerEnded){
	ResetCvar("sv_disable_radar", "0", "1");
}