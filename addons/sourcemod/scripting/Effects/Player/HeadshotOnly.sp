#pragma semicolon 1

public void Chaos_HeadshotOnly(EffectData effect){
	effect.Title = "Headshots Only";
	effect.Duration = 30;
}
public void Chaos_HeadshotOnly_START(){
	cvar("mp_damage_headshot_only", "1");
	//?: through SM
}

public void Chaos_HeadshotOnly_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED) ResetCvar("mp_damage_headshot_only", "0", "1");
}