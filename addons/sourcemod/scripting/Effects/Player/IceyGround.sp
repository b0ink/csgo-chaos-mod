#define EFFECTNAME IceyGround

SETUP(effect_data effect){
	effect.Title = "Icy Ground";
	effect.Duration = 30;
}

START(){
	cvar("sv_friction", "0");
}

RESET(bool HasTimerEnded){
	ResetCvar("sv_friction", "5.2", "0");
}