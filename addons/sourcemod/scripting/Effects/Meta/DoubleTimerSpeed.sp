
public void Chaos_Meta_DoubleTimerSpeed(effect_data effect){
	effect.meta = true;
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
	if(g_bMegaChaos) return false;
	return true;
}
