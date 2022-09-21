public void Chaos_LowRenderDistance(effect_data effect){
	effect.title = "Low Render Distance";
	effect.duration = 30;
}

public void Chaos_LowRenderDistance_START(){
	LowRenderDistance();
}

public Action Chaos_LowRenderDistance_RESET(bool HasTimerEnded){
	ResetRenderDistance();
}