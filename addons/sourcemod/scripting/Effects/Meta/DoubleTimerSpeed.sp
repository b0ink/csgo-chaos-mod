#pragma semicolon 1


public void Chaos_Meta_DoubleTimerSpeed(effect_data effect){
	effect.Title = "Double Timer Speed";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

public void Chaos_Meta_DoubleTimerSpeed_START(){
	g_ChaosEffectInterval = g_cvChaosEffectInterval.IntValue * 2;
}

public void Chaos_Meta_DoubleTimerSpeed_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		g_ChaosEffectInterval = g_cvChaosEffectInterval.IntValue;
	}
}


public bool Chaos_Meta_DoubleTimerSpeed_Conditions(bool EffectRunRandomly){
	if(MegaChaosIsActive()) return false;
	return true;
}
