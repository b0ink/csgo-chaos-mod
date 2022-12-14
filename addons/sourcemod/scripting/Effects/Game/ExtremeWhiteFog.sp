SETUP(effect_data effect){
	effect.Title = "Extreme Fog";
	effect.Duration = 30;
	effect.AddFlag("fog");
}
START(){
	ExtremeWhiteFog();
}

RESET(bool HasTimerEnded){
	ExtremeWhiteFog(true);
}