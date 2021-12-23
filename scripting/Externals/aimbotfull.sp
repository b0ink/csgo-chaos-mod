/*

https://raw.githubusercontent.com/Franc1sco/aimbot/master/scripting/aimbot.sp

	SM Aimbot

	Copyright (C) 2017 Francisco 'Franc1sco' García

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.


*****************************************************************************************************
	AIMBOT
*****************************************************************************************************
Credits: 
		Franc1sco franug 
						http://steamcommunity.com/id/franug
						Intial plugin / idea / improvements.
		
		SM9();  			
						http://steamcommunity.com/id/sm91337/
						Rewrite / improvements.
		
		Headline
						http://steamcommunity.com/id/headline22
						Small API improvments. Wanted some credit, but am not an author.
****************************************************************************************************
CHANGELOG
****************************************************************************************************
	1.0 ~ 
		- First release.
	1.0.1 ~ 
		- Added public cvar.
	1.1 ~
		- Added support for giving aimbot to other players.
	1.2 / 1.3 ~ 
		- Improvements to aimbot.
		- Improvements to CSGO NoRecoil.
	1.4 ~ 
		- Cleaned & rewrote plugin in new Syntax.
		- Much improved NoRecoil for CSGO.
		- Added NoSpread (Not pefect)
		- Send ConVars to client to improve prediction.
	1.4.1 ~ 
		- Fixed incompatbility issue with some games.
	1.5 ~
		- Added Cvar sm_aimbot_everyone (0/1)
					When this Cvar is on, aimbot is auto toggled on everyone including players that join the server.		
		- Added Cvar sm_aimbot_autoaim
					When this Cvar is on the aimbot will auto aim but not auto-fire, this feature will come later.
		- Improved aimbot toggling.
					New usage: sm_aimbot <Player> <0/1> or sm_aimbot will enable for you only.	
		- Fixed Error spam on Weapon_Fire.
		- Further improved clientside prediction for much better No Spread!
		- Protection to prevent SMAC bans.
		- Improved aimbot accuracy slightly.
	1.6 ~
		- Credits to Zipcore + Addicted
		- Added Cvar sm_aimbot_fov (20.0)
					Will only activate aimbot if target is within this fov of client
	 	- Added Cvar sm_aimbot_distance (8000.0)
	 				Will only activate aimbot if target is within this distance of client
	 	- Added Cvar sm_aimbot_flashed (1)
	 				Block aimbot when player is flashed
	 				
	1.7 ~
		- Credits to Poheart
		- Added Cvar sm_aimbot_norecoil (0/1/2)
					Allow which recoil control mode the aimbot should be used.
					0 = Disable recoil control
					1 = Server recoil remove
					2 = Auto-Spray control (Recoil Control System)
	1.7.1 ~
		- Improved No Recoil when sm_aimbot_norecoil 1 (No more screen shaking)
		- Prevent trying to send ConVars to Fake clients (Should fix some errors)
		- Only send recoil convars if sm_aimbot_norecoil 1 otherwise let RCS do its magic.
		- Removed sending a ConVar which does not work.
	
	1.7.2 ~
		- Improved support for other games.
		- Improved ConVar change hooks.
		- Improved No recoil on other games (Maybe)
	1.7.3 ~
		- Fix error on TF2 related to a netprop not existing.
		- Further improve support on games other than CSGO.
	1.8 ~
		- Major syntax overhaul
		- Code cleaning
		- Removed depreciated CVAR flag
		- Added Cvar sm_aimbot_text (0/1)
				Controls if the plugin should be allowed to write to users when they connect
				1 = Enable text (default)
				0 = Disable text
	1.8.1 ~
		- Fixed a bug where you need smac installed, no is totally optional.
		- Now you can use the aimbot against bot (again).

****************************************************************************************************
INCLUDES
***************************************************************************************************/
// #include <sourcemod>
// #include <sdktools>
// #include <sdkhooks>



/****************************************************************************************************
ETIQUETTE.
*****************************************************************************************************/
// #pragma newdecls required
// #pragma semicolon 1

#define VERSION "1.8.1"

/****************************************************************************************************
BOOLS.
*****************************************************************************************************/
bool g_bAimbot[MAXPLAYERS + 1] = false;
bool g_bFlashed[MAXPLAYERS + 1] = false;


/****************************************************************************************************
CONVARS.
*****************************************************************************************************/

