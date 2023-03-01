#pragma semicolon 1

#define HIDEHUD_CROSSHAIR           (1 << 8)	// Hide crosshairs
bool BufferingMaterials = true;


public void Chaos_Buffering(EffectData effect){
	effect.Title = "Buffering";
	effect.Duration = 30;
	effect.AddAlias("Overlay");
	effect.AddAlias("Visual");
	effect.AddFlag("r_screenoverlay");
	effect.AddFlag("crosshair");
}

public void Chaos_Buffering_OnMapStart(){
	PrecacheDecal("ChaosMod/Buffering.vmt", true);
	PrecacheDecal("ChaosMod/Buffering.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/Buffering.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/Buffering.vmt");

	if(!FileExists("materials/ChaosMod/Buffering.vtf")) BufferingMaterials =  false;
	if(!FileExists("materials/ChaosMod/Buffering.vmt")) BufferingMaterials = false;
}

public void Chaos_Buffering_START(){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/Buffering.vtf\"");
		SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}


public void Chaos_Buffering_OnPlayerSpawn(int client){
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/Buffering.vtf\"");
	SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
}


public void Chaos_Buffering_RESET(int ResetType){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"\"");
		SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
	}
}

public bool Buffering_Conditions(bool EffectRunRandomly){
	return BufferingMaterials;
}