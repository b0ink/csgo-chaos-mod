#pragma semicolon 1

//https://forums.alliedmods.net/showthread.php?t=307674 thanks for prop_send 

public void Chaos_Juggernaut(EffectData effect){
	effect.Title = "Juggernauts";
	effect.Duration = 30;
	effect.AddFlag("playermodel");
}

public void Chaos_Juggernaut_START(){
	cvar("mp_weapons_allow_heavyassaultsuit", "1");
	LoopAlivePlayers(i){
		GivePlayerItem(i, "item_heavyassaultsuit");
	}
}

public void Chaos_Juggernaut_OnPlayerSpawn(int client){
	CreateTimer(0.5, Timer_SetJuggernaut, client);
}

Action Timer_SetJuggernaut(Handle timer, int client){
	GivePlayerItem(client, "item_heavyassaultsuit");
	return Plugin_Continue;
}

public void Chaos_Juggernaut_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		RestorePlayerModels();
		LoopAlivePlayers(i){
			SetEntProp(i, Prop_Send, "m_bHasHelmet", false);
			SetEntProp(i, Prop_Send, "m_bHasHeavyArmor", false);
			SetEntProp(i, Prop_Send, "m_bWearingSuit", false);
			if(GetEntProp(i, Prop_Send, "m_ArmorValue") > 100){
				SetEntProp(i, Prop_Data, "m_ArmorValue", 100);
			}
		}
	}
	ResetCvar("mp_weapons_allow_heavyassaultsuit", "0", "1");
}