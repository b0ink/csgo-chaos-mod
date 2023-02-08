#pragma semicolon 1

#define HIDEHUD_CROSSHAIR           (1 << 8)	// Hide crosshairs

public void Chaos_NoCrosshair(effect_data effect){
	effect.Title = "No Crosshair";
	effect.Duration = 30;
}

public void Chaos_NoCrosshair_START(){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}

public void Chaos_NoCrosshair_RESET(int ResetType){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iHideHUD", 0);
	}
}

public void Chaos_NoCrosshair_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR);
	}
}