#pragma semicolon 1

public void Chaos_Pink(EffectData effect) {
	effect.Title = "Pink";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

bool pinkMaterials = true;

public void Chaos_Pink_OnMapStart() {
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/pink.raw");
	if(!FileExists("materials/ChaosMod/ColorCorrection/pink.raw")) pinkMaterials = false;
}

public void Chaos_Pink_START() {
	CREATE_CC("pink");
}

public void Chaos_Pink_RESET() {
	CLEAR_CC("pink.raw");
}

public bool Chaos_Pink_Conditions() {
	return pinkMaterials;
}