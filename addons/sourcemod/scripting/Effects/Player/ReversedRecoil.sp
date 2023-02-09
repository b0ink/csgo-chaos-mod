#pragma semicolon 1

public void Chaos_ReversedRecoil(EffectData effect){
	effect.Title = "Reversed Recoil";
	effect.Duration = 30;
	effect.AddFlag("recoil");
}

public void Chaos_ReversedRecoil_START(){
	cvar("weapon_recoil_scale", "-5");
}

public void Chaos_ReversedRecoil_RESET(int ResetType){
	ResetCvar("weapon_recoil_scale", "2", "-5");
}