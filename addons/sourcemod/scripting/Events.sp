effect_data 	Chaos_EffectData_Buffer;
char 			Chaos_EventName_Buffer[64];


public Action Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	if(!g_bChaos_Enabled) return Plugin_Continue;
	g_bCanSpawnChickens = false;
	g_bBombPlanted = true;
	if(!ValidBombSpawns()){
		CreateTimer(1.0, Timer_SaveBombPosition);
	}
	return Plugin_Continue;
}

public Action Timer_SaveBombPosition(Handle timer){
	SaveBombPosition();
}


public void OnEntityCreated(int ent, const char[] classname){
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnEntityCreated", Chaos_EffectData_Buffer.config_name);
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
	
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnPlayerRunCmd", Chaos_EffectData_Buffer.config_name);
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
	
	LoopAlivePlayers(client){
		GetClientAbsOrigin(client, g_OriginalSpawnVec[client]);
	}

	CreateTimer(5.0, Timer_CreateHostage);
	
	SetRandomSeed(GetTime());
	
	if(!g_bChaos_Enabled) return Plugin_Continue;
	
	if (GameRules_GetProp("m_bWarmupPeriod") != 1){
		float freezeTime = float(FindConVar("mp_freezetime").IntValue);
		g_NewEffect_Timer = CreateTimer(freezeTime, ChooseEffect, _, TIMER_FLAG_NO_MAPCHANGE);
	}

	g_iChaos_Round_Time = 0;
	CreateTimer(1.0, Timer_UpdateRoundTime);
	return Plugin_Continue;
}

public Action Timer_UpdateRoundTime(Handle timer){
	if(g_iChaos_Round_Time < -50){
		return;
	}
	g_iChaos_Round_Time++;	
	CreateTimer(1.0, Timer_UpdateRoundTime);
}
public Action Event_RoundEnd(Event event, char[] name, bool dontBroadcast){
	if(!g_bChaos_Enabled) return Plugin_Continue;
	g_iChaos_Round_Time = -100;
	
	ClearFog();
	
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
	// ResetPlayersFOV(); //TODO:
	CreateTimer(0.1, ResetRoundChaos);
}

public void OnGameFrame(){
	if (!g_cvChaosEnabled.BoolValue) return;

	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnGameFrame", Chaos_EffectData_Buffer.config_name);
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