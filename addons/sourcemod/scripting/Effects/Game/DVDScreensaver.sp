bool DVDScreensaverMaterials = true;

public void Chaos_DVDScreensaver(effect_data effect){
	effect.Title = "DVD Screensaver";
	effect.Duration = 30;
	effect.AddAlias("Overlay");
	effect.AddAlias("Visual");
}

public void Chaos_DVDScreensaver_OnMapStart(){
	PrecacheDecal("ChaosMod/DVDScreensaver.vmt", true);
	PrecacheDecal("ChaosMod/DVDScreensaver.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/DVDScreensaver.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/DVDScreensaver.vmt");

	if(!FileExists("materials/ChaosMod/DVDScreensaver.vtf")) DVDScreensaverMaterials =  false;
	if(!FileExists("materials/ChaosMod/DVDScreensaver.vmt")) DVDScreensaverMaterials = false;
}

public void Chaos_DVDScreensaver_START(){
	Add_Overlay("/ChaosMod/DVDScreensaver.vtf");
}


public void Chaos_DVDScreensaver_RESET(int ResetType){
	Remove_Overlay("/ChaosMod/DVDScreensaver.vtf");
}

public bool DVDScreensaver_Conditions(bool EffectRunRandomly){
	if(!CanRunOverlayEffect() && EffectRunRandomly) return false;
	return DVDScreensaverMaterials;
}