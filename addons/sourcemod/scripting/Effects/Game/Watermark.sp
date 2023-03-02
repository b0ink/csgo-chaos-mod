bool WatermarkMaterials = true;

public void Chaos_Watermark(EffectData effect){
	effect.Title = "Watermark";
	effect.Duration = 30;
	effect.AddAlias("Overlay");
	effect.AddAlias("Visual");
	effect.AddFlag("r_screenoverlay");
}

public void Chaos_Watermark_OnMapStart(){
	PrecacheDecal("ChaosMod/Watermark.vmt", true);
	PrecacheDecal("ChaosMod/Watermark.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/Watermark.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/Watermark.vmt");

	if(!FileExists("materials/ChaosMod/Watermark.vtf")) WatermarkMaterials =  false;
	if(!FileExists("materials/ChaosMod/Watermark.vmt")) WatermarkMaterials = false;
}

public void Chaos_Watermark_START(){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/Watermark.vtf\"");
	}
}


public void Chaos_Watermark_OnPlayerSpawn(int client){
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/Watermark.vtf\"");
}


public void Chaos_Watermark_RESET(int ResetType){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"\"");
	}
}

public bool Chaos_Watermark_Conditions(bool EffectRunRandomly){
	if(g_iTotalEffectsRunThisMap < 20 && EffectRunRandomly) return false;
	return WatermarkMaterials;
}