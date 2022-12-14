#define EFFECTNAME MegaChaos

SETUP(effect_data effect){
	effect.Title = "Mega Chaos";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IsMetaEffect = true;
	// effect.IncompatibleWith("Chaos_EffectName");
}

START(){
	g_bMegaChaosIsActive = true; 

	AnnounceChaos(GetChaosTitle("Chaos_Meta_Mega"), 15.0, false, true);

	g_bDisableRetryEffect = false;
	CreateTimer(0.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.5, Timer_CompleteMegaChaos);
}

public Action Timer_CompleteMegaChaos(Handle timer){
	AnnounceChaos(GetChaosTitle("Chaos_Meta_Mega"), -1.0, true, true);
	g_bMegaChaosIsActive = false;
}

CONDITIONS(){
	if(g_bMegaChaosIsActive) return false;
	return true;
}
