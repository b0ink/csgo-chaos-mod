public void Chaos_Earthquake(effect_data effect){
	effect.title = "Earthquake";
	effect.HasNoDuration = true;
}

float g_Earthquake_Duration = 7.0;
public void Chaos_Earthquake_START(){
	LoopAlivePlayers(i){
		ScreenShake(i, _, g_Earthquake_Duration);
	}
}