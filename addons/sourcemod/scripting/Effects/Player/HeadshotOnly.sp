public void Chaos_HeadshotOnly(effect_data effect){
	effect.Title = "Headshots Only";
	effect.Duration = 30;
}
public void Chaos_HeadshotOnly_START(){
	cvar("mp_damage_headshot_only", "1");
	//?: through SM
}

public void Chaos_HeadshotOnly_RESET(bool HasTimerEnded){
	ResetCvar("mp_damage_headshot_only", "0", "1");
}