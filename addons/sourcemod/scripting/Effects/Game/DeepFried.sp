#pragma semicolon 1

public void Chaos_DeepFried(EffectData effect){
	effect.Title = "Deep Fried";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

bool deepFriedMaterials = true;

public void Chaos_DeepFried_OnMapStart(){
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/deepfried.raw");
	if(!FileExists("materials/ChaosMod/ColorCorrection/deepfried.raw")) deepFriedMaterials = false;
}

public void Chaos_DeepFried_START(){
	CREATE_CC("deepfried");
}

public void Chaos_DeepFried_RESET(int ResetType){
	CLEAR_CC("deepfried.raw");
}

public bool Chaos_DeepFried_Conditions(bool EffectRunRandomly){
	return deepFriedMaterials;
}