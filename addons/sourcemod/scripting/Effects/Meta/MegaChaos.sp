



public void Chaos_MEGACHAOS(){
	if(ClearChaos()){	}
	if(NotDecidingChaos("Chaos_MEGACHAOS")) return;
	
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
	AnnounceChaos(GetChaosTitle("Chaos_MEGACHAOS"), -1.0);
	g_bMegaChaos = false;
}


public void Chaos_MEGACHAOS_START(){
	
}