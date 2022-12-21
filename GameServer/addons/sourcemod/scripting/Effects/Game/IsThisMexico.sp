#define EFFECTNAME IsThisMexico

SETUP(effect_data effect){
	effect.Title = "Is This What Mexico Looks Like?";
	effect.Duration = 30;
	effect.AddFlag("fog");
}

START(){
	Mexico();
}

RESET(bool HasTimerEnded){
	Mexico(true);
}