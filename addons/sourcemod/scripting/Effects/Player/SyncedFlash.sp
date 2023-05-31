#pragma semicolon 1

#define FFADE_IN (0x0001)	   // Fade in
#define FFADE_OUT (0x0002)	   // Fade out
#define FFADE_PURGE (0x0010)   // Purges all other fades, replacing them with this one
#define FFADE_STAYOUT (0x0008) // Ignores the duration, stays faded out until a new fade message is received

int	 g_iDuration;
int	 g_iFlashMaxAlpha;

bool SyncedFlash = false;
bool inFlash[MAXPLAYERS + 1];

public void Chaos_SyncedFlash(EffectData effect) {
	effect.Title = "Synced Team Flash";
	effect.Duration = 30;

	effect.IncompatibleWith("Chaos_ForceReload");

	g_iDuration = FindSendPropInfo("CCSPlayer", "m_flFlashDuration");
	g_iFlashMaxAlpha = FindSendPropInfo("CCSPlayer", "m_flFlashMaxAlpha");

	HookEvent("player_blind", Chaos_SyncedFlash_Event_PlayerBlind);
}

public Action Chaos_SyncedFlash_Event_PlayerBlind(Event event, const char[] name, bool dontBroadcast) {
	if(!SyncedFlash) return Plugin_Continue;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(ValidAndAlive(client)) {
		float duration = GetEntPropFloat(client, Prop_Send, "m_flFlashDuration");
		LoopAlivePlayers(i) {
			if(client == i) continue;
			if(GetClientTeam(i) == GetClientTeam(client)) {
				PrintCenterText(i, "%N was flashed for %.1f seconds!", client, duration);
				DoFlashEffect(i, duration);
			}
		}
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public void Chaos_SyncedFlash_START() {
	SyncedFlash = true;
	PrintHintTextToAll("When a teammate gets flashed, the whole team gets flashed!");
	LoopAllClients(i) {
		inFlash[i] = false;
	}
}

public void Chaos_SyncedFlash_RESET() {
	SyncedFlash = false;
}

void DoFlashEffect(int client, float duration) {
	if(inFlash[client]) return;
	inFlash[client] = true;

	int	   color[4] = {255, 255, 255, 255};

	Handle message = StartMessageOne("Fade", client);

	if(GetUserMessageType() == UM_Protobuf) {
		PbSetInt(message, "duration", 100);
		PbSetInt(message, "hold_time", view_as<int>(duration));
		PbSetInt(message, "flags", FFADE_OUT | FFADE_PURGE);
		PbSetColor(message, "clr", color);
	} else {
		BfWriteShort(message, 100);
		BfWriteShort(message, view_as<int>(duration));
		BfWriteShort(message, FFADE_OUT | FFADE_PURGE);
		BfWriteByte(message, color[0]);
		BfWriteByte(message, color[1]);
		BfWriteByte(message, color[2]);
		BfWriteByte(message, color[3]);
	}

	EndMessage();
	CreateTimer((duration > 1) ? duration - 1.0 : duration, Timer_ResetSyncedFlash, GetClientUserId(client));
}

public Action Timer_ResetSyncedFlash(Handle timer, int userid) {
	int client = GetClientOfUserId(userid);
	inFlash[client] = false;

	if(client < 1 || !IsClientInGame(client)) return Plugin_Stop;

	int	   color[4] = {255, 255, 255, 255};

	Handle message = StartMessageOne("Fade", client);

	if(GetUserMessageType() == UM_Protobuf) {
		PbSetInt(message, "duration", 1000);
		PbSetInt(message, "hold_time", 100);
		PbSetInt(message, "flags", FFADE_IN | FFADE_PURGE | FFADE_STAYOUT);
		PbSetColor(message, "clr", color);
	} else {
		BfWriteShort(message, 1000);
		BfWriteShort(message, 100);
		BfWriteShort(message, FFADE_IN | FFADE_PURGE | FFADE_STAYOUT);
		BfWriteByte(message, color[0]);
		BfWriteByte(message, color[1]);
		BfWriteByte(message, color[2]);
		BfWriteByte(message, color[3]);
	}
	EndMessage();

	return Plugin_Stop;
}

public bool Chaos_SyncedFlash_Conditions(bool EffectRunRandomly) {
	if(g_iDuration == -1 || g_iFlashMaxAlpha == -1) {
		return false;
	}
	return true;
}