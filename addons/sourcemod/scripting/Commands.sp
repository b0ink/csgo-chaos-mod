void RegisterCommands(){
	RegAdminCmd("chaos_refreshconfig", 	Command_RefreshConfig, 	ADMFLAG_GENERIC);
	RegAdminCmd("chaos_debug", 			Command_ChaosDebug, 	ADMFLAG_GENERIC);
	RegAdminCmd("chaos_help", 			Command_ChaosHelp, 		ADMFLAG_GENERIC);

	RegAdminCmd("sm_chaos", 			Command_MainMenu,		ADMFLAG_GENERIC);
	RegAdminCmd("sm_effect", 			Command_NewChaosEffect,	ADMFLAG_GENERIC);
	RegAdminCmd("sm_startchaos", 		Command_StartChaos, 	ADMFLAG_GENERIC);
	RegAdminCmd("sm_stopchaos", 		Command_StopChaos, 		ADMFLAG_GENERIC);
}

// Handle Possible_Chaos_Effects = INVALID_HANDLE;
ArrayList Possible_Chaos_Effects;

public Action Command_MainMenu(int client, int args){
	ShowMenu_Main(client);

	return Plugin_Handled;
}

public Action Command_NewChaosEffect(int client, int args){
	if(args > 1){
		ReplyToCommand(client, "Usage: sm_chaos <Effect Name (optional)>");
		return Plugin_Handled;
	}
	char effectName[64];
	GetCmdArg(1, effectName, sizeof(effectName));

	if(!g_bChaos_Enabled){
		ReplyToCommand(client, "[Chaos] Re-enable !chaos to run effects.");
		return Plugin_Handled;
	}

	g_bDisableRetryEffect = true;
	if(g_bCanSpawnEffect){
		if(args >= 1){
			if(strlen(effectName) >=3){
					PoolChaosEffects(effectName);
					if(Possible_Chaos_Effects.Length <= 0){
						//TODO: show if the chas is enabled or not
						ReplyToCommand(client, "[Chaos] No effects found, or the desired effect is currently disabled.");
						return Plugin_Handled;
					}else if(Possible_Chaos_Effects.Length == 1){
						// g_sCustomEffect = g_sSelectedChaosEffect;
						effect foo;
						Possible_Chaos_Effects.GetArray (0, foo, sizeof(foo));
						g_sCustomEffect = foo.config_name;
						ChooseEffect(null, true);
					}else{
						ReplyToCommand(client, "[Chaos] Multiple effects found under the term '%s'", effectName);
						ShowMenu_Effects(client);
					}
			}else{
				ReplyToCommand(client, "[Chaos] Please provide atleast 3 characters."); //TODO:, filter around random characters (NOT UNDERSCORES)
				return Plugin_Handled;
			}
		}else{
			ShowMenu_Effects(client, true);
		}
	}else{
		ReplyToCommand(client, "[Chaos] You can't spawn new effects right now, please wait until the round starts.");
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

	ResetChaos();

	g_cvChaosEnabled.SetString("0", true, true);
	AnnounceChaos("Chaos is Disabled!", -2.0, true);
	return Plugin_Handled;
}

public Action Command_StartChaos(int client, int args){
	if(g_NewEffect_Timer == INVALID_HANDLE){
		g_cvChaosEnabled.SetString("1", true, true);

		g_sCustomEffect = "";
		//start the timer but dont spawn effect.
		// CreateTimer(0.1, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
		StopTimer(g_NewEffect_Timer);
		g_NewEffect_Timer = CreateTimer(15.0, ChooseEffect);
		if(g_DynamicChannel){
			Timer_Display(null, RoundToFloor(15.0));
		}
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
	OnConfigsExecuted();

	return Plugin_Handled;
}


public Action Command_ChaosHelp(int client, int args){
	PrintToConsole(client, "todo...");
	return Plugin_Handled;
}
