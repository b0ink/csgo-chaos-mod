SETUP(effect_data effect){
	effect.Title = "Night Vision";
	effect.Duration = 30;
} 

START(){
	LoopAlivePlayers(i){
		GivePlayerItem(i, "item_nvgs");
		FakeClientCommand(i, "nightvision");
	}
}

RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
	}
}

public void Chaos_NightVision_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		GivePlayerItem(client, "item_nvgs");
		SetEntProp(client, Prop_Send, "m_bNightVisionOn", 1);
	}
}