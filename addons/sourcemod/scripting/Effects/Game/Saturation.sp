#pragma semicolon 1

public void Chaos_Saturation(effect_data effect){
	effect.Title = "Saturation";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

bool saturationMaterials = true;

public void Chaos_Saturation_OnMapStart(){
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/saturation.raw");
	if(!FileExists("materials/ChaosMod/ColorCorrection/saturation.raw")) saturationMaterials = false;
}

public void Chaos_Saturation_START(){
	CREATE_CC("saturation");
}

public void Chaos_Saturation_RESET(int ResetType){
	CLEAR_CC("saturation.raw");
}

public bool Chaos_Saturation_Conditions(bool EffectRunRandomly){
	return saturationMaterials;
}