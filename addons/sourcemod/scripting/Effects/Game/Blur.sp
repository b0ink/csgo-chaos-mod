#pragma semicolon 1

/*
	Thanks to @defuj for providing the blur .vmt materials 
	https://steamcommunity.com/id/defuj/
*/

public void Chaos_Blur(effect_data effect){
	effect.Title = "Blur";
	effect.Duration = 30;
	effect.AddFlag("blur");
	effect.AddAlias("Visual");
}

bool blurMaterials = true;

public void Chaos_Blur_OnMapStart(){
	PrecacheDecal("Chaos/Blur_2.vmt", true);
	PrecacheDecal("nature/water_coast01_normal.vtf", true);
	AddFileToDownloadsTable("materials/nature/water_coast01_normal.vtf");
	AddFileToDownloadsTable("materials/Chaos/Blur_2.vmt");
	if(!FileExists("materials/Chaos/Blur_2.vmt")) blurMaterials = false;
}

public void Chaos_Blur_START(){
	Add_Overlay("/Chaos/Blur_2.vmt");
}

public void Chaos_Blur_RESET(bool EndChaos){
	Remove_Overlay("/Chaos/Blur_2.vmt");
}

public bool Chaos_Blur_Conditions(bool EffectRunRandomly){
	if(!CanRunOverlayEffect() && EffectRunRandomly) return false;
	return blurMaterials;
}