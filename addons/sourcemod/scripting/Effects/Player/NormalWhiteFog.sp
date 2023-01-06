public void Chaos_NormalWhiteFog(effect_data effect){
	effect.Title = "Fog";
	effect.Duration = 45;
	effect.AddFlag("fog");
}

public void Chaos_NormalWhiteFog_START(){
	NormalWhiteFog();
}

public void Chaos_NormalWhiteFog_RESET(bool HasTimerEnded){
	NormalWhiteFog(true);
}
