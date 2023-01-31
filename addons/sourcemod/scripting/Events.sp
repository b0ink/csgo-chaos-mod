#pragma semicolon 1


public void HookMainEvents(){
	HookEvent("round_start", 		Event_RoundStart);
	HookEvent("round_end", 			Event_RoundEnd);	
	HookEvent("bomb_planted", 		Event_BombPlanted);
	HookEvent("server_cvar", 		Event_Cvar, EventHookMode_Pre);
	HookEvent("player_spawn", 		Event_PlayerSpawn);
	HookEvent("round_freeze_end", 	Event_RoundFreezeEnd);
}

public Action Event_PlayerSpawn(Event event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;

	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if (GameRules_GetProp("m_bWarmupPeriod") == 1){
		CreateTimer(1.0, Timer_SendSettingsReminder, client, TIMER_FLAG_NO_MAPCHANGE);
	}

	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_OnPlayerSpawn", Chaos_EffectData_Buffer.FunctionName);
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		if(func != INVALID_FUNCTION){
			
			// Delay function to ensure player has fully spawned
			DataPack data = new DataPack();
			data.WriteFunction(func);
			data.WriteCell(client);
			data.WriteCell(Chaos_EffectData_Buffer.Timer != INVALID_HANDLE);

			CreateTimer(0.2, Timer_TriggerOnPlayerSpawn, data);
		}
	}
	
	return Plugin_Continue;
}

int settingsReminder[MAXPLAYERS+1];
public Action Timer_SendSettingsReminder(Handle timer, int client){
	if(IsValidClient(client) && settingsReminder[client] % 3 == 0){
		if(CheckCommandAccess(client, "sm_slay", ADMFLAG_CHAT)){
			CPrintToChat(client, "%s Use !chaos in chat to adjust your HUD, Sound levels, ConVars, and Effect settings", g_Prefix);
			PrintHintText(client, "Use !chaos in chat to adjust your HUD, Sound levels, ConVars, and Effect settings");
		}else{
			CPrintToChat(client, "%s Use !chaos in chat to adjust your HUD and SFX settings", g_Prefix);
			PrintHintText(client, "Use !chaos in chat to adjust your HUD and SFX settings");
		}
	}
	settingsReminder[client]++;
	return Plugin_Continue;
}

public Action Timer_TriggerOnPlayerSpawn(Handle timer, DataPack data){
	data.Reset();

	Function func = data.ReadFunction();
	int client = data.ReadCell();
	bool isEffectRunning = data.ReadCell();

	if(ValidAndAlive(client)){
		Call_StartFunction(GetMyHandle(), func);
		Call_PushCell(client); 
		Call_PushCell(isEffectRunning); 
		Call_Finish();
	}

	delete data;
	return Plugin_Continue;
}



public Action Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	g_bCanSpawnChickens = false;
	if(!ValidBombSpawns()){
		CreateTimer(1.0, Timer_SaveBombPosition);
	}
	return Plugin_Continue;
}


public Action Timer_SaveBombPosition(Handle timer){
	SaveBombPosition();
	return Plugin_Continue;
}



public Action Event_RoundStart(Event event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;

	// Log("---ROUND STARTED---");

	g_bCanSpawnEffect = true;
	
	CheckHostageMap();
	ResetHud();
	ResetChaos();
	CLEAR_CC();

	g_iTotalEffectsRanThisRound = 0;

	CreateTimer(5.0, Timer_CreateHostage);
		
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	
	// round_freeze_end is not used because of starting the timer countdown (value of mp_freezetime)
	if (GameRules_GetProp("m_bWarmupPeriod") != 1){
		int freezeTime = FindConVar("mp_freezetime").IntValue;
		g_NewEffect_Timer = CreateTimer(float(freezeTime), ChooseEffect, _, TIMER_FLAG_NO_MAPCHANGE);
		Timer_Display(null, freezeTime);
		expectedTimeForNewEffect =  GetTime() + freezeTime;
	}

	return Plugin_Continue;
}


public Action Event_RoundEnd(Event event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	expectedTimeForNewEffect = -1;
	
	ClearFog();
	
	ResetChaos();
	g_bCanSpawnEffect = false;

	Clear_Overlay_Que();

	return Plugin_Continue;
}

void ResetChaos(){
	HUD_ROUNDEND();
	Clear_Overlay_Que();
	StopTimer(g_NewEffect_Timer);
	CreateTimer(0.1, ResetRoundChaos);
}


public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast){
	if (!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	return Plugin_Handled;
}

public Action Event_RoundFreezeEnd(Event event, const char[] name, bool dontBroadcast){
	StopTimer(g_iChaosRoundTime_Timer);
	g_iChaosRoundTime = 0;
	g_iChaosRoundTime_Timer = CreateTimer(1.0, Timer_UpdateRoundTime, _, TIMER_REPEAT);
	return Plugin_Continue;
}

public Action Timer_UpdateRoundTime(Handle timer){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	g_iChaosRoundTime++;	
	return Plugin_Continue;
}