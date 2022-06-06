#include <sourcemod>
#include <sdkhooks>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "Dynamic Game_Text Channels",
	author = "Vauff",
	description = "Provides a native for plugins to implement that handles automatic game_text channel assignment based on current map channels",
	version = "2.1",
	url = "https://github.com/Vauff/DynamicChannels"
};

Handle g_hAcceptInput;
ConVar g_cvWarnings;

int g_iGroupChannels[] = {-1, -1, -1, -1, -1, -1};

bool g_bChannelsOverflowing = false;
bool g_bBadMapChannels = false;
bool g_bMapChannels[6] = false;
bool g_bNotifiedBadChans[MAXPLAYERS + 1] = false;
bool g_bNotifiedOverflow[MAXPLAYERS + 1] = false;

public void OnPluginStart()
{
	g_cvWarnings = CreateConVar("sm_dynamic_channels_warnings", "1", "Should channel overflow & bad channel warnings be sent to root admins?");

	RegAdminCmd("sm_debugchannels", Command_DebugChannels, ADMFLAG_ROOT, "Prints debugging information to console about the current states of game_text channels");
	AutoExecConfig(true, "DynamicChannels");
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("GetDynamicChannel", Native_GetDynamicChannel);
	RegPluginLibrary("DynamicChannels");

	return APLRes_Success;
}

public void OnAllPluginsLoaded()
{
	Handle gameData = LoadGameConfigFile("sdktools.games");

	if (gameData == INVALID_HANDLE)
		SetFailState("Can't find sdktools gamedata! Please verify your SM installation.");

	int offset = GameConfGetOffset(gameData, "AcceptInput");

	if (offset == -1)
		SetFailState("Failed to find AcceptInput offset in sdktools gamedata! Please verify your SM installation.");

	// bool CBaseEntity::AcceptInput( const char *szInputName, CBaseEntity *pActivator, CBaseEntity *pCaller, variant_t Value, int outputID )
	// game/server/baseentity.cpp line 4457 (in 2017 csgo source code leak)
	g_hAcceptInput = DHookCreate(offset, HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity, AcceptInput);
	DHookAddParam(g_hAcceptInput, HookParamType_CharPtr);
	DHookAddParam(g_hAcceptInput, HookParamType_CBaseEntity);
	DHookAddParam(g_hAcceptInput, HookParamType_CBaseEntity);
	DHookAddParam(g_hAcceptInput, HookParamType_Object, 20, DHookPass_ByVal|DHookPass_ODTOR|DHookPass_OCTOR|DHookPass_OASSIGNOP); //variant_t is a union of 12 (float[3]) plus two int type params 12 + 8 = 20
	DHookAddParam(g_hAcceptInput, HookParamType_Int);

	CloseHandle(gameData);
}

