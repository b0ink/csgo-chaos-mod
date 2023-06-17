#pragma semicolon 1

bool mexicoMaterials = true;

public void Chaos_IsThisMexico(EffectData effect){
	effect.Title = "Is This What Mexico Looks Like?"; // .. in the movies?
	// effect.Title = "Breaking Bad Mexico";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

public void Chaos_IsThisMexico_OnMapStart(){
	if(!FileExists("materials/ChaosMod/ColorCorrection/mexico.raw")) mexicoMaterials = false;
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/mexico.raw");
	AddFileToDownloadsTable("sound/ChaosMod/breakingbad.mp3");
	PrecacheSound("ChaosMod/breakingbad.mp3", true);
}

public void Chaos_IsThisMexico_START(){
	CREATE_CC("mexico", .fadeIn=5.0, .maxweight=0.5);
	LoopValidPlayers(i){
		EmitSoundToClient(i, "ChaosMod/breakingbad.mp3", _, _, SNDLEVEL_RAIDSIREN, _, 0.3);
	}
}

public void Chaos_IsThisMexico_RESET(int ResetType){
	CLEAR_CC("mexico.raw");
}

public bool Chaos_IsThisMexico_Conditions(bool EffectRunRandomly){
	return mexicoMaterials;
}