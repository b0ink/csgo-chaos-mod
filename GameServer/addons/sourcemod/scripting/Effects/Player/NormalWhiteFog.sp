#define EFFECTNAME NormalWhiteFog

SETUP(effect_data effect){
	effect.Title = "Fog";
	effect.Duration = 45;
	effect.AddFlag("fog");
}

START(){
	NormalWhiteFog();
}

RESET(bool HasTimerEnded){
	NormalWhiteFog(true);
}
