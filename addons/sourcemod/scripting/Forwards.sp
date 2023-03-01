EffectData 	Chaos_EffectData_Buffer;

public void OnPluginStart(){
	LoadTranslations("chaos.phrases.txt");
	
	CreateConVars();
	RegisterCommands();

	HookMainEvents();

	for(int i = 1; i <= MaxClients; i++){
		if(IsValidClient(i)){
			OnClientPutInServer(i);
		}
	}

	PossibleChaosEffects = new ArrayList(sizeof(EffectData));
	EffectsHistory = CreateArray(64);

	PossibleMetaEffects = new ArrayList(sizeof(EffectData));
	MetaEffectsHistory = new ArrayList(sizeof(EffectData));

	g_SavedConvars  = CreateArray(64);

	ChaosEffects = new ArrayList(sizeof(EffectData));

	ParseChaosEffects();

	TWITCH_INIT();
}


public void OnPluginEnd(){
	ResetCvar();
	ResetChaos(RESET_PLUGINEND);
}


public void OnMapStart(){

	/* Save models now mostly for plugin reloads */
	LoopAlivePlayers(i){
		SavePlayerModel(i);
	}
	
	MetaEffectsHistory.Clear();
	if(EffectsHistory != INVALID_HANDLE){
		ClearArray(EffectsHistory);
	}
	UpdateCvars();

	CreateTimer(60.0 * 10.0, Timer_Advertisement, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	CreateTimer(1.0, Timer_DisplayEffects, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);

	GetCurrentMap(g_sCurrentMapName, sizeof(g_sCurrentMapName));
	// Log("New Map/Plugin Restart - Map: %s", g_sCurrentMapName);
	
	PrecacheSound("buttons/bell1.wav");
	PrecacheSound("ui/beep07.wav");

	//TODO: put all map spawn data into structs
	if(g_MapCoordinates != 	INVALID_HANDLE) ClearArray(g_MapCoordinates);
	if(bombSiteA != 		INVALID_HANDLE) ClearArray(bombSiteA);
	if(bombSiteB != 		INVALID_HANDLE) ClearArray(bombSiteB);

	g_MapCoordinates = 		INVALID_HANDLE;
	bombSiteA = 			INVALID_HANDLE;
	bombSiteB = 			INVALID_HANDLE;

	Find_Fog();
	
	CLEAR_CC();
	HUD_INIT();

	COORD_INIT();
	WEATHER_INIT();

	// Run_OnMapStart_Functions();

	cvar("sv_fade_player_visibility_farz", "1");

	StopTimer(g_NewEffect_Timer);
	g_NewEffect_Timer = INVALID_HANDLE;

	if(EffectsHistory != INVALID_HANDLE) ClearArray(EffectsHistory);

	RemoveChickens();
	
	g_iTotalEffectsRunThisMap = 0;
}


Action Timer_Advertisement(Handle timer){
	if(g_cvChaosEnabled.BoolValue){
		CPrintToChatAll("Thanks for playing {lightblue}CS:GO Chaos Mod{default}!\xe2\x80\xa9Visit {orange}csgochaosmod.com {default}to add this mod to your server!");
	}
	return Plugin_Continue;
}


public void OnMapEnd(){
	if(!g_cvChaosEnabled.BoolValue) return;

	Log("Map has ended.");
	StopTimer(g_NewEffect_Timer);
	ResetCvar();
}


public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max){
    MarkNativeAsOptional("GetDynamicChannel");
    return APLRes_Success;
}


public void OnAllPluginsLoaded(){
	FindThirdPartyConVars();
	g_bDynamicChannelsEnabled = LibraryExists("DynamicChannels");
	if(!g_bDynamicChannelsEnabled){
		Log("Could not find plugin 'DynamicChannels.smx'. To enable HUD text for Chaos effects and timers, install the 'DynamicChannels.smx' plugin from https://github.com/Vauff/DynamicChannels");
	}
}

 
public void OnLibraryRemoved(const char[] name){
    if (StrEqual(name, "DynamicChannels")){
        g_bDynamicChannelsEnabled = false;
    }
}

 
public void OnLibraryAdded(const char[] name){
    if (StrEqual(name, "DynamicChannels")){
        g_bDynamicChannelsEnabled = true;
    }
}


public void OnClientPutInServer(int client){
	g_fBellVolume[client] = 0.5;
	HideTimer[client] = false;
	HideEffectList[client] = false;
	HideAnnouncement[client] = false;
	UseHtmlHud[client] = false;
	UseTimerBar[client] = true;
}


public void OnClientDisconnect(int client){
	
}


public Action OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		if(Chaos_EffectData_Buffer.OnPlayerRunCmd != INVALID_FUNCTION){
			if(!Chaos_EffectData_Buffer.CanRunForward("OnPlayerRunCmd")) continue;
			Call_StartFunction(GetMyHandle(), Chaos_EffectData_Buffer.OnPlayerRunCmd);
			Call_PushCell(client); 
			Call_PushCellRef(buttons);
			Call_PushCellRef(iImpulse);
			Call_PushArrayEx(fVel, 3, SM_PARAM_COPYBACK);
			Call_PushArrayEx(fAngles, 3, SM_PARAM_COPYBACK);
			Call_PushCellRef(iWeapon);
			Call_PushCellRef(iSubType);
			Call_PushCellRef(iCmdNum);
			Call_PushCellRef(iTickCount);
			Call_PushCellRef(iSeed);
			Call_PushArrayEx(mouse, 2, SM_PARAM_COPYBACK);
			Call_Finish();
		}
	}

	return Plugin_Changed;
}


public void OnGameFrame(){
	if (!g_cvChaosEnabled.BoolValue) return;
	LerpOnGameFrame();
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		if(Chaos_EffectData_Buffer.OnGameFrame != INVALID_FUNCTION){
			if(!Chaos_EffectData_Buffer.CanRunForward("OnGameFrame")) continue;
			Call_StartFunction(GetMyHandle(), Chaos_EffectData_Buffer.OnGameFrame);
			Call_Finish();
		}
	}
}


public void OnEntityCreated(int ent, const char[] classname){
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		if(Chaos_EffectData_Buffer.OnEntityCreated != INVALID_FUNCTION){
			if(!Chaos_EffectData_Buffer.CanRunForward("OnEntityCreated")) continue;
			Call_StartFunction(GetMyHandle(), Chaos_EffectData_Buffer.OnEntityCreated);
			Call_PushCell(ent); 
			Call_PushString(classname);
			Call_Finish();
		}
	}
}


public void OnEntityDestroyed(int ent){
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		if(Chaos_EffectData_Buffer.OnEntityDestroyed != INVALID_FUNCTION){
			if(!Chaos_EffectData_Buffer.CanRunForward("OnEntityDestroyed")) continue;
			Call_StartFunction(GetMyHandle(), Chaos_EffectData_Buffer.OnEntityDestroyed);
			Call_PushCell(ent); 
			Call_Finish();
		}
	}
}