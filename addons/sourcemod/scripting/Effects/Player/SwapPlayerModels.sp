#pragma semicolon 1

public void Chaos_SwapPlayerModels(effect_data effect){
	effect.Title = "Swap Player Models";
	effect.Duration = 30;
	effect.AddFlag("playermodel");
}

Handle SwapPlayerModel_T;
Handle SwapPlayerModel_CT;

char SwapPlayerModels_Original[MAXPLAYERS+1][PLATFORM_MAX_PATH];

public void Chaos_SwapPlayerModels_INIT(){
	SwapPlayerModel_T = CreateArray(PLATFORM_MAX_PATH);
	SwapPlayerModel_CT = CreateArray(PLATFORM_MAX_PATH);
	Timer_GetPlayerModels(null);
	HookEvent("round_start", Chaos_SwapPlayerModels_Event_RoundStart);
}

public void Chaos_SwapPlayerModels_Event_RoundStart(Event event, char[] name, bool dbc){
	CreateTimer(1.0, Timer_GetPlayerModels, .flags=TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_GetPlayerModels(Handle timer){
	ClearArray(SwapPlayerModel_T);
	ClearArray(SwapPlayerModel_CT);
	char modelName[PLATFORM_MAX_PATH];
	LoopAlivePlayers(i){
		GetEntPropString(i, Prop_Data, "m_ModelName", modelName, PLATFORM_MAX_PATH);
		if(modelName[0] == '\0') continue;

		if(GetClientTeam(i) == CS_TEAM_T){
			PushArrayString(SwapPlayerModel_T, modelName);
		}else{
			PushArrayString(SwapPlayerModel_CT, modelName);
		}
	}
	return Plugin_Continue;
}


public void Chaos_SwapPlayerModels_START(){
	SwapPlayerModels();
}

void SwapPlayerModels(int client = -1){
	int t_index = 0;
	int ct_index = 0;
	char modelName[PLATFORM_MAX_PATH];
	LoopAlivePlayers(i){
		modelName = "";
		if(GetClientTeam(i) == CS_TEAM_CT){
			if(t_index >= GetArraySize(SwapPlayerModel_T)) t_index = 0;
			GetArrayString(SwapPlayerModel_T, t_index, modelName, PLATFORM_MAX_PATH);
			t_index++;
		}else{
			if(ct_index >= GetArraySize(SwapPlayerModel_CT)) ct_index = 0;
			GetArrayString(SwapPlayerModel_CT, ct_index, modelName, PLATFORM_MAX_PATH);
			ct_index++;
		}
		if(modelName[0] == '\0') continue;
		if((ValidAndAlive(client) && i == client) || client == -1){
			GetEntPropString(i,	Prop_Data, "m_ModelName", SwapPlayerModels_Original[i], PLATFORM_MAX_PATH);
			SetEntityModel(i, modelName);
		}
	}
}



public void Chaos_SwapPlayerModels_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			if(SwapPlayerModels_Original[i][0] != '\0'){
				SetEntityModel(i, SwapPlayerModels_Original[i]);
			}
		}
	}
}


public void Chaos_SwapPlayerModels_OnPlayerSpawn(int client){
	SwapPlayerModels(client);
}

public bool Chaos_SwapPlayerModels_Conditions(bool EffectRunRandomly){
	if(GetArraySize(SwapPlayerModel_CT) == 0) return false;
	if(GetArraySize(SwapPlayerModel_T) == 0) return false;
	return true;
}