public void Chaos_LightsOff(effect_data effect){
	effect.Title = "Who turned the lights off?";
	effect.Duration = 30;
}

public void Chaos_LightsOff_START(){
	LightsOff();
}

public void Chaos_LightsOff_RESET(bool HasTimerEnded){
	LightsOff(true);
}