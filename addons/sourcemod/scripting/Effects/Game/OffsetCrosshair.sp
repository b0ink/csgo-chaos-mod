#pragma semicolon 1

#define HIDEHUD_CROSSHAIR           (1 << 8)	// Hide crosshairs
bool offsetCrosshairMaterials = true;

public void Chaos_OffsetCrosshair(EffectData effect){
	effect.Title = "Offset Crosshair";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_NoCrosshair");
	effect.AddAlias("Overlay");
	effect.AddFlag("r_screenoverlay");
}


public void Chaos_OffsetCrosshair_OnMapStart(){
	PrecacheDecal("ChaosMod/OffsetCrosshair.vmt", true);
	PrecacheDecal("ChaosMod/OffsetCrosshair.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/OffsetCrosshair.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/OffsetCrosshair.vmt");

	if(!FileExists("materials/ChaosMod/OffsetCrosshair.vmt")) offsetCrosshairMaterials = false;
	if(!FileExists("materials/ChaosMod/OffsetCrosshair.vtf")) offsetCrosshairMaterials = false;
}

public void Chaos_OffsetCrosshair_START(){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/OffsetCrosshair.vtf\"");
		SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}

public void Chaos_OffsetCrosshair_RESET(bool EndChaos){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
		ClientCommand(i, "r_screenoverlay \"\"");
	}
}

public void Chaos_OffsetCrosshair_OnPlayerSpawn(int client){
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/OffsetCrosshair.vtf\"");
	SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
}

public bool Chaos_OffsetCrosshair_Conditions(bool EffectRunRandomly){
	return offsetCrosshairMaterials;
}