#pragma semicolon 1

public void Chaos_Aimbot(effect_data effect){
	effect.Title = "Aimbot";
	effect.Duration = 30;
	
	effect.AddAlias("Hacks");
	effect.AddAlias("Cheats");
}

/* CREDIT: https://raw.githubusercontent.com/Franc1sco/aimbot/master/scripting/aimbot.sp */

/****************************************************************************************************
BOOLS.
*****************************************************************************************************/
bool AimbotEnabled = false;
bool g_bFlashed[MAXPLAYERS + 1] = {false, ...};

int g_cvRecoilMode = 1;
float g_cvFov = 360.0;
// bool g_bCvFlashbang = true;

public void Chaos_Aimbot_INIT(){
	HookEventEx("weapon_fire", 		Chaos_Aimbot_Event_WeaponFire, EventHookMode_Pre);
	HookEventEx("player_blind", 	Chaos_Aimbot_Event_PlayerBlind, EventHookMode_Pre);
}

public void Chaos_Aimbot_START(){
	AimbotEnabled = true;

	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_cooldown", "0");
	cvar("weapon_recoil_decay1_exp", "99999");
	cvar("weapon_recoil_decay2_exp", "99999");
	cvar("weapon_recoil_decay2_lin", "99999");
	cvar("weapon_recoil_scale", "0");
	cvar("weapon_recoil_suppression_shots", "500");
	cvar("weapon_recoil_variance", "0");
	cvar("weapon_recoil_view_punch_extra", "0");
	
	LoopAlivePlayers(i){
		Aimbot_SDKHOOKS(i);
	}
}

public void Chaos_Aimbot_RESET(int ResetType){
	AimbotEnabled = false;
	
	ResetCvar("weapon_accuracy_nospread", "0", "1");
	ResetCvar("weapon_recoil_cooldown", "0.55", "0");
	ResetCvar("weapon_recoil_decay1_exp", "3.5", "99999");
	ResetCvar("weapon_recoil_decay2_exp", "8", "99999");
	ResetCvar("weapon_recoil_decay2_lin", "18", "99999");
	ResetCvar("weapon_recoil_scale", "2", "0");
	ResetCvar("weapon_recoil_suppression_shots", "4", "500");
	ResetCvar("weapon_recoil_variance", "0.55", "0");
	ResetCvar("weapon_recoil_view_punch_extra", "0.055", "0");

	LoopValidPlayers(i){
		Aimbot_REMOVE_SDKHOOKS(i);
	}
}

public void Chaos_Aimbot_OnPlayerSpawn(int client){
	if(!AimbotEnabled) return;
	Aimbot_SDKHOOKS(client);
}


public void Aimbot_SDKHOOKS(int iClient){
	SDKHook(iClient, SDKHook_PreThink, Aimbot_OnClientThink);
	SDKHook(iClient, SDKHook_PreThinkPost, Aimbot_OnClientThink);
	SDKHook(iClient, SDKHook_PostThink, Aimbot_OnClientThink);
	SDKHook(iClient, SDKHook_PostThinkPost, Aimbot_OnClientThink);
}

public void Aimbot_REMOVE_SDKHOOKS(int iClient){
	SDKUnhook(iClient, SDKHook_PreThink, Aimbot_OnClientThink);
	SDKUnhook(iClient, SDKHook_PreThinkPost, Aimbot_OnClientThink);
	SDKUnhook(iClient, SDKHook_PostThink, Aimbot_OnClientThink);
	SDKUnhook(iClient, SDKHook_PostThinkPost, Aimbot_OnClientThink);
}


public Action Chaos_Aimbot_Event_WeaponFire(Event hEvent, const char[] chName, bool g_bbDontBroadcast){
	if (!AimbotEnabled) return Plugin_Continue;
	int iClient = GetClientOfUserId(hEvent.GetInt("userid"));
	int iTarget = GetClosestClient(iClient);
	if (iTarget > 0) LookAtClient(iClient, iTarget);
	return Plugin_Continue;
}

