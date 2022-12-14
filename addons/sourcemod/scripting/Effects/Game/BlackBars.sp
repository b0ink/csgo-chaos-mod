#define EFFECTNAME BlackBars

SETUP(effect_data effect){
	effect.Title = "Black Bars";
	effect.Duration = 30;
}

bool blackBarsMaterials = true;

ONMAPSTART(){
	PrecacheDecal("Chaos/BlackBars.vmt", true);
	PrecacheDecal("Chaos/BlackBars.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/BlackBars.vtf");
	AddFileToDownloadsTable("materials/Chaos/BlackBars.vmt");

	if(!FileExists("materials/Chaos/BlackBars.vtf")) blackBarsMaterials =  false;
	if(!FileExists("materials/Chaos/BlackBars.vmt")) blackBarsMaterials = false;
}

START(){
	Add_Overlay("/Chaos/BlackBars.vtf");
}


RESET(bool EndChaos){
	Remove_Overlay("/Chaos/BlackBars.vtf");
}

CONDITIONS(){
	if(!CanRunOverlayEffect()) return false;
	return blackBarsMaterials;
}
