public void Chaos_DeepFried(effect_data effect){
	effect.title = "Deep Fried";
	effect.duration = 30;
}
public void Chaos_DeepFried_START(){
	CREATE_CC("deepfried");
}

public Action Chaos_DeepFried_RESET(bool HasTimerEnded){
	CLEAR_CC("deepfried.raw");
}