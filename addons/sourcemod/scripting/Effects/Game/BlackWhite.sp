#pragma semicolon 1

public void Chaos_BlackWhite(effect_data effect){
	effect.Title = "Black and White";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

bool blackWhiteMaterials = true;

public void Chaos_BlackWhite_OnMapStart(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/blackandwhite.raw");
	if(!FileExists("materials/Chaos/ColorCorrection/blackandwhite.raw")) blackWhiteMaterials = false;
}

public void Chaos_BlackWhite_START(){
	CREATE_CC("blackandwhite");
}

public void Chaos_BlackWhite_RESET(int ResetType){
	CLEAR_CC("blackandwhite.raw");
}

public bool Chaos_BlackWhite_Conditions(bool EffectRunRandomly){
	return blackWhiteMaterials;
}