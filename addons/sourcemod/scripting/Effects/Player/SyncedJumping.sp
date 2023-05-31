#pragma semicolon 1

public void Chaos_SyncedJumping(EffectData effect) {
	effect.Title = "Synced Jumping";
	effect.Duration = 30;
	
	effect.IncompatibleWith("Chaos_Jumping");
}

public void Chaos_SyncedJumping_START() {
	PrintHintTextToAll("When a teammate jumps, the whole team jumps!");
}

bool inSyncedJump[MAXPLAYERS + 1];

public void Chaos_SyncedJumping_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]) {
	if(buttons & IN_JUMP) {
		if(!inSyncedJump[client]) {
			DoTeamJump(client);
		}else{
			inSyncedJump[client] = false;
		}
	} else {
		if(inSyncedJump[client]) {
			buttons |= IN_JUMP;
			inSyncedJump[client] = false;
		}
	}
}

void DoTeamJump(int client) {
	if(!ValidAndAlive(client)) return;
	int team = GetClientTeam(client);
	LoopAlivePlayers(i) {
		if(GetClientTeam(i) != team) continue;
		inSyncedJump[i] = true;
	}
}