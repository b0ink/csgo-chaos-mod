bool DVDScreensaverMaterials = true;

public void Chaos_DVDScreensaver(effect_data effect){
	effect.Title = "DVD Screensaver";
	effect.Duration = 30;
	effect.AddAlias("Overlay");
	effect.AddAlias("Visual");
}

public void Chaos_DVDScreensaver_OnMapStart(){
	PrecacheDecal("Chaos/DVDScreensaver.vmt", true);
	PrecacheDecal("Chaos/DVDScreensaver.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/DVDScreensaver.vtf");
	AddFileToDownloadsTable("materials/Chaos/DVDScreensaver.vmt");

	if(!FileExists("materials/Chaos/DVDScreensaver.vtf")) DVDScreensaverMaterials =  false;
	if(!FileExists("materials/Chaos/DVDScreensaver.vmt")) DVDScreensaverMaterials = false;
}

public void Chaos_DVDScreensaver_START(){
	Add_Overlay("/Chaos/DVDScreensaver.vtf");
}


public void Chaos_DVDScreensaver_RESET(int ResetType){
	Remove_Overlay("/Chaos/DVDScreensaver.vtf");
}

public bool DVDScreensaver_Conditions(bool EffectRunRandomly){
	if(!CanRunOverlayEffect() && EffectRunRandomly) return false;
	return DVDScreensaverMaterials;
}