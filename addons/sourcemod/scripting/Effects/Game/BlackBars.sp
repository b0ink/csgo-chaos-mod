public void Chaos_BlackBars(effect_data effect){
	effect.Title = "Black Bars";
	effect.Duration = 30;
}

bool blackBarsMaterials = true;

public void Chaos_BlackBars_OnMapStart(){
	PrecacheDecal("Chaos/BlackBars.vmt", true);
	PrecacheDecal("Chaos/BlackBars.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/BlackBars.vtf");
	AddFileToDownloadsTable("materials/Chaos/BlackBars.vmt");

	if(!FileExists("materials/Chaos/BlackBars.vtf")) blackBarsMaterials =  false;
	if(!FileExists("materials/Chaos/BlackBars.vmt")) blackBarsMaterials = false;
}

public void Chaos_BlackBars_START(){
	Add_Overlay("/Chaos/BlackBars.vtf");
}


public void Chaos_BlackBars_RESET(bool EndChaos){
	Remove_Overlay("/Chaos/BlackBars.vtf");
}

public bool Chaos_BlackBars_Conditions(){
	if(!CanRunOverlayEffect()) return false;
	return blackBarsMaterials;
}
