#define EFFECTNAME HalfTimerSpeed


SETUP(effect_data effect){
	effect.Title = "Half Timer Speed";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

START(){
	g_ChaosEffectInterval = g_cvChaosEffectInterval.IntValue / 2;
}

RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		g_ChaosEffectInterval = g_cvChaosEffectInterval.IntValue;
	}
}


CONDITIONS(){
	if(g_bMegaChaosIsActive) return false;
	return true;
}
