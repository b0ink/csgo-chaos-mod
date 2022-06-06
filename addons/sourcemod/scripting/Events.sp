

effect 	Chaos_EffectData_Buffer;
char 	Chaos_EventName_Buffer[64];


//todo: move all effects into their own .sp files inside of /scripting/Externals, modularise it a bit more

public Action Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	if(!g_bChaos_Enabled) return Plugin_Continue;
	g_bCanSpawnChickens = false;
	g_bBombPlanted = true;
	C4Chicken();

	return Plugin_Continue;
}


public void OnEntityCreated(int ent, const char[] classname){
	for(int i = 0; i < alleffects.Length; i++){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnEntityCreated", Chaos_EffectData_Buffer.config_name);
		alleffects.GetArray(i, Chaos_EffectData_Buffer, sizeof(Chaos_EffectData_Buffer));
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(ent); 
			Call_PushString(classname);
			Call_Finish();
		}
	}
}



public Action OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(!g_bChaos_Enabled) return Plugin_Continue;

	for(int i = 0; i < alleffects.Length; i++){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnPlayerRunCmd", Chaos_EffectData_Buffer.config_name);
		alleffects.GetArray(i, Chaos_EffectData_Buffer, sizeof(Chaos_EffectData_Buffer));
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(client); 
			Call_PushCellRef(buttons);
			Call_PushCell(iImpulse);
			Call_PushArrayEx(fVel, 3, SM_PARAM_COPYBACK);
			Call_PushArrayEx(fAngles, 3, SM_PARAM_COPYBACK);
			Call_PushCell(iWeapon);
			Call_PushCell(iSubType);
			Call_PushCell(iCmdNum);
			Call_PushCell(iTickCount);
			Call_PushCellRef(iSeed);
			Call_Finish();
		}
	}

	return Plugin_Changed;
}




public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	if(!g_bChaos_Enabled) return Plugin_Continue;

	int client = GetClientOfUserId(event.GetInt("userid"));

	if(IsValidClient(client)){
		ClientCommand(client, "r_screenoverlay \"\"");
		GetClientAbsOrigin(client, g_PlayerDeathLocations[client]);
	}
	return Plugin_Continue;
}


public Action Event_RoundStart(Event event, char[] name, bool dontBroadcast){
	if(!g_bChaos_Enabled) return Plugin_Continue;
	
	Log("---ROUND STARTED---");

	g_bC4Chicken = false;
	g_bCanSpawnEffect = true;
	g_bRewind_logging_enabled = true;
	// g_bKnifeFight = 0;
	
	CheckHostageMap();

	ResetHud();
	
	ResetChaos();

	CLEAR_CC();

	g_iChaos_Round_Count = 0;
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			g_OriginalSpawnVec[i] = vec;
		}
	}

	CreateTimer(5.0, Timer_CreateHostage);
	
	SetRandomSeed(GetTime());
	
	if(!g_bChaos_Enabled) return Plugin_Continue;
	
	if (GameRules_GetProp("m_bWarmupPeriod") != 1){
		float freezeTime = float(FindConVar("mp_freezetime").IntValue);
		g_NewEffect_Timer = CreateTimer(freezeTime, ChooseEffect, _, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}

public Action Event_RoundEnd(Event event, char[] name, bool dontBroadcast){
	if(!g_bChaos_Enabled) return Plugin_Continue;
	
	Log("--ROUND ENDED--");
	ResetChaos();
	g_bCanSpawnEffect = false;

	Clear_Overlay_Que();

	return Plugin_Continue;
}

void ResetChaos(){
	HUD_ROUNDEND();
	Clear_Overlay_Que();
	StopTimer(g_NewEffect_Timer);
	// ResetPlayersFOV(); //todo
	CreateTimer(0.1, ResetRoundChaos);
}

public void OnGameFrame(){
	for(int i = 0; i < alleffects.Length; i++){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnGameFrame", Chaos_EffectData_Buffer.config_name);
		alleffects.GetArray(i, Chaos_EffectData_Buffer, sizeof(Chaos_EffectData_Buffer));
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish();
		}
	}
	Rollback_Log();
}


public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast){
	if (!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	return Plugin_Handled;
}