SETUP(effect_data effect){
	effect.Title = "Low Render Distance";
	effect.Duration = 30;
}

START(){
	LowRenderDistance();
}

RESET(bool HasTimerEnded){
	ResetRenderDistance();
}