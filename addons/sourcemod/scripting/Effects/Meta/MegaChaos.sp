//TODO: remove Meta chaos from the "Possible Chaos Effects" pool and run meta effects as their own random chance
//? 		Whether thats on an interval, eg. every 25 - 50 effects run a meta effect, or run a 1 in 100 chance every effect to run a meta


public void Chaos_MegaChaos(effect_data effect){
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_EffectName");
}

public void Chaos_MEGACHAOS_START(){
	g_bMegaChaos = true; 

	AnnounceChaos(GetChaosTitle("Chaos_MEGACHAOS"), -1.0, true, true);

	g_bDisableRetryEffect = false;
	CreateTimer(0.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.5, Timer_CompleteMegaChaos);
}

public Action Timer_CompleteMegaChaos(Handle timer){
	AnnounceChaos(GetChaosTitle("Chaos_MEGACHAOS"), -1.0, true, true);
	g_bMegaChaos = false;
}

public bool Chaos_MEGACHAOS_Conditions(){
	if(g_bMegaChaos) return false;
	return true;
}
