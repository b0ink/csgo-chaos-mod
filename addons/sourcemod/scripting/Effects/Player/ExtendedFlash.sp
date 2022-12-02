bool ExtendedFlash = false;
public void Chaos_ExtendedFlash(effect_data effect){
	effect.Title = "Extended Flashbang Effect";
	effect.Duration = 30;
}

public void Chaos_ExtendedFlash_INIT(){
	HookEvent("player_blind", Chaos_ExtendedFlash_Event_PlayerBlind);
}

public void Chaos_ExtendedFlash_START(){
	ExtendedFlash = true;
}

public void Chaos_ExtendedFlash_RESET(){
	ExtendedFlash = false;
}

public void Chaos_ExtendedFlash_Event_PlayerBlind(Event event, char[] name, bool dbc){
	if(!ExtendedFlash) return;

	int client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	float duration = GetEventFloat(event, "blind_duration", 0.0);
	SetEntPropFloat(client, Prop_Send, "m_flFlashDuration", duration + 4.0, 0);
}