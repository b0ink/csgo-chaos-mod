#pragma semicolon 1

public void Chaos_AlienModelKnife(EffectData effect){
	effect.Title = "Alien Knife Fight";
	effect.Duration = 30;
}

public void Chaos_AlienModelKnife_START(){
	HookBlockAllGuns();

	LoopAlivePlayers(i){
		MakeAlien(i);
	}
}

public void Chaos_AlienModelKnife_OnPlayerSpawn(int client){
	HookBlockAllGuns(client);
	MakeAlien(client);
}


//TODO: this sucks, this was originally supposed to be the small players -> might as well bring in an alien player model now
void MakeAlien(int client){
	//!this makes hitboxes tiny and innacurate, but knives work fine
	SetEntPropFloat(client, Prop_Send, "m_flModelScale", 0.5);
	// SetEntProp(i, Prop_Send, "m_ScaleType", 5);
	SetEntPropFloat(client, Prop_Send, "m_flStepSize", 18.0*0.55);
	SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 2.0);
	SwitchToKnife(client);
}





public void Chaos_AlienModelKnife_RESET(int ResetType){
	UnhookBlockAllGuns(ResetType);

	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0);
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}