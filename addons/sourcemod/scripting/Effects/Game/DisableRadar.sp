#pragma semicolon 1

public void Chaos_DisableRadar(EffectData effect){
	effect.Title = "Disable Radar";
	effect.Duration = 30;
	effect.BlockInCoopStrike = true;
}

public void Chaos_DisableRadar_START(){
	cvar("sv_disable_radar", "1");
}

public void Chaos_DisableRadar_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED) ResetCvar("sv_disable_radar", "0", "1");
}