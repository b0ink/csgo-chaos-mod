#pragma semicolon 1

public void Chaos_DisableRadar(EffectData effect){
	effect.Title = "Disable Radar";
	effect.Duration = 30;
}

public void Chaos_DisableRadar_START(){
	cvar("sv_disable_radar", "1");
}

public void Chaos_DisableRadar_RESET(int ResetType){
	ResetCvar("sv_disable_radar", "0", "1");
}