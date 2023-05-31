#pragma semicolon 1

public void Chaos_SyncedReload(EffectData effect) {
	effect.Title = "Synced Reloading";
	effect.Duration = 30;
	
	effect.IncompatibleWith("Chaos_ForceReload");
}

public void Chaos_SyncedReload_START() {
	PrintHintTextToAll("When a teammate reloads, the whole team reloads!");
}

bool inSyncedReload[MAXPLAYERS + 1];

public void Chaos_SyncedReload_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]) {
	if(buttons & IN_RELOAD) {
		if(!inSyncedReload[client]) {
			DoTeamReload(client);
		}
	} else {
		if(inSyncedReload[client]) {
			buttons |= IN_RELOAD;
			inSyncedReload[client] = false;
		}
	}
}

void DoTeamReload(int client) {
	if(!ValidAndAlive(client)) return;
	int team = GetClientTeam(client);
	LoopAlivePlayers(i) {
		if(GetClientTeam(i) != team) continue;
		inSyncedReload[i] = true;
	}
}