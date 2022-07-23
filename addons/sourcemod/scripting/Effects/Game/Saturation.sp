public void Chaos_Saturation_START(){
	CREATE_CC("saturation");
}

public Action Chaos_Saturation_RESET(bool HasTimerEnded){
	CLEAR_CC("saturation.raw");
}