#define EFFECTNAME Juggernaut

char g_OriginalModels_Jugg[MAXPLAYERS + 1][PLATFORM_MAX_PATH+1];
//https://forums.alliedmods.net/showthread.php?t=307674 thanks for prop_send 
bool g_bSetJuggernaut = false;

SETUP(effect_data effect){
	effect.Title = "Juggernauts";
	effect.Duration = 30;
}

START(){
	cvar("mp_weapons_allow_heavyassaultsuit", "1");
	g_bSetJuggernaut = true;
	LoopAlivePlayers(i){
		GetClientModel(i, g_OriginalModels_Jugg[i], sizeof(g_OriginalModels_Jugg[]));
		GivePlayerItem(i, "item_heavyassaultsuit");
	}
}

public void Chaos_Juggernaut_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		CreateTimer(0.5, Timer_SetJuggernaut, client);
	}
}

public Action Timer_SetJuggernaut(Handle timer, int client){
	GetClientModel(client, g_OriginalModels_Jugg[client], sizeof(g_OriginalModels_Jugg[]));
	GivePlayerItem(client, "item_heavyassaultsuit");
}

RESET(bool HasTimerEnded){
	if(g_bSetJuggernaut){
		g_bSetJuggernaut = false;
		LoopAlivePlayers(i){
			SetEntProp(i, Prop_Send, "m_bHasHelmet", false);
			SetEntProp(i, Prop_Send, "m_bHasHeavyArmor", false);
			SetEntProp(i, Prop_Send, "m_bWearingSuit", false);
			if(GetEntProp(i, Prop_Send, "m_ArmorValue") > 100){
				SetEntProp(i, Prop_Data, "m_ArmorValue", 100);
			}
			if(g_OriginalModels_Jugg[i][0] != '\0'){
				SetEntityModel(i, g_OriginalModels_Jugg[i]);
				g_OriginalModels_Jugg[i] = "";
			}	
		}
	}
	ResetCvar("mp_weapons_allow_heavyassaultsuit", "0", "1");
}