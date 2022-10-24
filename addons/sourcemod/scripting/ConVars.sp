ConVar 	g_cvChaosEnabled;
ConVar 	g_cvChaosEffectInterval;
ConVar 	g_cvChaosRepeating;
ConVar 	g_cvChaosOverrideDuration;
ConVar 	g_cvChaosTwitchEnabled;

ConVar 	g_cvChaosEffectTimer_Color;
int       g_ChaosEffectTimer_Color[4] = {200,0,220, 0};

ConVar 	g_cvChaosEffectList_Color;
int       g_ChaosEffectList_Color[4] = {37,186,255, 0};

Handle g_SavedConvars = INVALID_HANDLE;

void cvar(char[] cvarname, char[] newValue, bool updateConfig = true, char[] expectedPreviousValue = ""){
	if(cvarname[0] == '\0') return;

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
		if(expectedPreviousValue[0] != '\0'){
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

		if(cvarName[0] != '\0'){
			if(StrEqual(convarName, cvarName, false)){
				cvar(cvarName, convarValue, false);
				changed = true;
			}
		}else{
			cvar(convarName, convarValue, false);
		} 

	} while(kvConfig.GotoNextKey(false));
	if(!changed && cvarName[0] != '\0'){
		cvar(cvarName, backupValue, false, expectedPreviousValue);
		// cvar(cvarName, backupValue, false);
	}
	if(cvarName[0] == '\0'){
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

	g_cvChaosEffectTimer_Color = CreateConVar("sm_chaos_effect_timer_color", "220 0 220 0", "Set the RGB values of the Effect Timer countdown. (Default is purple)", _, false, 0.0, false, 1.0);
	g_cvChaosEffectList_Color = CreateConVar("sm_chaos_effect_list_color", "220 0 220 0", "Set the RGB values of the Effect List on the side. (Default is blue)", _, false, 0.0, false, 1.0);

	HookConVarChange(g_cvChaosEnabled, 				ConVarChanged);
	HookConVarChange(g_cvChaosEffectInterval, 		ConVarChanged);
	HookConVarChange(g_cvChaosRepeating, 			ConVarChanged);
	HookConVarChange(g_cvChaosOverrideDuration, 	ConVarChanged);

	HookConVarChange(g_cvChaosEffectTimer_Color, 	ConVarChanged);
	HookConVarChange(g_cvChaosEffectList_Color, 	ConVarChanged);

	HookConVarChange(g_cvChaosTwitchEnabled, 	ConVarChanged);
}

void UpdateCvars(){
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/Chaos_Convars.cfg");
	KeyValues kv = new KeyValues("Convars");

	if(FileExists(path)){
		if(kv.ImportFromFile(path)){
			int convar_value = -1;
			convar_value = kv.GetNum("sm_chaos_enabled", 1);
			g_cvChaosEnabled.SetInt(convar_value);

			convar_value = kv.GetNum("sm_chaos_interval", 999);
			g_cvChaosEffectInterval.SetInt(convar_value);

			convar_value = kv.GetNum("sm_chaos_override_duration", 1);
			g_cvChaosOverrideDuration.SetInt(convar_value);

			convar_value = kv.GetNum("sm_chaos_repeating", 1);
			g_cvChaosRepeating.SetInt(convar_value);

			convar_value = kv.GetNum("sm_chaos_twitch_enabled", 1);
			g_cvChaosTwitchEnabled.SetInt(convar_value);

			char color[128];
			kv.GetString("sm_chaos_effect_timer_color", color, 128);
			g_cvChaosEffectTimer_Color.SetString(color);
			kv.GetString("sm_chaos_effect_list_color", color, 128);
			g_cvChaosEffectList_Color.SetString(color);
		}
	}
}


void ConvertColorStringToFloat(ConVar convar, int buffer[4], int defaultColor[4]){
		char color[128];
		convar.GetString(color, 128);
		char colorchunks[4][128];
		int count = ExplodeString(color, " ", colorchunks, 4, 128);
		if(count != 4 || color[0] == '\0'){ // if config wasn't set properly
			buffer = defaultColor;
		}else{
			buffer[0] = StringToInt(colorchunks[0]);
			buffer[1] = StringToInt(colorchunks[1]);
			buffer[2] = StringToInt(colorchunks[2]);
			buffer[3] = StringToInt(colorchunks[3]);
		}
}

public void ConVarChanged(ConVar convar, char[] oldValue, char[] newValue){
	if(convar == g_cvChaosEnabled){
		if(StringToInt(newValue) == 0){
			StopTimer(g_NewEffect_Timer);
		}
	}else if(convar == g_cvChaosRepeating){
		if(StringToInt(oldValue) == 1 && StringToInt(newValue) == 0){
			StopTimer(g_NewEffect_Timer);
		}
	}else if(convar == g_cvChaosEffectTimer_Color){
		ConvertColorStringToFloat(g_cvChaosEffectTimer_Color, g_ChaosEffectTimer_Color, {200, 0, 220, 0});
	} else if(convar == g_cvChaosEffectList_Color){
		ConvertColorStringToFloat(g_cvChaosEffectList_Color, g_ChaosEffectList_Color, {37, 186, 255, 0});
	}
}


//!When editing KeyValues, it removes all comments - this is a temp fix to re add them to assist the server owner
void Update_Convar_Config(){
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/Chaos_Convars.cfg");
	File file = OpenFile(path, "w");
	if(file == null){
		return;
	}
	file.WriteLine("\"Convars\"");
	file.WriteLine("{");
	file.WriteLine("");

	file.WriteLine("	// Determines whether the chaos plugin will be enabled or not.");
	file.WriteLine("	// Setting it to 1 will activate the plugin automatically.");
	file.WriteLine("");
	file.WriteLine("	\"sm_chaos_enabled\"    \"%i\"", g_cvChaosEnabled.IntValue);

	file.WriteLine("");
	file.WriteLine("	// Determines how often a new effect will be spawned.");
	file.WriteLine("	// Most effects have a standard duration of 30 seconds.");
	file.WriteLine("	// It is recommended to adjust sm_chaos_effectduration_scale based on the effect interval.");
	file.WriteLine("	\"sm_chaos_interval\"    \"%i\"", g_cvChaosEffectInterval.IntValue);
	file.WriteLine("");

	file.WriteLine("");
	file.WriteLine("	//Overrides ALL effect durations if set above -1.");
	file.WriteLine("	// Setting it to -1 (Default) will mean all effects use the durations set in Chaos_Effects.cfg");
	file.WriteLine("	// Setting it to 0 will mean all effects will last the entire round.");
	file.WriteLine("	// Setting it to anything above 0, will mean all effects last for that value in seconds.");
	file.WriteLine("	\"sm_chaos_override_duration\"    \"%i\"", g_cvChaosOverrideDuration.IntValue);
	file.WriteLine("");

	file.WriteLine("");
	file.WriteLine("	// Determines whether or not new effects will be spawned throughout the round.");
	file.WriteLine("	// Setting it to 1 means a new effect will be spawned at the rate of sm_chaos_interval");
	file.WriteLine("	// Setting it to 0 means only one effect will spawn at the start of the round");
	file.WriteLine("	\"sm_chaos_repeating\"    \"%i\"", g_cvChaosRepeating.IntValue);
	file.WriteLine("");

	file.WriteLine("");
	file.WriteLine("	// Determines whether effects will be pooled in for twitch voting.");
	file.WriteLine("	// If you are using the twitch overlay app, set this to 1.");
	file.WriteLine("	// This setting will be set to 0 by default on each map change.");
	file.WriteLine("	\"sm_chaos_twitch_enabled\"    \"%i\"", g_cvChaosTwitchEnabled.IntValue);
	file.WriteLine("");
	
	char colorDetails[64];
	g_cvChaosEffectTimer_Color.GetString(colorDetails, 64);

	file.WriteLine("");
	file.WriteLine("	// Sets the color (RGBA) of the countdown timer at the top of the screen.");
	file.WriteLine("	// Default is \"200 0 220 0\"");
	file.WriteLine("	\"sm_chaos_effect_timer_color\"    \"%s\"", colorDetails);
	file.WriteLine("");

	g_cvChaosEffectList_Color.GetString(colorDetails, 64);

	file.WriteLine("");
	file.WriteLine("	// Sets the color (RGBA) of the effect list on the side of the screen.");
	file.WriteLine("	// Default is \"37 186 255 0\"");
	file.WriteLine("	\"sm_chaos_effect_list_color\"    \"%s\"", colorDetails);
	file.WriteLine("");

	file.WriteLine("	// Automatically adjust the length of all the effects based off sm_chaos_interval.");
	file.WriteLine("	// if interval = 15 seconds, effect default durations = 25;");
	file.WriteLine("	// if interval = 20 seconds, effect default durations = 30;");
	file.WriteLine("	// if interval = 30 seconds, effect default durations = 40;");

	file.WriteLine("}");
	delete file;
}