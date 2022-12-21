#define EFFECTNAME BlackWhite

bool blackWhiteMaterials = true;

SETUP(effect_data effect){
	effect.Title = "Black and White";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
}

ONMAPSTART(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/blackandwhite.raw");
	if(!FileExists("materials/Chaos/ColorCorrection/blackandwhite.raw")) blackWhiteMaterials = false;
}

START(){
	CREATE_CC("blackandwhite");
}

RESET(bool HasTimerEnded){
	CLEAR_CC("blackandwhite.raw");
}

CONDITIONS(){
	return blackWhiteMaterials;
}