#pragma semicolon 1


public void Chaos_Meta_HalfTimerSpeed(EffectData effect){
	effect.Title = "Half Timer Speed";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

public void Chaos_Meta_HalfTimerSpeed_START(){
	g_ChaosEffectInterval = g_cvChaosEffectInterval.IntValue / 2;
}

public void Chaos_Meta_HalfTimerSpeed_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		g_ChaosEffectInterval = g_cvChaosEffectInterval.IntValue;
	}
}


public bool Chaos_Meta_HalfTimerSpeed_Conditions(bool EffectRunRandomly){
	if(MegaChaosIsActive()) return false;
	return true;
}
