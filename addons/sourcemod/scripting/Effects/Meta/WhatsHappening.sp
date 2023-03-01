#pragma semicolon 1

bool Meta_WhatsHappening = false;

public void Chaos_Meta_WhatsHappening(EffectData effect){
	effect.Title = "What's Happening?";
	effect.Duration = 90;
	effect.IsMetaEffect = true;
}

public void Chaos_Meta_WhatsHappening_START(){
	Meta_WhatsHappening = true;
	CreateTimer(0.1, Timer_MetaClearAnnouncement);
}

public Action Timer_MetaClearAnnouncement(Handle timer){
	DisplayCenterTextToAll("What's happening !?");
	return Plugin_Stop;
}

public void Chaos_Meta_WhatsHappening_RESET(int ResetType){
	Meta_WhatsHappening = false;
}


public bool Chaos_Meta_WhatsHappening_Conditions(bool EffectRunRandomly){
	if(MegaChaosIsActive()) return false;
	return true;
}


public bool Meta_IsWhatsHappeningEnabled(){
	return Meta_WhatsHappening;
}