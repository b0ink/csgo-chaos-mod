#pragma semicolon 1

public void Chaos_ExtremeWhiteFog(effect_data effect){
	effect.Title = "Extreme Fog";
	effect.Duration = 30;
	effect.AddFlag("fog");
	effect.AddAlias("Visual");
}

public void Chaos_ExtremeWhiteFog_START(){
	ExtremeWhiteFog();
}

public void Chaos_ExtremeWhiteFog_RESET(int ResetType){
	ExtremeWhiteFog(true);
}