
//TODO: Re-apply effect when player respawns

public void Chaos_AlienModelKnife(effect_data effect){
	effect.Title = "Alien Knife Fight";
	effect.Duration = 30;
}

public void Chaos_AlienModelKnife_START(){
	HookBlockAllGuns();

	//hitboxes are tiny, but knives work fine
	LoopAlivePlayers(i){
		SetEntPropFloat(i, Prop_Send, "m_flModelScale", 0.5);
		// SetEntProp(i, Prop_Send, "m_ScaleType", 5);
		SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0*0.55);
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 2.0);
		FakeClientCommand(i, "use weapon_knife");
	}
}



public Action Chaos_AlienModelKnife_RESET(bool HasTimerEnded){
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