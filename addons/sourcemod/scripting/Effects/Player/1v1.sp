#pragma semicolon 1

bool Valid1v1Spawns = false;

enum struct SpawnData1v1 {
	int	  spawnID;
	int	  team;
	float pos[3];
}

ArrayList _1v1Spawns;
bool	  isIn1v1[MAXPLAYERS + 1];

int		  arenaPlayers[5][2]; // 5 arenas with 2 players each

bool	  _1v1Active = false;

public void Chaos_1v1(EffectData effect) {
	effect.Title = "1V1 Arena";
	effect.Duration = 15;
	effect.AddFlag("respawn");
	effect.IncompatibleWith("Chaos_PortalGuns");
	effect.IncompatibleWith("Chaos_RandomTeleport");
	effect.IncompatibleWith("Chaos_FakeTeleport");
	effect.IncompatibleWith("Chaos_TeleportOnKill");
	effect.IncompatibleWith("Chaos_TeleportFewMetres");
	effect.IncompatibleWith("Chaos_SimonSays");
	effect.IncompatibleWith("Chaos_RewindTenSeconds");
	effect.IncompatibleWith("Chaos_Flying");
	effect.IncompatibleWith("Chaos_FakeCrash");
	effect.IncompatibleWith("Chaos_BreakTime");
	effect.IncompatibleWith("Chaos_BlindPlayers");
}

public void Chaos_1v1_INIT() {
	_1v1Spawns = new ArrayList(sizeof(SpawnData1v1));
	HookEvent("player_death", Chaos_1v1_Event_PlayerDeath);
}

public void Chaos_1v1_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {
	if(!_1v1Active) return;
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if(ValidAndAlive(attacker)) {
		if(isIn1v1[attacker] && isIn1v1[victim]) {
			isIn1v1[victim] = false;
			CreateTimer(0.5, Timer_1v1TeleportBack, attacker);
		}
	} else {
		// Perhaps one of the players died from other causes, we need to find their opponent and respawn them
		for(int i = 0; i < 5; i++) {
			if(arenaPlayers[i][0] == victim) {
				CreateTimer(0.5, Timer_1v1TeleportBack, arenaPlayers[i][1]);
			} else if(arenaPlayers[i][1] == victim) {
				CreateTimer(0.5, Timer_1v1TeleportBack, arenaPlayers[i][0]);
			}
		}
	}
}

public Action Timer_1v1TeleportBack(Handle timer, int client) {
	if(ValidAndAlive(client) && isIn1v1[client]) {
		TeleportEntity(client, g_AllPositions[client]);
		isIn1v1[client] = false;
	}
	return Plugin_Stop;
}

public void Chaos_1v1_OnMapStart() {
	Valid1v1Spawns = false;

	_1v1Spawns.Clear();

	char MapName[MAX_NAME_LENGTH];
	GetCurrentMap(MapName, MAX_NAME_LENGTH);


	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, PLATFORM_MAX_PATH, "/data/Chaos/Chaos_1v1Spawns.cfg");

	if(!FileExists(path)) return;

	KeyValues kv = new KeyValues("Maps");

	if(!kv.ImportFromFile(path)) return;
	if(!kv.JumpToKey(MapName)) return;
	if(!kv.GotoFirstSubKey(false)) return;

	do {
		char key[16];
		kv.GetSectionName(key, sizeof(key));

		SpawnData1v1 spawn;
		kv.GetVector(NULL_STRING, spawn.pos);

		char details[2][16];

		if(StrContains(key, "CT", false) != -1) {
			spawn.team = CS_TEAM_CT;
			ExplodeString(key, "CT", details, 2, 16);
		} else if(StrContains(key, "T", false) != -1) {
			spawn.team = CS_TEAM_T;
			ExplodeString(key, "T", details, 2, 16);
		} else {
			continue;
		}

		int id = StringToInt(details[1]);
		spawn.spawnID = id;

		_1v1Spawns.PushArray(spawn);

	} while(kv.GotoNextKey(false));

	_1v1Spawns.Sort(Sort_Ascending, Sort_Integer);
	if(_1v1Spawns.Length == 10) {
		Valid1v1Spawns = true;
	}

	delete kv;
}

