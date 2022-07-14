char g_OriginalModels_Jugg[MAXPLAYERS + 1][PLATFORM_MAX_PATH+1];
//https://forums.alliedmods.net/showthread.php?t=307674 thanks for prop_send 
bool g_bSetJuggernaut = false;

public void Chaos_Juggernaut_START(){
	cvar("mp_weapons_allow_heavyassaultsuit", "1");
	g_bSetJuggernaut = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientModel(i, g_OriginalModels_Jugg[i], sizeof(g_OriginalModels_Jugg[]));
			GivePlayerItem(i, "item_heavyassaultsuit");
		}
	}
}

public Action Chaos_Juggernaut_RESET(bool EndChaos){
	if(g_bSetJuggernaut){
		g_bSetJuggernaut = false;
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				SetEntProp(i, Prop_Send, "m_bHasHelmet", false);
				SetEntProp(i, Prop_Send, "m_bHasHeavyArmor", false);
				SetEntProp(i, Prop_Send, "m_bWearingSuit", false);
				if(GetEntProp(i, Prop_Send, "m_ArmorValue") > 100){
					SetEntProp(i, Prop_Data, "m_ArmorValue", 100);
				}
				if(g_OriginalModels_Jugg[i][0]){
					SetEntityModel(i, g_OriginalModels_Jugg[i]);
					g_OriginalModels_Jugg[i] = "";
				}
			}
		}
	}
	ResetCvar("mp_weapons_allow_heavyassaultsuit", "0", "1");
}


public bool Chaos_Juggernaut_HasNoDuration(){
	return false;
}

public bool Chaos_Juggernaut_Conditions(){
	return true;
}