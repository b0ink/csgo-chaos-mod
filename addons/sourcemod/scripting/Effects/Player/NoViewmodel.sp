#define EFFECTNAME NoViewmodel

SETUP(effect_data effect){
	effect.Title = "No Viewmodel";
	effect.Duration = 30;
}


START(){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_bDrawViewmodel", false);
	}
}


RESET(bool HasTimerEnded){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_bDrawViewmodel", true);
	}
}


public void Chaos_NoViewmodel_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", false);
	}
}