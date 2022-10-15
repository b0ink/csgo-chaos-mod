public void Chaos_Saturation(effect_data effect){
	effect.title = "Saturation";
	effect.duration = 30;
}

public void Chaos_Saturation_OnMapStart(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/saturation.raw");
}

public void Chaos_Saturation_START(){
	CREATE_CC("saturation");
}

public Action Chaos_Saturation_RESET(bool HasTimerEnded){
	CLEAR_CC("saturation.raw");
}