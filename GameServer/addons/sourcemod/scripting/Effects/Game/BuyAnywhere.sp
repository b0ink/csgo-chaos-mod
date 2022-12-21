#define EFFECTNAME BuyAnywhere

SETUP(effect_data effect){
	effect.Title = "Buy Anyhere Enabled";
	effect.Duration = 30;
}

START(){
	cvar("mp_buy_anywhere", "1");
	cvar("mp_buytime", "999");
}

RESET(bool HasTimerEnded){
	ResetCvar("mp_buy_anywhere", "0", "1");
	ResetCvar("mp_buytime", "20", "999");
}