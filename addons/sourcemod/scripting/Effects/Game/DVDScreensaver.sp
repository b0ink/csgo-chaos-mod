bool DVDScreensaverMaterials = true;

public void Chaos_DVDScreensaver(EffectData effect){
	effect.Title = "DVD Screensaver";
	effect.Duration = 30;
	effect.AddAlias("Overlay");
	effect.AddAlias("Visual");
	effect.AddFlag("r_screenoverlay");
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
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/DVDScreensaver.vtf\"");
	}
}


public void Chaos_DVDScreensaver_OnPlayerSpawn(int client){
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/DVDScreensaver.vtf\"");
}


public void Chaos_DVDScreensaver_RESET(int ResetType){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"\"");
	}
}

public bool Chaos_DVDScreensaver_Conditions(bool EffectRunRandomly){
	return DVDScreensaverMaterials;
}