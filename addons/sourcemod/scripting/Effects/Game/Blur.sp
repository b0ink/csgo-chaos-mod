/*
	Thanks to @defuj for providing the blur .vmt materials 
	https://steamcommunity.com/id/defuj/
*/

public void Chaos_Blur(effect_data effect){
	effect.Title = "Blur";
	effect.Duration = 30;
}

bool blurMaterials = true;

public void Chaos_Blur_OnMapStart(){
	PrecacheDecal("Chaos/Blur_2.vmt", true);
	AddFileToDownloadsTable("materials/Chaos/Blur_2.vmt");
	if(!FileExists("materials/Chaos/Blur_2.vmt")) blurMaterials = false;
}

public void Chaos_Blur_START(){
	Add_Overlay("/Chaos/Blur_2.vmt");
}

public Action Chaos_Blur_RESET(bool EndChaos){
	Remove_Overlay("/Chaos/Blur_2.vmt");
}

public bool Chaos_Blur_Conditions(){
	return blurMaterials;
}