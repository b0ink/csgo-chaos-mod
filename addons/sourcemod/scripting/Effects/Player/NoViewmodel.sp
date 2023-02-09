#pragma semicolon 1

public void Chaos_NoViewmodel(EffectData effect){
	effect.Title = "No Viewmodel";
	effect.Duration = 30;
}


public void Chaos_NoViewmodel_START(){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_bDrawViewmodel", false);
	}
}


public void Chaos_NoViewmodel_RESET(bool EndChaos){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_bDrawViewmodel", true);
	}
}


public void Chaos_NoViewmodel_OnPlayerSpawn(int client){
	SetEntProp(client, Prop_Send, "m_bDrawViewmodel", false);
}