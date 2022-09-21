public void Chaos_ExtremeWhiteFog(effect_data effect){
	effect.title = "Extreme Fog";
	effect.duration = 30;
}
public void Chaos_ExtremeWhiteFog_START(){
	ExtremeWhiteFog();
}

public Action Chaos_ExtremeWhiteFog_RESET(bool HasTimerEnded){
	ExtremeWhiteFog(true);
}