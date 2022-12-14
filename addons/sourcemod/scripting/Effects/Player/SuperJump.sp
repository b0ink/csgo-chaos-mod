#define EFFECTNAME SuperJump

SETUP(effect_data effect){
	effect.Title = "Super Jump";
	effect.Duration = 30;
}

START(){
	cvar("sv_jump_impulse", "590");
}

RESET(bool HasTimerEnded){
	ResetCvar("sv_jump_impulse", "301", "590");
}