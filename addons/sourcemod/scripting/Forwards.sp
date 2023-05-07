

public void OnPluginStart() {
	LoadTranslations("chaos.phrases.txt");

	CreateConVars();
	RegisterCommands();
	HookMainEvents();

	g_SavedConvars = CreateArray(64);

	ChaosEffects = new ArrayList(sizeof(EffectData));
	MetaEffects = new ArrayList(128);
	PossibleChaosEffects = new ArrayList(sizeof(EffectData));
	EffectsHistory = CreateArray(64);

	ParseChaosEffects();

	TWITCH_INIT();

	for(int i = 1; i <= MaxClients; i++) {
		if(IsValidClient(i)) {
			OnClientPutInServer(i);
			if(IsPlayerAlive(i)) {
				/* Save models now mostly for plugin reloads */
				SavePlayerModel(i);
			}
		}
	}
}

public void OnPluginEnd() {
	ResetCvar();
	ResetChaos(RESET_PLUGINEND);
}

public void OnMapStart() {
	for(int i = 0; i <= MaxClients; i++) {
		OriginalPlayerModels[i] = "\0";
	}

	UpdateCvars();
	cvar("sv_fade_player_visibility_farz", "1");

	g_iTotalEffectsRunThisMap = 0;
	GetCurrentMap(g_sCurrentMapName, sizeof(g_sCurrentMapName));
	if(EffectsHistory != INVALID_HANDLE) ClearArray(EffectsHistory);

	PrecacheSound("buttons/bell1.wav");
	PrecacheSound("buttons/button10.wav");
	PrecacheSound("ui/beep07.wav");

	/* Inits */
	InitFog();
	InitHud();
	InitSpawns();
	InitWeather();
	ParseMissionData();

	/* Cleanup */
	RemoveChickens();
	CLEAR_CC();

	StopTimer(g_NewEffect_Timer);
	g_NewEffect_Timer = INVALID_HANDLE;

	CreateTimer(60.0 * 30.0, Timer_Advertisement, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	CreateTimer(1.0, Timer_DisplayEffects, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}


Action Timer_Advertisement(Handle timer) {
	if(g_cvChaosEnabled.BoolValue) {
		CPrintToChatAll("Thanks for playing {lightblue}CS:GO Chaos Mod{default}!\xe2\x80\xa9Visit {orange}https://csgochaosmod.com {default}to add this mod to your server!");
	}
	return Plugin_Continue;
}

public void OnMapEnd() {
	if(!g_cvChaosEnabled.BoolValue) return;

	Log("Map has ended.");
	StopTimer(g_NewEffect_Timer);
	ResetCvar();
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	MarkNativeAsOptional("GetDynamicChannel");
	return APLRes_Success;
}

public void OnAllPluginsLoaded() {
	FindThirdPartyConVars();
	g_bDynamicChannelsEnabled = LibraryExists("DynamicChannels");
	if(!g_bDynamicChannelsEnabled) {
		Log("Could not find plugin 'DynamicChannels.smx'. To enable HUD text for Chaos effects and timers, install the 'DynamicChannels.smx' plugin from https://github.com/Vauff/DynamicChannels");
	}
}

public void OnLibraryRemoved(const char[] name) {
	if(StrEqual(name, "DynamicChannels")) {
		g_bDynamicChannelsEnabled = false;
	}
}

public void OnLibraryAdded(const char[] name) {
	if(StrEqual(name, "DynamicChannels")) {
		g_bDynamicChannelsEnabled = true;
	}
}

public void OnClientPutInServer(int client) {
	g_fBellVolume[client] = 0.5;
	HideTimer[client] = false;
	HideEffectList[client] = false;
	HideAnnouncement[client] = false;
	UseHtmlHud[client] = false;
	UseTimerBar[client] = true;
}

EffectData Chaos_EffectData_Buffer;

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]) {
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	LoopAllEffects(Chaos_EffectData_Buffer, index) {
		if(Chaos_EffectData_Buffer.OnPlayerRunCmd != INVALID_FUNCTION) {
			if(!Chaos_EffectData_Buffer.CanRunForward("OnPlayerRunCmd")) continue;
			Call_StartFunction(GetMyHandle(), Chaos_EffectData_Buffer.OnPlayerRunCmd);
			Call_PushCell(client);
			Call_PushCellRef(buttons);
			Call_PushCellRef(impulse);
			Call_PushArrayEx(vel, 3, SM_PARAM_COPYBACK);
			Call_PushArrayEx(angles, 3, SM_PARAM_COPYBACK);
			Call_PushCellRef(weapon);
			Call_PushCellRef(subtype);
			Call_PushCellRef(cmdnum);
			Call_PushCellRef(tickcount);
			Call_PushCellRef(seed);
			Call_PushArrayEx(mouse, 2, SM_PARAM_COPYBACK);
			Call_Finish();
		}
	}

	return Plugin_Changed;
}

public void OnGameFrame() {
	if(!g_cvChaosEnabled.BoolValue) return;
	LerpOnGameFrame();
	LoopAllEffects(Chaos_EffectData_Buffer, index) {
		if(Chaos_EffectData_Buffer.OnGameFrame != INVALID_FUNCTION) {
			if(!Chaos_EffectData_Buffer.CanRunForward("OnGameFrame")) continue;
			Call_StartFunction(GetMyHandle(), Chaos_EffectData_Buffer.OnGameFrame);
			Call_Finish();
		}
	}
}

public void OnEntityCreated(int ent, const char[] classname) {
	LoopAllEffects(Chaos_EffectData_Buffer, index) {
		if(Chaos_EffectData_Buffer.OnEntityCreated != INVALID_FUNCTION) {
			if(!Chaos_EffectData_Buffer.CanRunForward("OnEntityCreated")) continue;
			Call_StartFunction(GetMyHandle(), Chaos_EffectData_Buffer.OnEntityCreated);
			Call_PushCell(ent);
			Call_PushString(classname);
			Call_Finish();
		}
	}
}

public void OnEntityDestroyed(int ent) {
	LoopAllEffects(Chaos_EffectData_Buffer, index) {
		if(Chaos_EffectData_Buffer.OnEntityDestroyed != INVALID_FUNCTION) {
			if(!Chaos_EffectData_Buffer.CanRunForward("OnEntityDestroyed")) continue;
			Call_StartFunction(GetMyHandle(), Chaos_EffectData_Buffer.OnEntityDestroyed);
			Call_PushCell(ent);
			Call_Finish();
		}
	}
}