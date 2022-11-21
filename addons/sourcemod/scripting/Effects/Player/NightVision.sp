public void Chaos_NightVision(effect_data effect){
	effect.Title = "Night Vision";
	effect.Duration = 30;
} 

//TODO: Re-apply effect when player respawns
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