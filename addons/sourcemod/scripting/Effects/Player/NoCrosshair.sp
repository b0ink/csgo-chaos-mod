public void Chaos_NoCrosshair_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
		}
	}
}

public Action Chaos_NoCrosshair_RESET(bool HasTimerEnded){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
		}
	}
}


public bool Chaos_NoCrosshair_HasNoDuration(){
	return false;
}

public bool Chaos_NoCrosshair_Conditions(){
	return true;
}