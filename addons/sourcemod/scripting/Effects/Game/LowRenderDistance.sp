#pragma semicolon 1

public void Chaos_LowRenderDistance(EffectData effect){
	effect.Title = "Low Render Distance";
	effect.Duration = 30;
	effect.AddAlias("Visual");
}

public void Chaos_LowRenderDistance_START(){
	LowRenderDistance();
}

public void Chaos_LowRenderDistance_RESET(int ResetType){
	ResetRenderDistance();
}