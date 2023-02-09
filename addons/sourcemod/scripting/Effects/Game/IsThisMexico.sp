#pragma semicolon 1

public void Chaos_IsThisMexico(EffectData effect){
	effect.Title = "Is This What Mexico Looks Like?";
	effect.Duration = 30;
	effect.AddFlag("fog");
	effect.AddAlias("Visual");
}

public void Chaos_IsThisMexico_START(){
	Mexico();
}

public void Chaos_IsThisMexico_RESET(int ResetType){
	Mexico(true);
}