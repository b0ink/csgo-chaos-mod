/* CREDIT: https://raw.githubusercontent.com/Franc1sco/aimbot/master/scripting/aimbot.sp */

/****************************************************************************************************
BOOLS.
*****************************************************************************************************/
bool g_bAimbot[MAXPLAYERS + 1] = false;
bool g_bFlashed[MAXPLAYERS + 1] = false;


/****************************************************************************************************
CONVARS.
*****************************************************************************************************/

ConVar g_cvPredictionConVars[9] = {null, ...};

int g_cvAimbotAutoAim = 1;
int g_cvRecoilMode = 1;
float g_cvFov = 20.0;
float g_cvDistance = 10000.0;
bool g_bCvFlashbang = true;

public void Chaos_Aimbot_INIT(){

	g_cvPredictionConVars[0] = FindConVar("weapon_accuracy_nospread");
	g_cvPredictionConVars[1] = FindConVar("weapon_recoil_cooldown");
	g_cvPredictionConVars[2] = FindConVar("weapon_recoil_decay1_exp");
	g_cvPredictionConVars[3] = FindConVar("weapon_recoil_decay2_exp");
	g_cvPredictionConVars[4] = FindConVar("weapon_recoil_decay2_lin");
	g_cvPredictionConVars[5] = FindConVar("weapon_recoil_scale");
	g_cvPredictionConVars[6] = FindConVar("weapon_recoil_suppression_shots");
	g_cvPredictionConVars[7] = FindConVar("weapon_recoil_variance");
	g_cvPredictionConVars[8] = FindConVar("weapon_recoil_view_punch_extra");
}

public void Chaos_Aimbot_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			Aimbot_SDKHOOKS(i);
			ToggleAim(i, true);
		}
	}
}

public Action Chaos_Aimbot_RESET(bool HasTimerEnded){
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				Aimbot_REMOVE_SDKHOOKS(i);
				ToggleAim(i, false);
			}
		}
}



public bool Chaos_Aimbot_Conditions(){
	return true;
}


	
// g_cvRecoilMode = CreateConVar("sm_aimbot_norecoil", "1", "Aimbot recoil control - 0 = disable, 1 = remove recoil, 2 = recoil control system");

public void Aimbot_SDKHOOKS(int iClient){
	SDKHook(iClient, SDKHook_PreThink, Aimbot_OnClientThink);
	SDKHook(iClient, SDKHook_PreThinkPost, Aimbot_OnClientThink);
	SDKHook(iClient, SDKHook_PostThink, Aimbot_OnClientThink);
	SDKHook(iClient, SDKHook_PostThinkPost, Aimbot_OnClientThink);
	// ToggleAim(iClient, g_cvAimbotEveryone.BoolValue);
}

public void Aimbot_REMOVE_SDKHOOKS(int iClient){
	SDKUnhook(iClient, SDKHook_PreThink, Aimbot_OnClientThink);
	SDKUnhook(iClient, SDKHook_PreThinkPost, Aimbot_OnClientThink);
	SDKUnhook(iClient, SDKHook_PostThink, Aimbot_OnClientThink);
	SDKUnhook(iClient, SDKHook_PostThinkPost, Aimbot_OnClientThink);
	// ToggleAim(iClient, g_cvAimbotEveryone.BoolValue);
}


