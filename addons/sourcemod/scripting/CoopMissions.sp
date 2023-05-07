#define MAX_MISSIONS 3

Handle	  CheckCoopStrike_Timer = INVALID_HANDLE;
int		  WaitingCoopStrikeMissionTime = 0;

ArrayList MissionStartZones;

enum struct MissionZoneData {
	int	  missionID;

	float start_1[3];
	float start_2[3];
}

void PatchKasbahMapSpawns() {
	// there are 300 spawns for kasbah, but indexes 150-300 are only used in the second mission, lets adjust accordingly
	// runs on round_start, if the mission is manually changed a restart is required which will trigger this patch
	if(!StrEqual(g_sCurrentMapName, "coop_kasbah")) return;

	ParseMapCoordinates("Chaos_Locations");
	
	if(GetArraySize(g_MapCoordinates) <= 250) return;
	
	ConVar mission = FindConVar("mp_coopmission_mission_number");
	if(mission.IntValue == 0 || mission.IntValue == 1) {
		for(int i = 0; i < 150; i++) {
			RemoveFromArray(g_MapCoordinates, GetArraySize(g_MapCoordinates) - 1);
		}
	} else if(mission.IntValue == 2) {
		for(int i = 0; i < 150; i++) {
			RemoveFromArray(g_MapCoordinates, 0);
		}
	}
}

void ParseMissionData() {
	StopTimer(CheckCoopStrike_Timer);
	if(MissionStartZones == INVALID_HANDLE) {
		MissionStartZones = new ArrayList(sizeof(MissionZoneData));
	}
	MissionStartZones.Clear();

	char filePath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, filePath, sizeof(filePath), "data/Chaos/CoopMission.cfg");

	if(!FileExists(filePath)) {
		return;
	}
	KeyValues kv = new KeyValues("Maps");

	if(!kv.ImportFromFile(filePath)) {
		return;
	}

	if(!kv.JumpToKey(g_sCurrentMapName)) {
		return;
	}

	if(!kv.GotoFirstSubKey(false)) {
		return;
	}
	do {
		char key[25];
		kv.GetSectionName(key, sizeof(key));

		char position[64];
		kv.GetString(NULL_STRING, position, sizeof(position));
		int missionID = -1;
		for(int i = 1; i <= MAX_MISSIONS; i++) {
			// this becomes wrong if missions exceed 9 but afaik official maps contain 3 max :D
			char id[4];
			FormatEx(id, sizeof(id), "%i", i);
			if(StrContains(key, id) != -1) {
				missionID = i;
				break;
			}
		}

		if(StrContains(key, "MissionStartZone") != -1) {
			MissionZoneData zone;
			zone.missionID = missionID;

			char missionKey[6][16];
			ExplodeString(position, " ", missionKey, 6, 16);

			float start1[3];
			float start2[3];
			for(int i = 0; i < 6; i++) {
				if(i < 3) {
					start1[i] = StringToFloat(missionKey[i]);
				} else {
					start2[i - 3] = StringToFloat(missionKey[i]);
				}
			}

			zone.start_1 = start1;
			zone.start_2 = start2;
			MissionStartZones.PushArray(zone);
		}

	} while(kv.GotoNextKey(false));
}

public Action Timer_CheckCoopStrike(Handle timer) {
	if(!IsCoopStrike() || CheckCoopStrike_Timer == INVALID_HANDLE) {
		CheckCoopStrike_Timer = INVALID_HANDLE;
		WaitingCoopStrikeMissionTime = 0;
		return Plugin_Stop;
	}

	if(GameRules_GetProp("m_bWarmupPeriod") == 1) return Plugin_Continue;

	WaitingCoopStrikeMissionTime++;
	if(WaitingCoopStrikeMissionTime % 15 == 0 || WaitingCoopStrikeMissionTime == 0) {
		if(MissionStartZones.Length == 0) {
			// Admin will need to manually start the timer once they deploy
			PrintCenterTextAll("[Co-op Strike] Waiting for mission deployment");
			CPrintToChatAll("{darkred}ATTENTION{default}: Waiting for deployment");
			CPrintToChatAll("This map has {darkred}not been configured for {orange}Co-op Strike, {default}use {lime}!startchaos {default}to start the timer at the start of your mission", g_Prefix);
		} else {
			PrintCenterTextAll("[Co-op Strike] Waiting for mission deployment");
			CPrintToChatAll("%s [Co-op Strike] Waiting for mission deployment", g_Prefix);
		}
	}

	// check if players are in mission zones
	// TODO: also checking to see if they spawn back in the mission setup lobby to de-active chaos mod
	int mission = PlayersInMissionStartZone();
	if(mission != -1) {
		g_NewEffect_Timer = CreateTimer(float(g_cvChaosEffectInterval.IntValue), ChooseEffect, _, TIMER_FLAG_NO_MAPCHANGE);
		Timer_Display(null, g_cvChaosEffectInterval.IntValue);
		expectedTimeForNewEffect = GetTime() + g_cvChaosEffectInterval.IntValue;
		CheckCoopStrike_Timer = INVALID_HANDLE;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

int PlayersInMissionStartZone() {
	if(MissionStartZones == INVALID_HANDLE || MissionStartZones.Length == 0) {
		return -1;
	}

	int				missionID = -1;
	MissionZoneData mission;

	for(int i = 0; i < MissionStartZones.Length; i++) {
		MissionStartZones.GetArray(i, mission);
		// activate timer when atleast one player is in the zone
		bool playerInZone = false;
		LoopAlivePlayers(client) {
			if(GetClientTeam(client) != CS_TEAM_CT) continue;
			if(isInEnd(client, mission.start_1, mission.start_2)) {
				playerInZone = true;
			}
		}
		if(playerInZone) {
			missionID = mission.missionID;
			break;
		}
	}
	return missionID;
}


bool isInEnd(int client, float Zone1[3], float Zone2[3]) {
	float client_vec[3];
	GetClientAbsOrigin(client, client_vec);
	bool inRange = true;
	for(int i = 0; i < 3; i++) {
		if(!withinRange(client_vec[i], Zone1[i], Zone2[i])) inRange = false;
	}
	return inRange;
}

bool withinRange(float target, float vec1, float vec2) {
	if(vec1 > vec2) {
		if(target >= vec2 && target <= vec1) {
			return true;
		}
	} else {
		if(target >= vec1 && target <= vec2) {
			return true;
		}
	}
	return false;
}