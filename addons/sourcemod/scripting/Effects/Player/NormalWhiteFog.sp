public void Chaos_NormalWhiteFog(effect_data effect){
	effect.Title = "Fog";
	effect.Duration = 45;
}

public void Chaos_NormalWhiteFog_START(){
	NormalWhiteFog();
}

public Action Chaos_NormalWhiteFog_RESET(bool HasTimerEnded){
	NormalWhiteFog(true);
}
