#pragma semicolon 1

public void Chaos_Magenta(EffectData effect) {
	effect.Title = "Magenta";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

bool pinkMaterials = true;

public void Chaos_Magenta_OnMapStart() {
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/pink.raw");
	if(!FileExists("materials/ChaosMod/ColorCorrection/pink.raw")) pinkMaterials = false;
}

public void Chaos_Magenta_START() {
	CREATE_CC("pink");
}

public void Chaos_Magenta_RESET() {
	CLEAR_CC("pink.raw");
}

public bool Chaos_Magenta_Conditions() {
	return pinkMaterials;
}