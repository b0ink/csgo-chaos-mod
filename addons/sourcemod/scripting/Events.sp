#pragma semicolon 1

Handle	g_iRoundTime_Timer = INVALID_HANDLE;
bool 	g_bCanSpawnChickens = true;
bool 	g_bCanSpawnEffect = true;




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
		// Only trigger playerspawn function if effect is active
		if(Chaos_EffectData_Buffer.OnPlayerSpawn != INVALID_FUNCTION && Chaos_EffectData_Buffer.Timer != INVALID_HANDLE){
			
			// Delay function to ensure player has fully spawned
			DataPack data = new DataPack();
			data.WriteFunction(Chaos_EffectData_Buffer.OnPlayerSpawn);
			data.WriteCell(client);

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

	if(ValidAndAlive(client)){
		Call_StartFunction(GetMyHandle(), func);
		Call_PushCell(client); 
		Call_Finish();
	}

	delete data;
	return Plugin_Continue;
}



public Action Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	// See `stock int CanSpawnChickens;` in `Helpers.sp`
	// g_bCanSpawnChickens = false;
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
	
	ResetHud();
	ResetChaos(RESET_ROUNDSTART);
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

public Action Timer_CreateHostage(Handle timer){
	int iEntity = -1;
	if((iEntity = FindEntityByClassname(iEntity, "func_hostage_rescue")) == -1) {
		int iHostageRescueEnt = CreateEntityByName("func_hostage_rescue");
		DispatchKeyValue(iHostageRescueEnt, "targetname", "fake_hostage_rescue");
		// DispatchKeyValue(iHostageRescueEnt, "origin", "-3141 -5926 -5358");
		DispatchSpawn(iHostageRescueEnt);
	}
	return Plugin_Continue;
}

public Action Event_RoundEnd(Event event, char[] name, bool dontBroadcast){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	expectedTimeForNewEffect = -1;
	
	ClearFog();
	
	ResetChaos(RESET_ROUNDEND);
	g_bCanSpawnEffect = false;

	Clear_Overlay_Que();

	return Plugin_Continue;
}

void ResetChaos(int resetflags){
	HUD_ROUNDEND();
	Clear_Overlay_Que();
	StopTimer(g_NewEffect_Timer);
	ResetRoundChaos(null, resetflags);
	// CreateTimer(0.1, ResetRoundChaos, resetflags);
}


public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast){
	if (!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	return Plugin_Handled;
}

public Action Event_RoundFreezeEnd(Event event, const char[] name, bool dontBroadcast){
	StopTimer(g_iRoundTime_Timer);
	g_iRoundTime = 0;
	g_iRoundTime_Timer = CreateTimer(1.0, Timer_UpdateRoundTime, _, TIMER_REPEAT);
	return Plugin_Continue;
}

public Action Timer_UpdateRoundTime(Handle timer){
	if(!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	g_iRoundTime++;	
	return Plugin_Continue;
}