stock void ToggleAim(int iClient, bool bEnabled = false)
{
	// Toggle aimbot.
	g_bAimbot[iClient] = bEnabled;
	
	// Ignore bots or clients that are not ingame from here.
	if (IsFakeClient(iClient) || !IsClientInGame(iClient)) return;
	
	// Fix some prediction issues.
	char chValues[10];
	
	if (g_cvPredictionConVars[0] != null){
		IntToString(((g_bAimbot[iClient] && g_cvRecoilMode == 1)) ? 1 : g_cvPredictionConVars[0].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[0], chValues);
	}
	
	if (g_cvPredictionConVars[1] != null){
		IntToString((g_bAimbot[iClient] && g_cvRecoilMode == 1) ? 0 : g_cvPredictionConVars[1].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[1], chValues);
	}
	
	if (g_cvPredictionConVars[2] != null){
		IntToString((g_bAimbot[iClient] && g_cvRecoilMode == 1) ? 99999 : g_cvPredictionConVars[2].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[2], chValues);
	}
	
	if (g_cvPredictionConVars[3] != null){
		IntToString((g_bAimbot[iClient] && g_cvRecoilMode == 1) ? 99999 : g_cvPredictionConVars[3].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[3], chValues);
	}
	
	if (g_cvPredictionConVars[4] != null){
		IntToString((g_bAimbot[iClient] && g_cvRecoilMode == 1) ? 99999 : g_cvPredictionConVars[4].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[4], chValues);
	}
	
	if (g_cvPredictionConVars[5] != null){
		IntToString((g_bAimbot[iClient] && g_cvRecoilMode == 1) ? 0 : g_cvPredictionConVars[5].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[5], chValues);
	}
	
	if (g_cvPredictionConVars[6] != null){
		IntToString((g_bAimbot[iClient] && g_cvRecoilMode == 1) ? 500 : g_cvPredictionConVars[6].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[6], chValues);
	}
	
	if (g_cvPredictionConVars[7] != null){
		IntToString((g_bAimbot[iClient] && g_cvRecoilMode == 1) ? 0 : g_cvPredictionConVars[7].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[7], chValues);
	}
	
	if (g_cvPredictionConVars[8] != null){
		IntToString((g_bAimbot[iClient] && g_cvRecoilMode == 1) ? 0 : g_cvPredictionConVars[8].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[8], chValues);
	}
}

public Action Chaos_Aimbot_Event_WeaponFire(Event hEvent, const char[] chName, bool g_bbDontBroadcast){
	int iClient = GetClientOfUserId(hEvent.GetInt("userid"));
	if (!g_bAimbot[iClient]) return Plugin_Continue;
	int iTarget = GetClosestClient(iClient);
	if (iTarget > 0) LookAtClient(iClient, iTarget);
	return Plugin_Continue;
}

