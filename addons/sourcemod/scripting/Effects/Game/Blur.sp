#define EFFECTNAME Blur

/*
	Thanks to @defuj for providing the blur .vmt materials 
	https://steamcommunity.com/id/defuj/
*/

SETUP(effect_data effect){
	effect.Title = "Blur";
	effect.Duration = 30;
	effect.AddFlag("blur");
}

bool blurMaterials = true;

ONMAPSTART(){
	PrecacheDecal("Chaos/Blur_2.vmt", true);
	PrecacheDecal("nature/water_coast01_normal.vtf", true);
	AddFileToDownloadsTable("materials/nature/water_coast01_normal.vtf");
	AddFileToDownloadsTable("materials/Chaos/Blur_2.vmt");
	if(!FileExists("materials/Chaos/Blur_2.vmt")) blurMaterials = false;
}

START(){
	Add_Overlay("/Chaos/Blur_2.vmt");
}

RESET(bool HasTimerEnded){
	Remove_Overlay("/Chaos/Blur_2.vmt");
}

CONDITIONS(){
	if(!CanRunOverlayEffect()) return false;
	return blurMaterials;
}