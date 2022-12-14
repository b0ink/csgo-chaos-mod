#define EFFECTNAME Saturation

SETUP(effect_data effect){
	effect.Title = "Saturation";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
}

bool saturationMaterials = true;

public void Chaos_Saturation_OnMapStart(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/saturation.raw");
	if(!FileExists("materials/Chaos/ColorCorrection/saturation.raw")) saturationMaterials = false;
}

START(){
	CREATE_CC("saturation");
}

RESET(bool HasTimerEnded){
	CLEAR_CC("saturation.raw");
}

CONDITIONS(){
	return saturationMaterials;
}