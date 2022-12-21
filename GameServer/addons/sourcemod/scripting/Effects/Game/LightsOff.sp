#define EFFECTNAME LightsOff

SETUP(effect_data effect){
	effect.Title = "Who turned the lights off?";
	effect.Duration = 30;
}

START(){
	LightsOff();
}

RESET(bool HasTimerEnded){
	LightsOff(true);
}