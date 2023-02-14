#pragma semicolon 1

public void Chaos_InsaneGravity(EffectData effect){
	effect.Title = "Insane Gravity";
	effect.Duration = 30;
	effect.AddFlag("gravity");
}

public void Chaos_InsaneGravity_START(){
	cvar("sv_gravity", "2500");
}

public void Chaos_InsaneGravity_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		ResetCvar("sv_gravity", "800", "2500");
	}
}