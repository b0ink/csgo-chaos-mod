#pragma semicolon 1

bool Meta_WhatsHappening = false;

public void Chaos_Meta_WhatsHappening(effect_data effect){
	effect.Title = "What's Happening?";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

public void Chaos_Meta_WhatsHappening_START(){
	Meta_WhatsHappening = true;
}

public void Chaos_Meta_WhatsHappening_RESET(bool HasTimerEnded){
	Meta_WhatsHappening = false;
}


public bool Chaos_Meta_WhatsHappening_Conditions(bool EffectRunRandomly){
	if(MegaChaosIsActive()) return false;
	return true;
}


public bool Meta_IsWhatsHappeningEnabled(){
	return Meta_WhatsHappening;
}