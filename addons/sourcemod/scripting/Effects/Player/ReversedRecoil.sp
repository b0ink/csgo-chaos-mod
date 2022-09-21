public void Chaos_ReversedRecoil(effect_data effect){
	effect.title = "Reversed Recoil";
	effect.duration = 30;
}

public void Chaos_ReversedRecoil_START(){
	cvar("weapon_recoil_scale", "-5");
}

public Action Chaos_ReversedRecoil_RESET(bool HasTimerEnded){
	ResetCvar("weapon_recoil_scale", "2", "-5");
}