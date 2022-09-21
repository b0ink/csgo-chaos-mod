public void Chaos_BlackWhite(effect_data effect){
	effect.title = "Black and White";
	effect.duration = 30;
}

public void Chaos_BlackWhite_START(){
	CREATE_CC("blackandwhite");
}

public Action Chaos_BlackWhite_RESET(bool HasTimerEnded){
	CLEAR_CC("blackandwhite.raw");
}