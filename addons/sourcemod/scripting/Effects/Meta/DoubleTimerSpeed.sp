
public void Chaos_Meta_DoubleTimerSpeed(effect_data effect){
	effect.Title = "Double Timer Speed";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

float DoubleTimerSpeed_Original;
public void Chaos_Meta_DoubleTimerSpeed_START(){
	DoubleTimerSpeed_Original = g_fChaos_EffectInterval;
	g_fChaos_EffectInterval = g_fChaos_EffectInterval * 2;
}

public void Chaos_Meta_DoubleTimerSpeed_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		g_fChaos_EffectInterval = DoubleTimerSpeed_Original;
	}
}


public bool Chaos_Meta_DoubleTimerSpeed_Conditions(){
	if(g_bMegaChaosIsActive) return false;
	return true;
}
