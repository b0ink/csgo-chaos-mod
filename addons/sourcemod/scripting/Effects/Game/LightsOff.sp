public void Chaos_LightsOff(effect_data effect){
	effect.title = "Who turned the lights off?";
	effect.duration = 30;
}

public void Chaos_LightsOff_START(){
	LightsOff();
}

public Action Chaos_LightsOff_RESET(bool HasTimerEnded){
	LightsOff(true);
}