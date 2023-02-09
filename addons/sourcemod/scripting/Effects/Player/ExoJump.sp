#pragma semicolon 1

public void Chaos_ExoJump(EffectData effect){
	effect.Title = "ExoJump Boots";
	effect.Duration = 30;
}

public void Chaos_ExoJump_START(){
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_passiveItems", 1, 1, 1);
	}
}

public void Chaos_ExoJump_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			SetEntProp(i, Prop_Send, "m_passiveItems", 0, 1, 1);
		}
	}
}

public void Chaos_ExoJump_OnPlayerSpawn(int client){
	SetEntProp(client, Prop_Send, "m_passiveItems", 1, 1, 1);
}