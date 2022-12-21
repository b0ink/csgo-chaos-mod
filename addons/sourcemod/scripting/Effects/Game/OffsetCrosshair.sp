#define EFFECTNAME OffsetCrosshair

SETUP(effect_data effect){
	effect.Title = "Offset Crosshair";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_NoCrosshair");
}

bool offsetCrosshairMaterials = true;

ONMAPSTART(){
	PrecacheDecal("Chaos/OffsetCrosshair.vmt", true);
	PrecacheDecal("Chaos/OffsetCrosshair.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/OffsetCrosshair.vtf");
	AddFileToDownloadsTable("materials/Chaos/OffsetCrosshair.vmt");

	if(!FileExists("materials/Chaos/OffsetCrosshair.vmt")) offsetCrosshairMaterials = false;
	if(!FileExists("materials/Chaos/OffsetCrosshair.vtf")) offsetCrosshairMaterials = false;
}

START(){
	Add_Overlay("/Chaos/OffsetCrosshair.vtf");
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}


RESET(bool HasTimerEnded){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
	}
	Remove_Overlay("/Chaos/OffsetCrosshair.vtf");
}

public void Chaos_OffsetCrosshair_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}

CONDITIONS(){
	if(!CanRunOverlayEffect()) return false;
	return offsetCrosshairMaterials;
}