public void Aimbot_OnClientThink(int iClient){
	if (!AimbotEnabled || !IsPlayerAlive(iClient)) return;
	
	int iActiveWeapon = GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon");
	
	if (!IsValidEdict(iActiveWeapon) || iActiveWeapon == -1) return;
	
	// Not sure which Props exist in other games.
	if (GetEngineVersion() == Engine_CSGO || GetEngineVersion() == Engine_CSS){
		// No Spread Addition
		SetEntPropFloat(iActiveWeapon, Prop_Send, "m_fAccuracyPenalty", 0.0);
		if (g_cvRecoilMode == 1){
			SetEntPropVector(iClient, Prop_Send, "m_aimPunchAngle", NULL_VECTOR);
			SetEntPropVector(iClient, Prop_Send, "m_aimPunchAngleVel", NULL_VECTOR);
			SetEntPropVector(iClient, Prop_Send, "m_viewPunchAngle", NULL_VECTOR);
		}
	}
	else{
		SetEntPropVector(iClient, Prop_Send, "m_vecPunchAngle", NULL_VECTOR);
		SetEntPropVector(iClient, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR);
	}
}


public Action Chaos_Aimbot_OnPlayerRunCmd(int iClient, int &iButtons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if (!IsValidClient(iClient) || !AimbotEnabled || !IsPlayerAlive(iClient)) return Plugin_Continue;
	
	int iActiveWeapon = GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon");
	
	if (!IsValidEdict(iActiveWeapon) || iActiveWeapon == -1) return Plugin_Continue;
	
	int iTarget = GetClosestClient(iClient);
	int iClipAmmo = GetEntProp(iActiveWeapon, Prop_Send, "m_iClip1");
	
	if (iClipAmmo > 0 && iTarget > 0) LookAtClient(iClient, iTarget);
	
	// No Spread Addition
	iSeed = 0;
	return Plugin_Changed;
}

stock void LookAtClient(int iClient, int iTarget){
	float fTargetPos[3]; float fTargetAngles[3]; float fClientPos[3]; float fFinalPos[3];
	GetClientEyePosition(iClient, fClientPos);
	GetClientEyePosition(iTarget, fTargetPos);
	GetClientEyeAngles(iTarget, fTargetAngles);
	
	float fVecFinal[3];
	AddInFrontOf(fTargetPos, fTargetAngles, 7.0, fVecFinal);
	MakeVectorFromPoints(fClientPos, fVecFinal, fFinalPos);
	
	GetVectorAngles(fFinalPos, fFinalPos);
	
	//Recoil Control System
	// if (g_cvRecoilMode == 2){
	// 	float vecPunchAngle[3];
		
	// 	if (GetEngineVersion() == Engine_CSGO || GetEngineVersion() == Engine_CSS){
	// 		GetEntPropVector(iClient, Prop_Send, "m_aimPunchAngle", vecPunchAngle);
	// 	} else{
	// 		GetEntPropVector(iClient, Prop_Send, "m_vecPunchAngle", vecPunchAngle);
	// 	}
		
	// 	if(g_cvPredictionConVars[5] != null)
	// 	{
	// 		fFinalPos[0] -= vecPunchAngle[0] * GetConVarFloat(g_cvPredictionConVars[5]);
	// 		fFinalPos[1] -= vecPunchAngle[1] * GetConVarFloat(g_cvPredictionConVars[5]);
	// 	}
	// }

	TeleportEntity(iClient, NULL_VECTOR, fFinalPos, NULL_VECTOR);
}

stock void AddInFrontOf(float fVecOrigin[3], float fVecAngle[3], float fUnits, float fOutPut[3]){
	float fVecView[3]; GetViewVector(fVecAngle, fVecView);
	
	fOutPut[0] = fVecView[0] * fUnits + fVecOrigin[0];
	fOutPut[1] = fVecView[1] * fUnits + fVecOrigin[1];
	fOutPut[2] = fVecView[2] * fUnits + fVecOrigin[2];
}

stock void GetViewVector(float fVecAngle[3], float fOutPut[3]){
	fOutPut[0] = Cosine(fVecAngle[1] / (180 / FLOAT_PI));
	fOutPut[1] = Sine(fVecAngle[1] / (180 / FLOAT_PI));
	fOutPut[2] = -Sine(fVecAngle[0] / (180 / FLOAT_PI));
}

