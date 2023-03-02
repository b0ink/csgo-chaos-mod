#pragma semicolon 1

public void Chaos_Sepia(EffectData effect){
	effect.Title = "Sepia";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

bool sepiaMaterials = true;

public void Chaos_Sepia_OnMapStart(){
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/sepia.raw");
	if(!FileExists("materials/ChaosMod/ColorCorrection/sepia.raw")) sepiaMaterials = false;
}

public void Chaos_Sepia_START(){
	CREATE_CC("sepia", .maxweight=0.75);
}

public void Chaos_Sepia_RESET(int ResetType){
	CLEAR_CC("sepia.raw");
}

public bool Chaos_Sepia_Conditions(bool EffectRunRandomly){
	return sepiaMaterials;
}