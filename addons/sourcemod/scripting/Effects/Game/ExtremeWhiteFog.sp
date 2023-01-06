public void Chaos_ExtremeWhiteFog(effect_data effect){
	effect.Title = "Extreme Fog";
	effect.Duration = 30;
	effect.AddFlag("fog");
}
public void Chaos_ExtremeWhiteFog_START(){
	ExtremeWhiteFog();
}

public void Chaos_ExtremeWhiteFog_RESET(bool HasTimerEnded){
	ExtremeWhiteFog(true);
}