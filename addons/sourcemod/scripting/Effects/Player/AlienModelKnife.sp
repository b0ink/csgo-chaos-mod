#pragma semicolon 1

public void Chaos_AlienModelKnife(effect_data effect){
	effect.Title = "Alien Knife Fight";
	effect.Duration = 30;
}

public void Chaos_AlienModelKnife_START(){
	HookBlockAllGuns();

	LoopAlivePlayers(i){
		MakeAlien(i);
	}
}

public void Chaos_AlienModelKnife_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		HookBlockAllGuns(client);
		MakeAlien(client);
	}
}

void MakeAlien(int client){
	//!this makes hitboxes tiny and innacurate, but knives work fine
	SetEntPropFloat(client, Prop_Send, "m_flModelScale", 0.5);
	// SetEntProp(i, Prop_Send, "m_ScaleType", 5);
	SetEntPropFloat(client, Prop_Send, "m_flStepSize", 18.0*0.55);
	SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 2.0);
	FakeClientCommand(client, "use weapon_knife");
}





public void Chaos_AlienModelKnife_RESET(bool HasTimerEnded){
	UnhookBlockAllGuns();

	LoopAlivePlayers(i){
		if(HasTimerEnded){
			if(!HasMenuOpen(i)) ClientCommand(i, "slot1");
		}
		SetEntPropFloat(i, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0);
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}