#pragma semicolon 1

//TODO: reminds me of portrait mode on youtube/tiktok, should do another effect that has that overlay

public void Chaos_BiggerBlackBars(EffectData effect){
	effect.Title = "Bigger Black Bars";
	effect.Duration = 30;
	effect.AddFlag("r_screenoverlay");
}

bool bigblackBarsMaterials = true;

public void Chaos_BiggerBlackBars_OnMapStart(){
	PrecacheDecal("ChaosMod/bigblackbars.vmt", true);
	PrecacheDecal("ChaosMod/bigblackbars.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/bigblackbars.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/bigblackbars.vmt");

	if(!FileExists("materials/ChaosMod/bigblackbars.vtf")) bigblackBarsMaterials =  false;
	if(!FileExists("materials/ChaosMod/bigblackbars.vmt")) bigblackBarsMaterials = false;
}

public void Chaos_BiggerBlackBars_START(){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/bigblackbars.vtf\"");
	}
}

public void Chaos_BiggerBlackBars_OnPlayerSpawn(int client){
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/bigblackbars.vtf\"");
}


public void Chaos_BiggerBlackBars_RESET(bool EndChaos){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"\"");
	}
}

public bool Chaos_BiggerBlackBars_Conditions(bool EffectRunRandomly){
	return bigblackBarsMaterials;
}
