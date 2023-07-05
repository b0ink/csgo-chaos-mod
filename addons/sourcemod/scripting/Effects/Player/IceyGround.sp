#pragma semicolon 1

public void Chaos_IceyGround(EffectData effect){
	effect.Title = "Icy Ground";
	effect.Duration = 30;
}

public void Chaos_IceyGround_START(){
	cvar("sv_friction", "0");
}

public void Chaos_IceyGround_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED) ResetCvar("sv_friction", "5.2", "0");
}