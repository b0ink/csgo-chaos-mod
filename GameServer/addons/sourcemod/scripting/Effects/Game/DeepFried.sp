#define EFFECTNAME DeepFried

SETUP(effect_data effect){
	effect.Title = "Deep Fried";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
}

bool deepFriedMaterials = true;

ONMAPSTART(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/deepfried.raw");
	if(!FileExists("materials/Chaos/ColorCorrection/deepfried.raw")) deepFriedMaterials = false;
}

START(){
	CREATE_CC("deepfried");
}

RESET(bool HasTimerEnded){
	CLEAR_CC("deepfried.raw");
}

CONDITIONS(){
	return deepFriedMaterials;
}