public void OnMapStart()
{
	g_bChannelsOverflowing = false;
	g_bBadMapChannels = false;
	g_iGroupChannels = {-1, -1, -1, -1, -1, -1};

	for (int i = 0; i < sizeof(g_bMapChannels); i++)
		g_bMapChannels[i] = false;

	CreateTimer(30.0, MsgAdminTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void OnClientPutInServer(int client)
{
	g_bNotifiedBadChans[client] = false;
	g_bNotifiedOverflow[client] = false;
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (!StrEqual(classname, "game_text"))
		return;

	DHookEntity(g_hAcceptInput, true, entity);

	// Get channel from the game_text when it spawns
	SDKHook(entity, SDKHook_SpawnPost, GameTextSpawn);
}

public Action GameTextSpawn(int entity)
{
	AddMapChannel(GetEntProp(entity, Prop_Data, "m_textParms.channel"));
}

public MRESReturn AcceptInput(int pThis, Handle hReturn, Handle hParams)
{
	char input[128];
	DHookGetParamString(hParams, 1, input, sizeof(input));

	if (StrEqual("AddOutput", input, false))
	{
		char parameter[256];
		char splitParameter[256];

		DHookGetParamObjectPtrString(hParams, 4, 0, ObjectValueType_String, parameter, sizeof(parameter));
		SplitString(parameter, " ", splitParameter, sizeof(splitParameter));

		if (StrEqual(splitParameter, "channel", false))
		{
			AddMapChannel(GetEntProp(pThis, Prop_Data, "m_textParms.channel"));
			return MRES_Handled;
		}
	}

	return MRES_Ignored;
}

public Action Command_DebugChannels(int client, int args)
{
	if (client != 0)
		PrintToChat(client, " \x02[Dynamic Channels] \x07See console for channel debug output");

	PrintToConsole(client, "------------- [Dynamic Channels] -------------");

	for (int i = 0; i < 6; i++)
	{
		char groupStatus[64];
		Format(groupStatus, sizeof(groupStatus), "Assigned to channel %i", g_iGroupChannels[i]);
		PrintToConsole(client, "Plugin Group %i: %s", i, (g_iGroupChannels[i] == -1) ? "Free" : groupStatus);
	}

	PrintToConsole(client, "----------------------------------------------");

	for (int i = 0; i < 6; i++)
		PrintToConsole(client, "Map Channel %i: %s", i, g_bMapChannels[i] ? "Used" : "Free");

	PrintToConsole(client, "----------------------------------------------");
	PrintToConsole(client, "Channels Overflowing: %s", g_bChannelsOverflowing ? "Yes" : "No");
	PrintToConsole(client, "Bad Map Channels: %s", g_bBadMapChannels ? "Yes" : "No");
	PrintToConsole(client, "----------------------------------------------");

	return Plugin_Handled;
}

public int Native_GetDynamicChannel(Handle plugin, int params)
{
	int group = GetNativeCell(1);

	if (group > 5 || group < 0)
	{
		ThrowNativeError(SP_ERROR_NATIVE, "Dynamic channel group number must be between 0 and 5!");
		return -1;
	}

	if (g_iGroupChannels[group] != -1)
		return g_iGroupChannels[group];

	int channel = -1;

	for (int i = 0; i < sizeof(g_bMapChannels); i++)
	{
		if (!g_bMapChannels[i])
		{
			bool channelUsed = false;

			for (int j = 0; j < sizeof(g_iGroupChannels); j++)
			{
				if (i == g_iGroupChannels[j])
				{
					channelUsed = true;
					break;
				}
			}

			if (!channelUsed)
			{
				channel = i;
				break;
			}
		}
	}

	if (channel == -1)
	{
		if (g_cvWarnings.BoolValue && !g_bChannelsOverflowing)
		{
			char map[128];

			GetCurrentMap(map, sizeof(map));
			LogMessage("game_text channels are overflowing! Consider reducing the amount of channels used by %s or plugins", map);
		}

		g_bChannelsOverflowing = true;
		channel = 0;

		while (channel < 6)
		{
			bool keepSearching = false;

			for (int i = 0; i < sizeof(g_iGroupChannels); i++)
			{
				if (g_iGroupChannels[i] == channel)
				{
					if (channel == 5)
					{
						ThrowNativeError(SP_ERROR_NATIVE, "Something went very wrong! Please report this issue with the following information: game, map name, plugin version, and sm_debugchannels output");
						return -1;
					}

					channel++;
					keepSearching = true;
					break;
				}
			}

			if (!keepSearching)
				break;
		}
	}

	g_iGroupChannels[group] = channel;
	return channel;
}

public Action MsgAdminTimer(Handle timer)
{
	if (!g_cvWarnings.BoolValue)
		return Plugin_Continue;

	for (int client = 1; client <= MaxClients; client++)
	{
		if (!IsValidClient(client) || !CheckCommandAccess(client, "", ADMFLAG_ROOT))
			continue;

		if (g_bChannelsOverflowing && !g_bNotifiedOverflow[client])
		{
			PrintToChat(client, " \x02[Dynamic Channels] \x07game_text channels are overflowing! Consider reducing the amount of channels used by the map or plugins");
			g_bNotifiedOverflow[client] = true;
		}
		if (g_bBadMapChannels && !g_bNotifiedBadChans[client])
		{
			PrintToChat(client, " \x02[Dynamic Channels] \x07This map is using bad channel numbers! It is highly recommended to fix this with stripper to prevent the game auto-assigning the channel and causing conflicts");
			g_bNotifiedBadChans[client] = true;
		}
	}

	return Plugin_Continue;
}

void AddMapChannel(int channel)
{
	if (channel <= 5 && channel >= 0)
	{
		if (!g_bMapChannels[channel])
		{
			g_bMapChannels[channel] = true;

			// Map channels have changed, we must now force all plugin group channels to be recalculated
			g_iGroupChannels = {-1, -1, -1, -1, -1, -1};
		}
	}
	else
	{
		if (g_cvWarnings.BoolValue && !g_bBadMapChannels)
		{
			char map[128];

			GetCurrentMap(map, sizeof(map));
			LogMessage("%s is using bad channel numbers! It is highly recommended to fix this with stripper to prevent the game auto-assigning the channel and causing conflicts", map);
		}

		g_bBadMapChannels = true;
	}
}

bool IsValidClient(int client, bool nobots = false)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
		return false;

	return IsClientInGame(client);
}