public void Chaos_DeepFried(effect_data effect){
	effect.Title = "Deep Fried";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
}

bool deepFriedMaterials = true;

public void Chaos_DeepFried_OnMapStart(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/deepfried.raw");
	if(!FileExists("materials/Chaos/ColorCorrection/deepfried.raw")) deepFriedMaterials = false;
}

public void Chaos_DeepFried_START(){
	CREATE_CC("deepfried");
}

public void Chaos_DeepFried_RESET(bool HasTimerEnded){
	CLEAR_CC("deepfried.raw");
}

public bool Chaos_DeepFried_Conditions(){
	return deepFriedMaterials;
}