public void Chaos_NoCrosshair(effect_data effect){
	effect.Title = "No Crosshair";
	effect.Duration = 30;
}

//TODO: Re-apply effect when player respawns
public void Chaos_NoCrosshair_START(){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}

public Action Chaos_NoCrosshair_RESET(bool HasTimerEnded){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
	}
}