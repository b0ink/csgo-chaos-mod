/*
	Thanks to @defuj for providing the blur .vmt materials 
	https://steamcommunity.com/id/defuj/
*/

public void Chaos_ExtremeBlur(effect_data effect){
	effect.Title = "Extreme Blur";
	effect.Duration = 30;
	effect.AddFlag("blur");
}

bool extremeBlurMaterials = true;

public void Chaos_ExtremeBlur_OnMapStart(){
	PrecacheDecal("Chaos/Blur_3.vmt", true);
	AddFileToDownloadsTable("materials/Chaos/Blur_3.vmt");

	if(!FileExists("materials/Chaos/Blur_3.vmt")) extremeBlurMaterials = false;
}

public void Chaos_ExtremeBlur_START(){
	Add_Overlay("/Chaos/Blur_3.vmt");
}

public Action Chaos_ExtremeBlur_RESET(bool EndChaos){
	Remove_Overlay("/Chaos/Blur_3.vmt");
}

public bool Chaos_ExtremeBlur_Conditions(){
	if(!CanRunOverlayEffect()) return false;
	return extremeBlurMaterials;
}