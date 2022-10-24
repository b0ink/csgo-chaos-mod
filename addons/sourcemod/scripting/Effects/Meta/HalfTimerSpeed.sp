
public void Chaos_Meta_HalfTimerSpeed(effect_data effect){
	effect.Title = "Half Timer Speed";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

float HalfTimerSpeed_Original;
public void Chaos_Meta_HalfTimerSpeed_START(){
	HalfTimerSpeed_Original = g_cvChaosEffectInterval.FloatValue;
	if((g_cvChaosEffectInterval.FloatValue / 2) < 5 ){
		//TODO: ChooseEffect won't like less than 5 second timer, could change in the future
		g_cvChaosEffectInterval.FloatValue = 5.0;
	}
	g_cvChaosEffectInterval.FloatValue = g_cvChaosEffectInterval.FloatValue / 2;
}

public void Chaos_Meta_HalfTimerSpeed_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		g_cvChaosEffectInterval.FloatValue = HalfTimerSpeed_Original;
	}
}


public bool Chaos_Meta_HalfTimerSpeed_Conditions(){
	if(g_bMegaChaosIsActive) return false;
	return true;
}
