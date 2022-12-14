/*
	Thanks to @defuj for providing the blur .vmt materials 
	https://steamcommunity.com/id/defuj/
*/

SETUP(effect_data effect){
	effect.Title = "Extreme Blur";
	effect.Duration = 30;
	effect.AddFlag("blur");
}

bool extremeBlurMaterials = true;

public void Chaos_ExtremeBlur_OnMapStart(){
	PrecacheDecal("Chaos/Blur_3.vmt", true);
	AddFileToDownloadsTable("materials/Chaos/Blur_3.vmt");
	
	PrecacheDecal("nature/water_coast01_normal.vtf", true);
	AddFileToDownloadsTable("materials/nature/water_coast01_normal.vtf");
	
	if(!FileExists("materials/Chaos/Blur_3.vmt")) extremeBlurMaterials = false;
}

START(){
	Add_Overlay("/Chaos/Blur_3.vmt");
}

RESET(bool HasTimerEnded){
	Remove_Overlay("/Chaos/Blur_3.vmt");
}

CONDITIONS(){
	if(!CanRunOverlayEffect()) return false;
	return extremeBlurMaterials;
}