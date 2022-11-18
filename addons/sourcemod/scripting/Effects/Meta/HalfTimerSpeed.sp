
public void Chaos_Meta_HalfTimerSpeed(effect_data effect){
	effect.Title = "Half Timer Speed";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

public void Chaos_Meta_HalfTimerSpeed_START(){
	if((g_cvChaosEffectInterval.FloatValue / 2) < 5 ){
		//TODO: ChooseEffect won't like less than 5 second timer, could change in the future
		g_ChaosEffectInterval = 5;
	}
	g_ChaosEffectInterval = g_cvChaosEffectInterval.IntValue / 2;
}

public void Chaos_Meta_HalfTimerSpeed_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		g_ChaosEffectInterval = g_cvChaosEffectInterval.IntValue;
	}
}


public bool Chaos_Meta_HalfTimerSpeed_Conditions(){
	if(g_bMegaChaosIsActive) return false;
	return true;
}
