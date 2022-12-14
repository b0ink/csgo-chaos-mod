SETUP(effect_data effect){
	effect.Title = "Reversed Recoil";
	effect.Duration = 30;
	effect.AddFlag("recoil");
}

START(){
	cvar("weapon_recoil_scale", "-5");
}

RESET(bool HasTimerEnded){
	ResetCvar("weapon_recoil_scale", "2", "-5");
}