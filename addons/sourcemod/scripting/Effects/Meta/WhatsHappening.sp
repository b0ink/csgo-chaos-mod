bool Meta_WhatsHappening = false;

public void Chaos_Meta_WhatsHappening(effect_data effect){
	effect.title = "What's Happening?";
	effect.duration = 90;
	effect.meta = true;
}

public void Chaos_Meta_WhatsHappening_START(){
	Meta_WhatsHappening = true;
}

public void Chaos_Meta_WhatsHappening_RESET(bool HasTimerEnded){
	Meta_WhatsHappening = false;
}


public bool Chaos_Meta_WhatsHappening_Conditions(){
	if(g_bMegaChaos) return false;
	return true;
}


public bool Meta_IsWhatsHappeningEnabled(){
	return Meta_WhatsHappening;
}