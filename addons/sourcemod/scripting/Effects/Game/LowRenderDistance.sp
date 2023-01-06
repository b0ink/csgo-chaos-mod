public void Chaos_LowRenderDistance(effect_data effect){
	effect.Title = "Low Render Distance";
	effect.Duration = 30;
}

public void Chaos_LowRenderDistance_START(){
	LowRenderDistance();
}

public void Chaos_LowRenderDistance_RESET(bool HasTimerEnded){
	ResetRenderDistance();
}