public void Aimbot_OnClientThink(int iClient){
	if (!g_bAimbot[iClient] || !IsPlayerAlive(iClient)) return;
	
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


public Action Chaos_Aimbot_OnPlayerRunCmd(int iClient, int &iButtons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if (!IsValidClient(iClient) || !g_bAimbot[iClient] || !IsPlayerAlive(iClient)) return Plugin_Continue;
	
	int iActiveWeapon = GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon");
	
	if (!IsValidEdict(iActiveWeapon) || iActiveWeapon == -1) return Plugin_Continue;
	
	if ((iButtons & IN_ATTACK) == IN_ATTACK || g_cvAimbotAutoAim){
		int iTarget = GetClosestClient(iClient);
		int iClipAmmo = GetEntProp(iActiveWeapon, Prop_Send, "m_iClip1");
		
		if (iClipAmmo > 0 && iTarget > 0) LookAtClient(iClient, iTarget);
	}
	
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
	if (g_cvRecoilMode == 2){
		float vecPunchAngle[3];
		
		if (GetEngineVersion() == Engine_CSGO || GetEngineVersion() == Engine_CSS){
			GetEntPropVector(iClient, Prop_Send, "m_aimPunchAngle", vecPunchAngle);
		} else{
			GetEntPropVector(iClient, Prop_Send, "m_vecPunchAngle", vecPunchAngle);
		}
		
		if(g_cvPredictionConVars[5] != null)
		{
			fFinalPos[0] -= vecPunchAngle[0] * GetConVarFloat(g_cvPredictionConVars[5]);
			fFinalPos[1] -= vecPunchAngle[1] * GetConVarFloat(g_cvPredictionConVars[5]);
		}
	}

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
	
	for (int i = 1; i <= MaxClients; i++){
		if (IsValidClient(i)){
			if (iClient == i || GetClientTeam(i) == iClientTeam || !IsPlayerAlive(i)) continue;
			
			GetClientAbsOrigin(i, fTargetOrigin);
			fTargetDistance = GetVectorDistance(fClientOrigin, fTargetOrigin);

			if (fTargetDistance > fClosestDistance && fClosestDistance > -1.0) continue;

			if (!ClientCanSeeTarget(iClient, i)) continue;

			if (GetEngineVersion() == Engine_CSGO){
				if (GetEntPropFloat(i, Prop_Send, "m_fImmuneToGunGameDamageTime") > 0.0) continue;
			}

			// if (g_cvDistance != 0.0 && fTargetDistance > g_cvDistance) continue;
			if (g_cvFov != 0.0 && !IsTargetInSightRange(iClient, i, g_cvFov, g_cvDistance)) continue;
			if (g_bCvFlashbang && g_bFlashed[iClient]) continue;
			
			fClosestDistance = fTargetDistance;
			iClosestTarget = i;
		}
	}
	
	return iClosestTarget;
}

stock bool ClientCanSeeTarget(int iClient, int iTarget, float fDistance = 0.0, float fHeight = 50.0){
	float fClientPosition[3]; float fTargetPosition[3];
	
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", fClientPosition);
	fClientPosition[2] += fHeight;
	
	GetClientEyePosition(iTarget, fTargetPosition);
	
	if (fDistance == 0.0 || GetVectorDistance(fClientPosition, fTargetPosition, false) < fDistance){
		Handle hTrace = TR_TraceRayFilterEx(fClientPosition, fTargetPosition, MASK_SOLID_BRUSHONLY, RayType_EndPoint, Base_TraceFilter);
		
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

public Action SMAC_OnCheatDetected(int iClient, const char[] chModule, DetectionType dType){
	if (!g_bAimbot[iClient]) return Plugin_Continue;
	if (dType == Detection_Aimbot || dType == Detection_Eyeangles) return Plugin_Handled;
	return Plugin_Continue;

}

stock bool IsTargetInSightRange(int client, int target, float angle = 90.0, float distance = 0.0, bool heightcheck = true, bool negativeangle = false){
	// if (angle > 360.0)
	angle = 360.0;
	
	if (angle < 0.0)
		return false;
	
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
	if (negativeangle)
		NegateVector(anglevector);
	
	GetClientAbsOrigin(client, clientpos);
	GetClientAbsOrigin(target, targetpos);
	
	if (heightcheck && distance > 0)
		resultdistance = GetVectorDistance(clientpos, targetpos);
	
	clientpos[2] = targetpos[2] = 0.0;
	MakeVectorFromPoints(clientpos, targetpos, targetvector);
	NormalizeVector(targetvector, targetvector);
	
	resultangle = RadToDeg(ArcCosine(GetVectorDotProduct(targetvector, anglevector)));
	
	if (resultangle <= angle / 2)
	{
		if (distance > 0)
		{
			if (!heightcheck)
				resultdistance = GetVectorDistance(clientpos, targetpos);
			
			if (distance >= resultdistance)
				return true;
			else return false;
		}
		else return true;
	}
	
	return false;
}

public Action Chaos_Aimbot_Event_PlayerBlind(Handle event, const char[] name, bool dontBroadcast)
{
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!g_bAimbot[client]) return;
	
	if (GetEntPropFloat(client, Prop_Send, "m_flFlashMaxAlpha") >= 180.0)
	{
		float duration = GetEntPropFloat(client, Prop_Send, "m_flFlashDuration");
		if (duration >= 1.5)
		{
			g_bFlashed[client] = true;
			CreateTimer(duration, UnFlashed_Timer, client);
		}
	}
}

public Action UnFlashed_Timer(Handle timer, int client){
	g_bFlashed[client] = false;
}
