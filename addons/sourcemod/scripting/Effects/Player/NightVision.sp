#pragma semicolon 1

public void Chaos_NightVision(effect_data effect){
	effect.Title = "Night Vision";
	effect.Duration = 30;
	effect.AddAlias("Visual");
} 

public void Chaos_NightVision_START(){
	LoopAlivePlayers(i){
		GivePlayerItem(i, "item_nvgs");
		FakeClientCommand(i, "nightvision");
	}
}

public void Chaos_NightVision_RESET(int ResetType){
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
	}
}

public void Chaos_NightVision_OnPlayerSpawn(int client){
	GivePlayerItem(client, "item_nvgs");
	SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
}