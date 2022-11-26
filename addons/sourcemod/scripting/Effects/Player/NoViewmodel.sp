public void Chaos_NoViewmodel(effect_data effect){
	effect.Title = "No Viewmodel";
	effect.Duration = 30;
}


public void Chaos_NoViewmodel_START(){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_bDrawViewmodel", false);
	}
}


public Action Chaos_NoViewmodel_RESET(bool EndChaos){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_bDrawViewmodel", true);
	}
}


public void Chaos_NoViewmodel_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", false);
	}
}