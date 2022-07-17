public void Chaos_AlienModelKnife_START(){
	g_bKnifeFight++;
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
	if(g_bKnifeFight > 0) g_bKnifeFight--;
	LoopAlivePlayers(i){
		if(!HasMenuOpen(i)) ClientCommand(i, "slot1");
		SetEntPropFloat(i, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0);
		SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}

public bool Chaos_AlienModelKnife_Conditions(){
	return true;
}