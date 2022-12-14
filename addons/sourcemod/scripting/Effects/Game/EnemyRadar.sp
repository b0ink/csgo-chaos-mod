SETUP(effect_data effect){
	effect.Title = "Enemy Radar";
	effect.Duration = 30;
}
START(){
	cvar("mp_radar_showall", "1");
}

RESET(bool HasTimerEnded){
	ResetCvar("mp_radar_showall", "0", "1");
}