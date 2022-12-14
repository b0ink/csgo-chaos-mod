#define EFFECTNAME HeadshotOnly

SETUP(effect_data effect){
	effect.Title = "Headshots Only";
	effect.Duration = 30;
}
START(){
	cvar("mp_damage_headshot_only", "1");
	//?: through SM
}

RESET(bool HasTimerEnded){
	ResetCvar("mp_damage_headshot_only", "0", "1");
}