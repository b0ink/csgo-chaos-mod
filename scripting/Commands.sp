
//todo: multple effects still spawn if you do "!chaos aut", (funky, autoplant et, juggernaut)
public Action Command_NewChaosEffect(int client, int args){
	if(args > 1){
		ReplyToCommand(client, "Usage: sm_chaos <Effect Name (optional)>");
		return Plugin_Handled;
	}
	char effectName[64];
	GetCmdArg(1, effectName, sizeof(effectName));

	g_bDisableRetryEffect = true;
	if(g_bCanSpawnEffect){
		if(args == 1){
			if(strlen(effectName) >=3){
					g_sSelectedChaosEffect = effectName;
					g_bDecidingChaos = true;
					g_bClearChaos = false;
					Chaos();
				
			}else{
				ReplyToCommand(client, "Please provide atleast 3 characters."); //todo, filter around random characters (NOT UNDERSCORES)
				return Plugin_Handled;
			}
		}else{
			ChooseEffect(null, true);
		}
	}else{
		ReplyToCommand(client, "You can't spawn new effects right now, please wait until the round starts.");
		return Plugin_Handled;
	}

	CreateTimer(1.0, Timer_ReEnableRetries);
	g_sSelectedChaosEffect = "";
	return Plugin_Handled;
}
public Action Timer_ReEnableRetries(Handle timer){
	g_bDisableRetryEffect = false;
}

public Action Command_StopChaos(int client, int args){
	g_bChaos_Enabled = false;
	StopTimer(g_NewEffect_Timer);
	g_bClearChaos = true;
	g_bDecidingChaos = false;
	Chaos(true); //count and reset all chaos
	AnnounceChaos("Chaos is Disabled!", -2.0, true);
	return Plugin_Handled;
}

public Action Command_StartChaos(int client, int args){
	if(g_NewEffect_Timer == INVALID_HANDLE){
		g_bClearChaos = true;
		g_bDecidingChaos = false;
		Chaos();
		CreateTimer(0.1, ChooseEffect, _, TIMER_FLAG_NO_MAPCHANGE);
		AnnounceChaos("Chaos is Enabled!", -2.0);
	}else{
		PrintToChat(client, "Chaos is already running!");
	}
	g_bChaos_Enabled = true;
	// StopTimer(g_NewEffect_Timer);
	return Plugin_Handled;
}

bool g_bChaos_Debug = false;
public Action Command_ChaosDebug(int client, int args){
	if(!g_bChaos_Debug){
		cvar("mp_freezetime", "2");
		cvar("mp_round_restart_delay", "2");
	}else{
		cvar("mp_freezetime", "15");
		cvar("mp_round_restart_delay", "7");
	}
	g_bChaos_Debug = !g_bChaos_Debug;
	return Plugin_Handled;
}

public Action Command_RefreshConfig(int client, int args){
	ParseChaosEffects();
	ParseMapCoordinates();

	return Plugin_Handled;
}


public Action Command_ChaosHelp(int client, int args){
	PrintToConsole(client, "todo...");
	return Plugin_Handled;
}
