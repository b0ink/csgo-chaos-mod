public void Chaos_NightVision(effect_data effect){
	effect.Title = "Night Vision";
	effect.Duration = 30;
} 

public void Chaos_NightVision_START(){
	LoopAlivePlayers(i){
		GivePlayerItem(i, "item_nvgs");
		FakeClientCommand(i, "nightvision");
	}
}

public Action Chaos_NightVision_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
	}
}

public void Chaos_NightVision_OnPlayerSpawn(int client, bool EffectIsRunning){
	GivePlayerItem(client, "item_nvgs");
	SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
}