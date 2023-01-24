public void Chaos_ExoJump(effect_data effect){
	effect.Title = "ExoJump Boots";
	effect.Duration = 30;
}

public void Chaos_ExoJump_START(){
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_passiveItems", 1, 1, 1);
	}
}

public void Chaos_ExoJump_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			SetEntProp(i, Prop_Send, "m_passiveItems", 0, 1, 1);
		}
	}
}

public void Chaos_ExoJump_OnPlayerSpawn(int client, bool EffectIsRunning){
	
	if(EffectIsRunning){
		SetEntProp(client, Prop_Send, "m_passiveItems", 1, 1, 1);
	}
}