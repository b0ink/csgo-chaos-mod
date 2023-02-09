#pragma semicolon 1

/*
	Thanks to @defuj for providing the blur .vmt materials 
	https://steamcommunity.com/id/defuj/
*/

public void Chaos_ExtremeBlur(effect_data effect){
	effect.Title = "Extreme Blur";
	effect.Duration = 30;
	effect.AddFlag("blur");
	effect.AddAlias("Overlay");
	effect.AddAlias("Visual");
	effect.AddFlag("r_screenoverlay");
}

bool extremeBlurMaterials = true;

public void Chaos_ExtremeBlur_OnMapStart(){
	PrecacheDecal("ChaosMod/Blur_3.vmt", true);
	AddFileToDownloadsTable("materials/ChaosMod/Blur_3.vmt");
	
	PrecacheDecal("nature/water_coast01_normal.vtf", true);
	AddFileToDownloadsTable("materials/nature/water_coast01_normal.vtf");
	
	if(!FileExists("materials/ChaosMod/Blur_3.vmt")) extremeBlurMaterials = false;
}

public void Chaos_ExtremeBlur_START(){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/Blur_3.vmt\"");
	}
}

public void Chaos_ExtremeBlur_OnPlayerSpawn(int client){
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/Blur_3.vmt\"");
}

public void Chaos_ExtremeBlur_RESET(bool EndChaos){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"\"");
	}
}

public bool Chaos_ExtremeBlur_Conditions(bool EffectRunRandomly){
	return extremeBlurMaterials;
}