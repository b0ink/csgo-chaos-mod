public void Chaos_BuyAnywhere(effect_data effect){
	effect.Title = "Buy Anyhere Enabled";
	effect.Duration = 30;
}

public void Chaos_BuyAnywhere_START(){
	cvar("mp_buy_anywhere", "1");
	cvar("mp_buytime", "999");
}

public Action Chaos_BuyAnywhere_RESET(bool HasTimerEnded){
	ResetCvar("mp_buy_anywhere", "0", "1");
	ResetCvar("mp_buytime", "20", "999");
}