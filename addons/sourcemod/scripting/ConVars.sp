ConVar 	g_cvChaosEnabled;
bool        g_bChaos_Enabled = true;

ConVar 	g_cvChaosEffectInterval;
float       g_fChaos_EffectInterval = 15.0;

ConVar 	g_cvChaosRepeating;
bool        g_bChaos_Repeating = true;

ConVar 	g_cvChaosOverrideDuration;
float       g_fChaos_OverwriteDuration = -1.0;

ConVar 	g_cvChaosTwitchEnabled;
bool       g_bChaos_TwitchEnabled = false;

ConVar 	g_cvChaosNextEffect;
char 		g_sChaosNextEffect[MAX_NAME_LENGTH];

Handle g_SavedConvars = INVALID_HANDLE;

void cvar(char[] cvarname, char[] newValue, bool updateConfig = true, char[] expectedPreviousValue = ""){
	if(!cvarname[0]) return;

	ConVar hndl = FindConVar(cvarname);
	if (hndl != null){

		char oldValue[64];
		IntToString(hndl.IntValue, oldValue, sizeof(oldValue));
		if(updateConfig){
			//DONT OVERWRITE
			if(FindStringInArray(g_SavedConvars, cvarname) == -1){
				UpdateConfig(-1, "Chaos_OriginalConvars", "ConVars", "CVARS", cvarname, oldValue);
				PushArrayString(g_SavedConvars, cvarname);
			}
		}
		if(expectedPreviousValue[0]){
			if(StrEqual(oldValue, expectedPreviousValue, false)){
				hndl.SetString(newValue, true);
			}
		}else{
			hndl.SetString(newValue, true);
		}
	}
}


void ResetCvar(char[] cvarName = "", char[] backupValue = "", char[] expectedPreviousValue = ""){

	//when resetting cvar
	/*
		-> check if manual convar was given,
		-> if the convar was saved in originalconvars.cfg,  we want to take that value
			-> BUT only change it if the current value is equal to the previous expected value
	 */
	
	char filePath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, filePath, sizeof(filePath), "configs/Chaos/Chaos_OriginalConvars.cfg");
	if(!FileExists(filePath)){
		cvar(cvarName, backupValue, false, expectedPreviousValue);
		return;
	}

	KeyValues kvConfig = new KeyValues("ConVars");
	if(!kvConfig.ImportFromFile(filePath)){
		Log("Unable to parse Key Values file %s", filePath);
		cvar(cvarName, backupValue, false, expectedPreviousValue);
		return;
	}

	if(!kvConfig.JumpToKey("CVARS")){
		Log("Unable to find CVARS Key from %s", filePath);
		cvar(cvarName, backupValue, false, expectedPreviousValue);
		return;
	}

	if(!kvConfig.GotoFirstSubKey(false)){
		Log("Unable to find 'ConVars' Section in file %s", filePath);
		cvar(cvarName, backupValue, false, expectedPreviousValue);
		return;
	}
	//if cvar provided, only change that one,
	bool changed = false;
	do{
		char convarName[64];
		kvConfig.GetSectionName(convarName, sizeof(convarName));
		char convarValue[64];
		kvConfig.GetString(NULL_STRING, convarValue, sizeof(convarValue));
		// PrintToChatAll("convar: %s value: %s", convarName, convarValue);

		if(cvarName[0]){
			if(StrEqual(convarName, cvarName, false)){
				cvar(cvarName, convarValue, false);
				changed = true;
			}
		}else{
			cvar(convarName, convarValue, false);
		} 

	} while(kvConfig.GotoNextKey(false));
	if(!changed && cvarName[0]){
		cvar(cvarName, backupValue, false, expectedPreviousValue);
		// cvar(cvarName, backupValue, false);
	}
	if(!cvarName[0]){
		ClearArray(g_SavedConvars);
		DeleteFile(filePath);
	}
}

void CreateConVars(){
	CreateConVar("csgo_chaos_mod_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);

	g_cvChaosEnabled = CreateConVar("sm_chaos_enabled", "1", "Sets whether the Chaos plugin is enabled", _, true, 0.0, true, 1.0);
	g_cvChaosEffectInterval = CreateConVar("sm_chaos_interval", "15.0", "Sets the interval for Chaos effects to run", _, true, 5.0, true, 60.0);
	g_cvChaosRepeating = CreateConVar("sm_chaos_repeating", "1", "Sets whether effects will continue to spawn after the first one of the round", _, true, 0.0, true, 1.0);
	g_cvChaosOverrideDuration = CreateConVar("sm_chaos_override_duration", "-1", "Sets the duration for ALL effects, use -1 to use Chaos_Effects.cfg durations, use 0.0 for no expiration.", _, true, -1.0, true, 120.0);

	g_cvChaosTwitchEnabled = CreateConVar("sm_chaos_twitch_enabled", "0", "Enabling this will run a voting screen connected to the chaos twitch app", _, true, 0.0, true, 1.0);
	g_cvChaosNextEffect = CreateConVar("sm_chaos_nexteffect", "", "Sets what the next effect will be - twitch functionality", _, false, 0.0, false, 1.0);

	HookConVarChange(g_cvChaosEnabled, 				ConVarChanged);
	HookConVarChange(g_cvChaosEffectInterval, 		ConVarChanged);
	HookConVarChange(g_cvChaosRepeating, 			ConVarChanged);
	HookConVarChange(g_cvChaosOverrideDuration, 	ConVarChanged);

	HookConVarChange(g_cvChaosTwitchEnabled, 	ConVarChanged);
	HookConVarChange(g_cvChaosNextEffect, 		ConVarChanged);

	AutoExecConfig(true, "ChaosMod");
}

void UpdateCvars(){
	g_bChaos_Enabled = g_cvChaosEnabled.BoolValue;
	g_fChaos_EffectInterval = g_cvChaosEffectInterval.FloatValue;
	g_bChaos_Repeating = g_cvChaosRepeating.BoolValue;
	g_fChaos_OverwriteDuration = g_cvChaosOverrideDuration.FloatValue;

	g_bChaos_TwitchEnabled = g_cvChaosTwitchEnabled.BoolValue;
	g_cvChaosNextEffect.GetString(g_sChaosNextEffect, sizeof(g_sChaosNextEffect));
}

public void ConVarChanged(ConVar convar, char[] oldValue, char[] newValue){
	if(convar == g_cvChaosEnabled){
		if(StringToInt(oldValue) == 0 && StringToInt(newValue) == 1){
			g_bChaos_Enabled = true;
			// ChooseEffect(null);
		}else if(StringToInt(newValue) == 0){
			g_bChaos_Enabled = false;
			StopTimer(g_NewEffect_Timer);
		}
	}else if(convar == g_cvChaosEffectInterval){
		g_fChaos_EffectInterval = StringToFloat(newValue);
	}else if(convar == g_cvChaosRepeating){
		if(StringToInt(oldValue) == 1 && StringToInt(newValue) == 0){
			g_bChaos_Repeating = false;
			StopTimer(g_NewEffect_Timer);
		}else if(StringToInt(newValue) == 1){
			g_bChaos_Repeating = true;
		}
	} else if(convar == g_cvChaosOverrideDuration){
		g_fChaos_OverwriteDuration = StringToFloat(newValue); 
	} else if(convar == g_cvChaosTwitchEnabled){
			g_bChaos_TwitchEnabled = g_cvChaosTwitchEnabled.BoolValue;
	} else if(convar == g_cvChaosNextEffect){
		g_cvChaosNextEffect.GetString(g_sChaosNextEffect, sizeof(g_sChaosNextEffect));
	}
}