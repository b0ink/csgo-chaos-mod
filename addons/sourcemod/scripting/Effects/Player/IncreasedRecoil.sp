#pragma semicolon 1

public void Chaos_IncreasedRecoil(EffectData effect){
	effect.Title = "Increased Recoil";
	effect.Duration = 30;
	effect.AddFlag("recoil");
}

public void Chaos_IncreasedRecoil_START(){
	cvar("weapon_recoil_scale", "10");
}

public void Chaos_IncreasedRecoil_RESET(int ResetType){
	ResetCvar("weapon_recoil_scale", "2", "10");
}