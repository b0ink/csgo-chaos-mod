SETUP(effect_data effect){
	effect.Title = "No Crosshair";
	effect.Duration = 30;
}

START(){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}

RESET(bool HasTimerEnded){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
	}
}

public void Chaos_NoCrosshair_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}