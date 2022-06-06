public void Chaos_BuyAnywhere_START(){
	cvar("mp_buy_anywhere", "1");
	cvar("mp_buytime", "999");
}

public Action Chaos_BuyAnywhere_RESET(bool EndChaos){
	ResetCvar("mp_buy_anywhere", "0", "1");
	ResetCvar("mp_buytime", "20", "999");
}


public bool Chaos_BuyAnywhere_HasNoDuration(){
	return false;
}

public bool Chaos_BuyAnywhere_Conditions(){
	return true;
}