#pragma semicolon 1

public void Chaos_BlackBars(EffectData effect){
	effect.Title = "Black Bars";
	effect.Duration = 30;
	effect.AddFlag("r_screenoverlay");
}

bool blackBarsMaterials = true;

public void Chaos_BlackBars_OnMapStart(){
	PrecacheDecal("ChaosMod/BlackBars.vmt", true);
	PrecacheDecal("ChaosMod/BlackBars.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/BlackBars.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/BlackBars.vmt");

	if(!FileExists("materials/ChaosMod/BlackBars.vtf")) blackBarsMaterials =  false;
	if(!FileExists("materials/ChaosMod/BlackBars.vmt")) blackBarsMaterials = false;
}

public void Chaos_BlackBars_START(){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/BlackBars.vtf\"");
	}
}

public void Chaos_BlackBars_OnPlayerSpawn(int client){
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/BlackBars.vtf\"");
}


public void Chaos_BlackBars_RESET(bool EndChaos){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"\"");
	}
}

public bool Chaos_BlackBars_Conditions(bool EffectRunRandomly){
	return blackBarsMaterials;
}