public void Chaos_1v1_START() {
	_1v1Active = true;
	SavePlayersLocations();

	ArrayList t = new ArrayList();
	ArrayList ct = new ArrayList();
	LoopAlivePlayers(i) {
		if(GetClientTeam(i) == CS_TEAM_CT) {
			ct.Push(i);
		} else {
			t.Push(i);
		}
	}
	int spawnIndex = 0;
	int arenaIndex = 0;
	for(int i = 0; i < t.Length; i++) {
		int tPlr = t.Get(i);
		int ctPlr = ct.Get(i);

		arenaPlayers[arenaIndex][0] = tPlr;
		arenaPlayers[arenaIndex][1] = ctPlr;
		arenaIndex++;

		SpawnData1v1 tSpawn;
		_1v1Spawns.GetArray(spawnIndex, tSpawn, sizeof(tSpawn));
		spawnIndex++;

		SpawnData1v1 ctSpawn;
		_1v1Spawns.GetArray(spawnIndex, ctSpawn, sizeof(ctSpawn));
		spawnIndex++;


		if(ValidAndAlive(tPlr) && ValidAndAlive(ctPlr)) {
			// Prevent player from bringing c4 into 1v1 map in case they die with the bomb
			int c4 = PlayerHasWeapon(tPlr, "weapon_c4");
			if(c4 != -1) {
				CS_DropWeapon(tPlr, c4, false, true);
				float pos[3];
				GetClientAbsOrigin(tPlr, pos);
				DataPack pack = new DataPack();
				pack.WriteCell(tPlr);
				pack.WriteCell(c4);
				pack.WriteFloatArray(pos, 3);
				CreateTimer(0.1, Timer_PutC4BackInMap, pack);
			}

			isIn1v1[tPlr] = true;
			isIn1v1[ctPlr] = true;
			TeleportEntity(tPlr, tSpawn.pos, .velocity = no_vel);
			TeleportEntity(ctPlr, ctSpawn.pos, .velocity = no_vel);
			tSpawn.pos[2] += 64.0;
			ctSpawn.pos[2] += 64.0;
			LookAtPoint(tPlr, ctSpawn.pos);
			LookAtPoint(ctPlr, tSpawn.pos);
		}
	}
	PrintCenterTextAll("Win the 1V1 to return back to the map!");
	CPrintToChatAll("%s Win the 1V1 to return back to the map!", g_Prefix);
}

public Action Timer_PutC4BackInMap(Handle timer, DataPack pack) {
	pack.Reset();
	int	  client = pack.ReadCell();
	int	  c4 = pack.ReadCell();
	float pos[3];
	pack.ReadFloatArray(pos, 3);
	if(IsValidClient(client) && IsValidEntity(c4)) {
		TeleportEntity(c4, pos);
		DispatchSpawn(c4);
	}
	delete pack;

	return Plugin_Stop;
}

public void Chaos_1v1_RESET(int ResetType) {
	_1v1Active = false;
	if(ResetType & RESET_EXPIRED) {
		LoopAlivePlayers(i) {
			if(isIn1v1[i]) {
				TeleportEntity(i, g_AllPositions[i]);
			}
		}
	}
	for(int i = 0; i <= MaxClients; i++) {
		isIn1v1[i] = false;
	}
}

public bool Chaos_1v1_Conditions(bool EffectRunRandomly) {
	if(MegaChaosIsActive()) return false;
	int ct = GetAliveCTCount();
	int t = GetAliveTCount();
	if((ct + t) > 10) return false;
	if(_1v1Spawns.Length != 10) return false;
	if(t != ct) return false;
	return Valid1v1Spawns;
}