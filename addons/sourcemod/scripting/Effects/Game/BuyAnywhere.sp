#pragma semicolon 1

public void Chaos_BuyAnywhere(EffectData effect){
	effect.Title = "Buy Anyhere Enabled";
	effect.Duration = 30;
	effect.BlockInCoopStrike = true;
}

public void Chaos_BuyAnywhere_START(){
	cvar("mp_buy_anywhere", "1");
	cvar("mp_buytime", "999");
}

public void Chaos_BuyAnywhere_RESET(int ResetType){
	ResetCvar("mp_buy_anywhere", "0", "1");
	ResetCvar("mp_buytime", "20", "999");
}