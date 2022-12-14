bool Meta_WhatsHappening = false;

SETUP(effect_data effect){
	effect.Title = "What's Happening?";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

START(){
	Meta_WhatsHappening = true;
}

RESET(bool HasTimerEnded){
	Meta_WhatsHappening = false;
}


CONDITIONS(){
	if(g_bMegaChaosIsActive) return false;
	return true;
}


public bool Meta_IsWhatsHappeningEnabled(){
	return Meta_WhatsHappening;
}