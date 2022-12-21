#define EFFECTNAME IncreasedRecoil

SETUP(effect_data effect){
	effect.Title = "Increased Recoil";
	effect.Duration = 30;
	effect.AddFlag("recoil");
}

START(){
	cvar("weapon_recoil_scale", "10");
}

RESET(bool HasTimerEnded){
	ResetCvar("weapon_recoil_scale", "2", "10");
}