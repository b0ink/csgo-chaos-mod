#pragma semicolon 1

bool 	g_bMegaChaosIsActive = false;
Handle	MetaMegaDelayTimer;

bool MegaChaosIsActive(){
	return g_bMegaChaosIsActive;
}

public void Chaos_Meta_Mega(EffectData effect){
	effect.Title = "Mega Chaos";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IsMetaEffect = true;

	HookEvent("round_end", Chaos_Meta_Mega_Event_RoundEnd);
}

public void Chaos_Meta_Mega_OnMapStart(){
	MetaMegaDelayTimer = INVALID_HANDLE;
}

public void Chaos_Meta_Mega_Event_RoundEnd(Event event, char[] name, bool dontBroadcast){
	StopTimer(MetaMegaDelayTimer);
}

void StartMegaChaosDelay(){
	StopTimer(MetaMegaDelayTimer);
	CreateTimer(FindConVar("mp_freezetime").FloatValue + GetRandomFloat(5.0, 30.0), Timer_TriggerMegaChaos, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_TriggerMegaChaos(Handle timer){
	MetaMegaDelayTimer = INVALID_HANDLE;
	g_sForceCustomEffect = "Chaos_Meta_Mega";
	ChooseEffect(null, true);
	MetaEffectIndex++;
	return Plugin_Stop;
}

public void Chaos_Meta_Mega_START(){
	g_bMegaChaosIsActive = true; 

	AnnounceChaos(GetChaosTitle("Chaos_Meta_Mega"), 15.0, false, true);

	CreateTimer(0.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(1.5, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(2.0, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);

	CreateTimer(2.1, Timer_CompleteMegaChaos);
}

Action Timer_CompleteMegaChaos(Handle timer){
	// AnnounceChaos(GetChaosTitle("Chaos_Meta_Mega"), -1.0, true, true);
	g_bMegaChaosIsActive = false;
	return Plugin_Continue;
}

public bool Chaos_Meta_Mega_Conditions(bool EffectRunRandomly){
	if(MegaChaosIsActive()) return false;
	return true;
}
