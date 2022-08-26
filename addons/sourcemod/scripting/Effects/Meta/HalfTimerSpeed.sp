
public void Chaos_Meta_HalfTimerSpeed(effect_data effect){
	effect.meta = true;
}

float HalfTimerSpeed_Original;
public void Chaos_Meta_HalfTimerSpeed_START(){
	HalfTimerSpeed_Original = g_fChaos_EffectInterval;
	g_fChaos_EffectInterval = g_fChaos_EffectInterval / 2;
}

public void Chaos_Meta_HalfTimerSpeed_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		g_fChaos_EffectInterval = HalfTimerSpeed_Original;
	}
}


public bool Chaos_Meta_HalfTimerSpeed_Conditions(){
	if(g_bMegaChaos) return false;
	return true;
}