ConVar g_cvPredictionConVars[9] = {null, ...};
// ConVar g_cvAimbotAutoAim = null;


int g_cvAimbotAutoAim = 1;
int g_cvRecoilMode = 1;
float g_cvFov = 20.0;
float g_cvDistance = 8000.0;
bool g_bg_cvFlashbang = true;
// bool g_bg_cvShowText = true;

// public Plugin myinfo = 
// {
// 	name = "SM Aimbot", 
// 	author = "Franc1sco franug", 
// 	description = "Give you a legal aimbot made by sourcemod", 
// 	version = VERSION, 
// 	url = "http://steamcommunity.com/id/franug"
// };

	// CreateConVar("sm_aimbot_version", VERSION, "", FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);
	
	// g_cvAimbotEveryone = CreateConVar("sm_aimbot_everyone", "0", "Aimbot everyone");
	// g_cvAimbotAutoAim = CreateConVar("sm_aimbot_autoaim", "1", "Aimbot auto aim");
	// g_cvRecoilMode = CreateConVar("sm_aimbot_norecoil", "1", "Aimbot recoil control - 0 = disable, 1 = remove recoil, 2 = recoil control system");
	// g_cvFov = CreateConVar("sm_aimbot_fov", "20.0", "Will only activate aimbot if target is within this fov of client (1.0 to disable)");
	// g_cvDistance = CreateConVar("sm_aimbot_distance", "8000.0", "Will only activate aimbot if target is within this distance of client (1.0 to disable)");

	// g_cvFlashbang = CreateConVar("sm_aimbot_flashed", "1", "Block aimbot when player is flashed");
	// g_cvShowText = CreateConVar("sm_aimbot_text", "1", "Enables whether the plugin writes text to users. Set to 0 to hide plugin");
	public void aimbot_init(){
		HookEventEx("weapon_fire", Aimbot_Event_WeaponFire, EventHookMode_Pre);
		HookEventEx("player_blind", Aimbot_Event_PlayerBlind, EventHookMode_Pre);
			
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
	

// public void OnClientPostAdminCheck(int iClient)
// {
	
// }


// ToggleAim(iClient2, bEnable);

stock void ToggleAim(int iClient, bool g_bbEnabled = false)
{
	// Toggle aimbot.
	Aimbot[iClient] = bEnabled;
	
	// Ignore bots or clients that are not ingame from here.
	if (IsFakeClient(iClient) || !IsClientInGame(iClient))
	{
		return;
	}
	
	// Print client message.
	// if (g_cvShowText)
	// {
	// 	PrintToChat(iClient, "[SM] Aimbot has been %s for you.", Aimbot[iClient] ? "Enabled":"Disabled");
	// }
	
	// Fix some prediction issues.
	char chValues[10];
	
	if (g_cvPredictionConVars[0] != null)
	{
		IntToString(((Aimbot[iClient] && g_cvRecoilMode == 1)) ? 1 : g_cvPredictionConVars[0].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[0], chValues);
	}
	
	if (g_cvPredictionConVars[1] != null)
	{
		IntToString((Aimbot[iClient] && g_cvRecoilMode == 1) ? 0 : g_cvPredictionConVars[1].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[1], chValues);
	}
	
	if (g_cvPredictionConVars[2] != null)
	{
		IntToString((Aimbot[iClient] && g_cvRecoilMode == 1) ? 99999 : g_cvPredictionConVars[2].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[2], chValues);
	}
	
	if (g_cvPredictionConVars[3] != null)
	{
		IntToString((Aimbot[iClient] && g_cvRecoilMode == 1) ? 99999 : g_cvPredictionConVars[3].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[3], chValues);
	}
	
	if (g_cvPredictionConVars[4] != null)
	{
		IntToString((Aimbot[iClient] && g_cvRecoilMode == 1) ? 99999 : g_cvPredictionConVars[4].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[4], chValues);
	}
	
	if (g_cvPredictionConVars[5] != null)
	{
		IntToString((Aimbot[iClient] && g_cvRecoilMode == 1) ? 0 : g_cvPredictionConVars[5].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[5], chValues);
	}
	
	if (g_cvPredictionConVars[6] != null)
	{
		IntToString((Aimbot[iClient] && g_cvRecoilMode == 1) ? 500 : g_cvPredictionConVars[6].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[6], chValues);
	}
	
	if (g_cvPredictionConVars[7] != null)
	{
		IntToString((Aimbot[iClient] && g_cvRecoilMode == 1) ? 0 : g_cvPredictionConVars[7].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[7], chValues);
	}
	
	if (g_cvPredictionConVars[8] != null)
	{
		IntToString((Aimbot[iClient] && g_cvRecoilMode == 1) ? 0 : g_cvPredictionConVars[8].IntValue, chValues, 10);
		SendConVarValue(iClient, g_cvPredictionConVars[8], chValues);
	}
}

public Action Aimbot_Event_WeaponFire(Event hEvent, const char[] chName, bool g_bbDontBroadcast)
{
	int iClient = GetClientOfUserId(hEvent.GetInt("userid"));
	
	if (!Aimbot[iClient])
	{
		return Plugin_Continue;
	}

	int iTarget = GetClosestClient(iClient);
	
	if (iTarget > 0)
	{
		LookAtClient(iClient, iTarget);
	}
	
	return Plugin_Continue;
}

public void Aimbot_OnClientThink(int iClient)
{
	if (!Aimbot[iClient] || !IsPlayerAlive(iClient))
	{
		return;
	}
	
	int iActiveWeapon = GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon");
	
	if (!IsValidEdict(iActiveWeapon) || iActiveWeapon == -1) 
	{
		return;
	}
	
	// Not sure which Props exist in other games.
	if (GetEngineVersion() == Engine_CSGO || GetEngineVersion() == Engine_CSS)
	{
		
		// No Spread Addition
		SetEntPropFloat(iActiveWeapon, Prop_Send, "m_fAccuracyPenalty", 0.0);
		
		if (g_cvRecoilMode == 1)
		{
			SetEntPropVector(iClient, Prop_Send, "m_aimPunchAngle", NULL_VECTOR);
			SetEntPropVector(iClient, Prop_Send, "m_aimPunchAngleVel", NULL_VECTOR);
			SetEntPropVector(iClient, Prop_Send, "m_viewPunchAngle", NULL_VECTOR);
		}
	}
	else
	{
		SetEntPropVector(iClient, Prop_Send, "m_vecPunchAngle", NULL_VECTOR);
		SetEntPropVector(iClient, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR);
	}
}


// public Action OnPlayerRunCmd(int iClient, int &iButtons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed)
public Action Aimbot_OnPlayerRunCmd(int iClient, int &iButtons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed)
{
	if (!IsValidClient(iClient) || !Aimbot[iClient] || !IsPlayerAlive(iClient))
	{
		return Plugin_Continue;
	}
	
	int iActiveWeapon = GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon");
	
	if (!IsValidEdict(iActiveWeapon) || iActiveWeapon == -1)
	{
		return Plugin_Continue;
	}
	
	if ((iButtons & IN_ATTACK) == IN_ATTACK || g_cvAimbotAutoAim)
	{
		int iTarget = GetClosestClient(iClient);
		int iClipAmmo = GetEntProp(iActiveWeapon, Prop_Send, "m_iClip1");
		
		if (iClipAmmo > 0 && iTarget > 0)
		{
			LookAtClient(iClient, iTarget);
		}
	}
	
	// No Spread Addition
	iSeed = 0;
	return Plugin_Changed;
}

stock void LookAtClient(int iClient, int iTarget)
{
	float fTargetPos[3]; float fTargetAngles[3]; float fClientPos[3]; float fFinalPos[3];
	GetClientEyePosition(iClient, fClientPos);
	GetClientEyePosition(iTarget, fTargetPos);
	GetClientEyeAngles(iTarget, fTargetAngles);
	
	float fVecFinal[3];
	AddInFrontOf(fTargetPos, fTargetAngles, 7.0, fVecFinal);
	MakeVectorFromPoints(fClientPos, fVecFinal, fFinalPos);
	
	GetVectorAngles(fFinalPos, fFinalPos);
	
	//Recoil Control System
	if (g_cvRecoilMode == 2)
	{
		float vecPunchAngle[3];
		
		if (GetEngineVersion() == Engine_CSGO || GetEngineVersion() == Engine_CSS)
		{
			GetEntPropVector(iClient, Prop_Send, "m_aimPunchAngle", vecPunchAngle);
		}
		else
		{
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

stock void AddInFrontOf(float fVecOrigin[3], float fVecAngle[3], float fUnits, float fOutPut[3])
{
	float fVecView[3]; GetViewVector(fVecAngle, fVecView);
	
	fOutPut[0] = fVecView[0] * fUnits + fVecOrigin[0];
	fOutPut[1] = fVecView[1] * fUnits + fVecOrigin[1];
	fOutPut[2] = fVecView[2] * fUnits + fVecOrigin[2];
}

stock void GetViewVector(float fVecAngle[3], float fOutPut[3])
{
	fOutPut[0] = Cosine(fVecAngle[1] / (180 / FLOAT_PI));
	fOutPut[1] = Sine(fVecAngle[1] / (180 / FLOAT_PI));
	fOutPut[2] = -Sine(fVecAngle[0] / (180 / FLOAT_PI));
}

stock int GetClosestClient(int iClient)
{
	float fClientOrigin[3], fTargetOrigin[3];
	
	GetClientAbsOrigin(iClient, fClientOrigin);
	
	int iClientTeam = GetClientTeam(iClient);
	int iClosestTarget = -1;
	
	float fClosestDistance = -1.0;
	float fTargetDistance;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			if (iClient == i || GetClientTeam(i) == iClientTeam || !IsPlayerAlive(i))
			{
				continue;
			}
			
			GetClientAbsOrigin(i, fTargetOrigin);
			fTargetDistance = GetVectorDistance(fClientOrigin, fTargetOrigin);

			if (fTargetDistance > fClosestDistance && fClosestDistance > -1.0)
			{
				continue;
			}

			if (!ClientCanSeeTarget(iClient, i))
			{
				continue;
			}

			if (GetEngineVersion() == Engine_CSGO)
			{
				if (GetEntPropFloat(i, Prop_Send, "m_fImmuneToGunGameDamageTime") > 0.0)
				{
					continue;
				}
			}

			if (g_cvDistance != 0.0 && fTargetDistance > g_cvDistance)
			{
				continue;
			}
			
			if (g_cvFov != 0.0 && !IsTargetInSightRange(iClient, i, g_cvFov, g_cvDistance))
			{
				continue;
			}
			
			if (g_cvFlashbang && Flashed[iClient])
			{
				continue;
			}
			
			fClosestDistance = fTargetDistance;
			iClosestTarget = i;
		}
	}
	
	return iClosestTarget;
}

stock bool g_bClientCanSeeTarget(int iClient, int iTarget, float fDistance = 0.0, float fHeight = 50.0)
{
	float fClientPosition[3]; float fTargetPosition[3];
	
	GetEntPropVector(iClient, Prop_Send, "m_vecOrigin", fClientPosition);
	fClientPosition[2] += fHeight;
	
	GetClientEyePosition(iTarget, fTargetPosition);
	
	if (fDistance == 0.0 || GetVectorDistance(fClientPosition, fTargetPosition, false) < fDistance)
	{
		Handle hTrace = TR_TraceRayFilterEx(fClientPosition, fTargetPosition, MASK_SOLID_BRUSHONLY, RayType_EndPoint, Base_TraceFilter);
		
		if (TR_DidHit(hTrace))
		{
			delete hTrace;
			return false;
		}
		
		delete hTrace;
		return true;
	}
	
	return false;
}

public bool g_bBase_TraceFilter(int iEntity, int iContentsMask, int iData)
{
	return iEntity == iData;
}

public Action SMAC_OnCheatDetected(int iClient, const char[] chModule, DetectionType dType)
{
	if (!Aimbot[iClient])
	{
		return Plugin_Continue;
	}
	
	if (dType == Detection_Aimbot || dType == Detection_Eyeangles)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

// stock bool g_bIsValidClient(int client, bool g_bbAllowBots = true, bool g_bbAllowDead = false)
// {
// 	if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bAllowDead && !IsPlayerAlive(client)))
// 	{
// 		return false;
// 	}
// 	return true;
// }

stock bool g_bIsTargetInSightRange(int client, int target, float angle = 90.0, float distance = 0.0, bool g_bheightcheck = true, bool g_bnegativeangle = false)
{
	if (angle > 360.0)
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

public Action Aimbot_Event_PlayerBlind(Handle event, const char[] name, bool g_bdontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (GetEntPropFloat(client, Prop_Send, "m_flFlashMaxAlpha") >= 180.0)
	{
		float duration = GetEntPropFloat(client, Prop_Send, "m_flFlashDuration");
		if (duration >= 1.5)
		{
			Flashed[client] = true;
			CreateTimer(duration, UnFlashed_Timer, client);
		}
	}
}

public Action UnFlashed_Timer(Handle timer, int client)
{
	Flashed[client] = false;
}
