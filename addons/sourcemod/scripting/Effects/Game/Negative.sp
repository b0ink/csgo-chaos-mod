#pragma semicolon 1

public void Chaos_Negative(EffectData effect) {
	effect.Title = "Negative";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

bool negativeMaterials = true;

public void Chaos_Negative_OnMapStart() {
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/negative.raw");
	if(!FileExists("materials/ChaosMod/ColorCorrection/negative.raw")) negativeMaterials = false;
}

public void Chaos_Negative_START() {
	CREATE_CC("negative");
}

public void Chaos_Negative_RESET() {
	CLEAR_CC("negative.raw");
}

public bool Chaos_Negative_Conditions() {
	return negativeMaterials;
}