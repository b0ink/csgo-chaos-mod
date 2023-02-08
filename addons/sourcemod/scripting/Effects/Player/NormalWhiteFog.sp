#pragma semicolon 1

public void Chaos_NormalWhiteFog(effect_data effect){
	effect.Title = "Fog";
	effect.Duration = 45;
	effect.AddFlag("fog");
}

public void Chaos_NormalWhiteFog_START(){
	NormalWhiteFog();
}

public void Chaos_NormalWhiteFog_RESET(int ResetType){
	NormalWhiteFog(true);
}
