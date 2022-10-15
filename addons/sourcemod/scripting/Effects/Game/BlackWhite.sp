public void Chaos_BlackWhite(effect_data effect){
	effect.Title = "Black and White";
	effect.Duration = 30;
}

public void Chaos_BlackWhite_OnMapStart(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/blackandwhite.raw");
}

public void Chaos_BlackWhite_START(){
	CREATE_CC("blackandwhite");
}

public Action Chaos_BlackWhite_RESET(bool HasTimerEnded){
	CLEAR_CC("blackandwhite.raw");
}