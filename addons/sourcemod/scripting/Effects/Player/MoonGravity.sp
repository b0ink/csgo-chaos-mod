#pragma semicolon 1

public void Chaos_MoonGravity(EffectData effect){
	effect.Title = "Low Gravity";
	effect.Duration = 30;
	effect.AddAlias("LowGravity");
	effect.AddFlag("gravity");
}

public void Chaos_MoonGravity_START(){
	cvar("sv_gravity", "136");
}

public void Chaos_MoonGravity_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		ResetCvar("sv_gravity", "800", "136");
	}
}