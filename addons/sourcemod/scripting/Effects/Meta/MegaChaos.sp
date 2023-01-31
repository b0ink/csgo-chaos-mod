#pragma semicolon 1

bool 	g_bMegaChaosIsActive = false;

bool MegaChaosIsActive(){
	return g_bMegaChaosIsActive;
}

public void Chaos_Meta_Mega(effect_data effect){
	effect.Title = "Mega Chaos";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IsMetaEffect = true;
	// effect.IncompatibleWith("Chaos_EffectName");
}

public void Chaos_Meta_Mega_START(){
	g_bMegaChaosIsActive = true; 

	AnnounceChaos(GetChaosTitle("Chaos_Meta_Mega"), 15.0, false, true);

	CreateTimer(0.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);

	CreateTimer(5.1, Timer_CompleteMegaChaos);
}

public Action Timer_CompleteMegaChaos(Handle timer){
	// AnnounceChaos(GetChaosTitle("Chaos_Meta_Mega"), -1.0, true, true);
	g_bMegaChaosIsActive = false;
	return Plugin_Continue;
}

public bool Chaos_Meta_Mega_Conditions(bool EffectRunRandomly){
	if(MegaChaosIsActive()) return false;
	return true;
}
