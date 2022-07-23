public void Chaos_EarthQuake(effect_data effect){
	effect.HasNoDuration = true;
}

float g_Earthquake_Duration = 7.0;
public void Chaos_Earthquake_START(){
	LoopAlivePlayers(i){
		ScreenShake(i, _, g_Earthquake_Duration);
	}
}