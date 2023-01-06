public void Chaos_ReversedRecoil(effect_data effect){
	effect.Title = "Reversed Recoil";
	effect.Duration = 30;
	effect.AddFlag("recoil");
}

public void Chaos_ReversedRecoil_START(){
	cvar("weapon_recoil_scale", "-5");
}

public void Chaos_ReversedRecoil_RESET(bool HasTimerEnded){
	ResetCvar("weapon_recoil_scale", "2", "-5");
}