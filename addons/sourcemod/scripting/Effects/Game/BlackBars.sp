public void Chaos_BlackBars(effect_data effect){
	effect.Title = "Black Bars";
	effect.Duration = 30;
}

public void Chaos_BlackBars_OnMapStart(){
	PrecacheDecal("Chaos/BlackBars.vmt", true);
	PrecacheDecal("Chaos/BlackBars.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/BlackBars.vtf");
	AddFileToDownloadsTable("materials/Chaos/BlackBars.vmt");
}

public void Chaos_BlackBars_START(){
	Add_Overlay("/Chaos/BlackBars.vtf");
}


public Action Chaos_BlackBars_RESET(bool EndChaos){
	Remove_Overlay("/Chaos/BlackBars.vtf");
}
