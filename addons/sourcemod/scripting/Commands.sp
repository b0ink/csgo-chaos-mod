#pragma semicolon 1

void RegisterCommands(){
	RegAdminCmd("chaos_debug", 			Command_ChaosDebug, 	ADMFLAG_GENERIC);
	RegAdminCmd("chaos_help", 			Command_ChaosHelp, 		ADMFLAG_GENERIC);

	RegConsoleCmd("sm_chaos", 			Command_MainMenu);	
	RegAdminCmd("sm_effect", 			Command_NewChaosEffect,	ADMFLAG_GENERIC);
	RegAdminCmd("sm_randomeffect", 		Command_TriggerRandomEffect,	ADMFLAG_GENERIC);

	RegAdminCmd("sm_startchaos", 		Command_StartChaos, 	ADMFLAG_GENERIC);
	RegAdminCmd("sm_stopchaos", 		Command_StopChaos, 		ADMFLAG_GENERIC);
	
	RegAdminCmd("chaos_version", 		Command_Version, 		ADMFLAG_ROOT);
	RegisterTwitchCommands();
}

public Action Command_Version(int client, int args){
	ReplyToCommand(client, ">>%s<<", PLUGIN_VERSION);
	return Plugin_Handled;
}

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

	if(!g_cvChaosEnabled.BoolValue){
		ReplyToCommand(client, "[Chaos] Re-enable !chaos to run effects.");
		return Plugin_Handled;
	}

	if(CanSpawnNewEffect()){
		if(args >= 1){
			if(strlen(effectName) >=3){
					PoolChaosEffects(effectName);
					if(PossibleChaosEffects.Length <= 0){
						ReplyToCommand(client, "[Chaos] No effects found, or the desired effect is currently disabled.");
						return Plugin_Handled;
					}else{
						if(PossibleChaosEffects.Length > 1){
							ReplyToCommand(client, "[Chaos] Multiple effects found under the term '%s'", effectName);
						}
						ShowMenu_Effects(client);
					}
			}else{
				ReplyToCommand(client, "[Chaos] Please provide atleast 3 characters.");
				return Plugin_Handled;
			}
		}else{
			ShowMenu_Effects(client, true);
		}
	}else{
		ReplyToCommand(client, "[Chaos] You can't spawn new effects right now, please wait until the round starts.");
		return Plugin_Handled;
	}

	g_sSelectedChaosEffect = "";
	return Plugin_Handled;
}


public Action Command_TriggerRandomEffect(int client, int args){
	if(!g_cvChaosEnabled.BoolValue){
		if(IsValidClient(client)){
			ReplyToCommand(client, "[Chaos] Re-enable !chaos to run effects.");
		}else{
			PrintToServer("[Chaos] Re-enable !chaos to run effects.");
		}
		return Plugin_Handled;
	}

	if(CanSpawnNewEffect()){
		ChooseEffect(null, true);
	}else{
		if(IsValidClient(client)){
			ReplyToCommand(client, "[Chaos] You can't spawn new effects right now, please wait until the round starts.");
		}else{
			PrintToServer("[Chaos] You can't spawn new effects right now, please wait until the round starts.");
		}
	}

	return Plugin_Handled;
}

public Action Command_StopChaos(int client, int args){
	g_cvChaosEnabled.BoolValue = false;

	ResetChaos();

	g_cvChaosEnabled.SetString("0", true, true);
	Update_Convar_Config();

	AnnounceChaos("Chaos is Disabled!", -2.0, true);
	return Plugin_Handled;
}

public Action Command_StartChaos(int client, int args){
	if(g_NewEffect_Timer == INVALID_HANDLE){
		g_cvChaosEnabled.SetString("1", true, true);
		Update_Convar_Config();

		g_sForceCustomEffect = "";
		//start the timer but dont spawn effect.
		// CreateTimer(0.1, ChooseEffect, true, TIMER_FLAG_NO_MAPCHANGE);
		StopTimer(g_NewEffect_Timer);
		g_NewEffect_Timer = CreateTimer(15.0, ChooseEffect);
		Timer_Display(null, g_ChaosEffectInterval);
		AnnounceChaos("Chaos is Enabled!", -2.0);
	}else{
		PrintToChat(client, "Chaos is already running!");
	}
	g_cvChaosEnabled.BoolValue = true;
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


public Action Command_ChaosHelp(int client, int args){
	PrintToConsole(client, "todo...");
	return Plugin_Handled;
}