stock int GetClosestClient(int iClient){
	float fClientOrigin[3], fTargetOrigin[3];
	
	GetClientAbsOrigin(iClient, fClientOrigin);
	
	int iClientTeam = GetClientTeam(iClient);
	int iClosestTarget = -1;
	
	float fClosestDistance = -1.0;
	float fTargetDistance;
	
	LoopAlivePlayers(i){
		if (iClient == i || GetClientTeam(i) == iClientTeam) continue;
		GetClientAbsOrigin(i, fTargetOrigin);
		fTargetDistance = GetVectorDistance(fClientOrigin, fTargetOrigin);

		if (fTargetDistance > fClosestDistance && fClosestDistance > -1.0) continue;

		if (ClientCanSeeTarget(iClient, i)){
			if(!IsTargetInSightRange(iClient, i, g_cvFov, 10000.0)) continue;
		}else{
			// Auto aim through walls only at a closer distance
			if(!IsTargetInSightRange(iClient, i, g_cvFov, 400.0)) continue;
		}

		if (GetEngineVersion() == Engine_CSGO){
			if (GetEntPropFloat(i, Prop_Send, "m_fImmuneToGunGameDamageTime") > 0.0) continue;
		}

		fClosestDistance = fTargetDistance;
		iClosestTarget = i;
	}

	return iClosestTarget;
}

stock bool ClientCanSeeTarget(int iClient, int iTarget, float fDistance = 0.0, float fHeight = 50.0){
	float fClientPosition[3]; float fTargetPosition[3];
	
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", fClientPosition);
	fClientPosition[2] += fHeight;
	
	GetClientEyePosition(iTarget, fTargetPosition);
	
	if (fDistance == 0.0 || GetVectorDistance(fClientPosition, fTargetPosition, false) < fDistance){
		// Handle hTrace = TR_TraceRayFilterEx(fClientPosition, fTargetPosition, MASK_SOLID_BRUSHONLY, RayType_EndPoint, Base_TraceFilter);
		Handle hTrace = TR_TraceRayFilterEx(fClientPosition, fTargetPosition, MASK_SOLID, RayType_EndPoint, Base_TraceFilter);
		
		if (TR_DidHit(hTrace)){
			delete hTrace;
			return false;
		}
		
		delete hTrace;
		return true;
	}
	
	return false;
}

public bool Base_TraceFilter(int iEntity, int iContentsMask, int iData){
	return iEntity == iData;
}

// public Action SMAC_OnCheatDetected(int iClient, const char[] chModule, DetectionType dType){
// 	if (!g_bAimbot[iClient]) return Plugin_Continue;
// 	if (dType == Detection_Aimbot || dType == Detection_Eyeangles) return Plugin_Handled;
// 	return Plugin_Continue;
// }

stock bool IsTargetInSightRange(int client, int target, float angle = 90.0, float distance = 0.0, bool heightcheck = true, bool negativeangle = false){
	angle = 360.0;
	if (angle < 0.0) return false;
	
	float clientpos[3];
	float targetpos[3];
	float anglevector[3];
	float targetvector[3];
	float resultangle;
	float resultdistance;
	
	GetClientEyeAngles(client, anglevector);
	anglevector[0] = anglevector[2] = 0.0;
	GetAngleVectors(anglevector, anglevector, NULL_VECTOR, NULL_VECTOR);
	NormalizeVector(anglevector, anglevector);

	if (negativeangle) NegateVector(anglevector);
	
	GetClientAbsOrigin(client, clientpos);
	GetClientAbsOrigin(target, targetpos);
	
	if (heightcheck && distance > 0) resultdistance = GetVectorDistance(clientpos, targetpos);
	
	clientpos[2] = targetpos[2] = 0.0;
	MakeVectorFromPoints(clientpos, targetpos, targetvector);
	NormalizeVector(targetvector, targetvector);
	
	resultangle = RadToDeg(ArcCosine(GetVectorDotProduct(targetvector, anglevector)));
	
	if (resultangle <= angle / 2){
		if (distance > 0){
			if (!heightcheck) resultdistance = GetVectorDistance(clientpos, targetpos);
			
			if (distance >= resultdistance){
				return true;
			}else{
				return false;
			}
		}else{
			 return true;
		}
	}
	
	return false;
}

public void Chaos_Aimbot_Event_PlayerBlind(Handle event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!AimbotEnabled) return;
	
	if (GetEntPropFloat(client, Prop_Send, "m_flFlashMaxAlpha") >= 180.0){
		float duration = GetEntPropFloat(client, Prop_Send, "m_flFlashDuration");
		if (duration >= 1.5){
			g_bFlashed[client] = true;
			CreateTimer(duration, Timer_UnFlashed, client);
		}
	}
}

public Action Timer_UnFlashed(Handle timer, int client){
	g_bFlashed[client] = false;
	return Plugin_Continue;
}
