#pragma semicolon 1

public void Chaos_NoRecoil(effect_data effect){
	effect.Title = "100% Weapon Accuracy";
	effect.Duration = 30;
	effect.AddFlag("recoil");
}

public void Chaos_NoRecoil_START(){
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");
}

public void Chaos_NoRecoil_RESET(bool HasTimerEnded){
	ResetCvar("weapon_accuracy_nospread", "0", "1");
	ResetCvar("weapon_recoil_scale", "2", "0");
}

// weapon_accuracy_nospread "1";
// weapon_debug_spread_gap "1";
// weapon_recoil_cooldown "0";
// weapon_recoil_decay1_exp "99999";
// weapon_recoil_decay2_exp "99999";
// weapon_recoil_decay2_lin "99999";
// weapon_recoil_scale "0";
// weapon_recoil_suppression_shots "500";