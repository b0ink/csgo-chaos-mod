public void Chaos_DeepFried(effect_data effect){
	effect.Title = "Deep Fried";
	effect.Duration = 30;
}

public void Chaos_DeepFried_OnMapStart(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/deepfried.raw");
}

public void Chaos_DeepFried_START(){
	CREATE_CC("deepfried");
}

public Action Chaos_DeepFried_RESET(bool HasTimerEnded){
	CLEAR_CC("deepfried.raw");
}