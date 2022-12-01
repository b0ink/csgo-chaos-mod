public void Chaos_IncreasedRecoil(effect_data effect){
	effect.Title = "Increased Recoil";
	effect.Duration = 30;
	effect.AddFlag("recoil");
}

public void Chaos_IncreasedRecoil_START(){
	cvar("weapon_recoil_scale", "10");
}

public Action Chaos_IncreasedRecoil_RESET(bool HasTimerEnded){
	ResetCvar("weapon_recoil_scale", "2", "10");
}