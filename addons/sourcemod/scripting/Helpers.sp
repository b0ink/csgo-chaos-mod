#pragma semicolon 1


char multicolors[][] = {
	"{lightred}", "{lightblue}", "{lightgreen}", "{olive}", "{grey}", "{yellow}", "{bluegrey}", "{orchid}", "{lightred2}", "{purple}", "{lime}", "{orange}", "{red}", "{blue}", "{darkred}", "{darkblue}", "{default}", "{green}"
};

char[] RemoveMulticolors(char[] message){
	char finalMess[256];
	Format(finalMess, sizeof(finalMess), "%s", message);
	for(int i = 0; i < sizeof(multicolors); i++){
		ReplaceString(finalMess, sizeof(finalMess), multicolors[i],"", false);
	}
	return finalMess;
}



/**
 * Sets players cash.
 * 
 * @param client       		Client index.
 * @param money        		Amount of money to give. (Negative value if deducting cash)
 * @param absolute     		Set false to relatively add money amount. True if setting amount.
 * @param skipDepositUI     Set false to display the amount deposited into your cash before changing its value.
 * @return             Return true on success.
 */
stock bool SetClientMoney(int client, int money, bool absolute = false, bool skipDepositUI = false){
	if(IsValidClient(client)){
		if(absolute){
			SetEntProp(client, Prop_Send, "m_iAccount", money);
		}else{
			SetEntProp(client, Prop_Send, "m_iAccount", GetEntProp(client, Prop_Send, "m_iAccount")+money);
		}
		if(!skipDepositUI){
			int entity = CreateEntityByName("game_money");
			if(entity != INVALID_ENT_REFERENCE){
				DispatchKeyValue(entity, "AwardText", "");
				DispatchSpawn(entity);
				SetVariantInt(0);
				AcceptEntityInput(entity, "SetMoneyAmount");
				SetVariantInt(client);
				AcceptEntityInput(entity, "AddMoneyPlayer");
				AcceptEntityInput(entity, "Kill");
				return true;
			}
		}

		return false;
	}else{
		return false;
	}
} 

bool g_bRemovechicken_debounce = false;
void RemoveChickens(bool removec4Chicken = false, char[] chickenName = ""){
	if(!g_bRemovechicken_debounce){
		g_bRemovechicken_debounce = true;

		char classname[64];
		char targetname[64];
		LoopAllEntities(ent, GetMaxEntities(), classname){
			if(StrEqual(classname, "chicken") && GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == -1){
				GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
				if(chickenName[0] != '\0'){
					if(StrEqual(targetname, chickenName, false)){
						RemoveEntity(ent);	
					}else{
						continue;
					}	
				}
				if(removec4Chicken){
					if(ent == GetC4ChickenEntity()){
						RemoveEntity(ent);
					}
				}else{
					if(ent != GetC4ChickenEntity()){
						SetEntPropFloat(ent, Prop_Data, "m_flModelScale", 1.0);
						RemoveEntity(ent);
					}
				}
			}
		}
		CreateTimer(0.5, Timer_ResetChickenDebounce);
	}
}  

Action Timer_ResetChickenDebounce(Handle timer){
	g_bRemovechicken_debounce = false;
	return Plugin_Continue;
}


/**
 * Gets total count of valid players in-game.
 * 
 * @return     Number of players.
 */
stock int GetPlayerCount(){
	int count = 0;
	for(int i = 1; i <= MaxClients; i++){
		if(IsValidClient(i)){
			count++;
		}
	}
	return count;
}

/**
 * Gets total count of alive Terrorists.
 * 
 * @return     Number of alive Terrorists.
 */
stock int GetAliveTCount(){
	int count = 0;
	LoopAlivePlayers(i){
		if(GetClientTeam(i) == CS_TEAM_T) count++;
	}
	return count;
}

/**
 * Gets a total count of alive Counter-Terrorists.
 * 
 * @return     Number of alive Counter-Terrorists.
 */
stock int GetAliveCTCount(){
	int count = 0;
	LoopAlivePlayers(i){
		if(GetClientTeam(i) == CS_TEAM_CT) count++;
	}
	return count;
}


/**
 * Gets random alive player. Set team paramater to limit random player by team.
 * 
 * @param team     Param description
 * @return         Return description
 */
int GetRandomAlivePlayer(int team = CS_TEAM_NONE){
	Handle players = CreateArray(4);
	LoopAlivePlayers(i){
		if(team != CS_TEAM_NONE){
			if(GetClientTeam(i) == team){
				PushArrayCell(players, i);
			}
		}else{
			PushArrayCell(players, i);
		}
	}
	int random = GetRandomInt(0, GetArraySize(players) - 1);
	int target = GetArrayCell(players, random);
	delete players;
	return target;
}

stock void Log(const char[] format, any ...){
	char buffer[254];
	VFormat(buffer, sizeof(buffer), format, 2);
	char sLogPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sLogPath, sizeof(sLogPath), "logs/chaos_logs.log");
	LogToFile(sLogPath, buffer);
}

void StripPlayer(int client, bool knife = true, bool keepBomb = true, bool stripGrenadesOnly = false, bool KeepGrenades = false){
	if (ValidAndAlive(client)){
		int iTempWeapon = -1;
		for (int j = 0; j < 5; j++)
			if ((iTempWeapon = GetPlayerWeaponSlot(client, j)) != -1){
				if(!stripGrenadesOnly){
					if (j == 2 && knife) //keep knife
						continue;
					if(j == 4 && keepBomb) //keep bomb
						continue;
					if(j == 3 && KeepGrenades) continue;
					if (IsValidEntity(iTempWeapon))
						RemovePlayerItem(client, iTempWeapon);
				}
				if(stripGrenadesOnly && !KeepGrenades){
					if(j==3) RemovePlayerItem(client, iTempWeapon);
				}
			}
	}
}




void GetWeaponClassname(int weapon, char[] buffer, int size) {
	switch(GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex")) {
		case 60: Format(buffer, size, "weapon_m4a1_silencer");
		case 61: Format(buffer, size, "weapon_usp_silencer");
		case 63: Format(buffer, size, "weapon_cz75a");
		case 64: Format(buffer, size, "weapon_revolver");
		default: GetEntityClassname(weapon, buffer, size);
	}
}



bool CreateParticle(char[] particle, float vec[3]){
	int ent = CreateEntityByName("info_particle_system");
	DispatchKeyValue(ent , "start_active", "0");
	DispatchKeyValue(ent, "effect_name", particle);
	TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
	DispatchSpawn(ent);
	ActivateEntity(ent);
	AcceptEntityInput(ent, "Start");
	return true;
}

void StopTimer(Handle &timer){
	if(timer != INVALID_HANDLE){
		KillTimer(timer);
		timer = INVALID_HANDLE;
	}
}


/**
 * Finds slot index using weapon name
 * 
 * @param client     Client index to search
 * @param szName     Name of weapon to find
 * @return           Weapon Slot index. -1 if no weapon found with szName.
 */
stock int GetSlotByWeaponName(int client, const char[] szName){
	char szClassname[36];
	int entity = -1;
	for (int i; i <= 20; i++){
		entity = GetPlayerWeaponSlot(client, i);
		if(!IsValidEntity(entity)) continue;
		GetEntityClassname(entity, szClassname, sizeof szClassname);
		if (strcmp(szName, szClassname) == 0)return i;
	}
	return -1;
}


/**
 * Checks if the client currently has a menu open
 * 
 * @param client     Client index to check
 * @return           Return true if player has menu open.
 */
bool HasMenuOpen(int client){
	if(GetClientMenu(client) != MenuSource_None) return true;
	return false;
}

char[] Truncate(char[] str, int length, int reverse = 0){
	char return_string[PLATFORM_MAX_PATH];
	if(reverse){
		int iLen = strlen(str) - length;
		for(int i; i < iLen; i++){
			str[i] = str[iLen + i];
			length = i;
		}
	}
	str[length] = 0;
	FormatEx(return_string, sizeof(return_string), "%s", str);
	return return_string;
} 

bool IsHostageMap(){
	int index = FindEntityByClassname(-1, "hostage_entity");
	if(index != -1) return true;
	return false;
}



bool GameModeUsesC4(){
	if(g_cvCustomDeathmatchEnabled != null){
		if(g_cvCustomDeathmatchEnabled.BoolValue){
			return false;
		}
	}

	if(g_cvGameType.IntValue == 0){
		return true;
	} else if(g_cvGameType.IntValue == 1 && g_cvGameMode.IntValue == 1){
		return true;
	}
	return false;
}


public void GiveAndSwitchWeapon(int client, char[] weaponName){
	
    char playersWeapon[64];
    GetClientWeapon(client, playersWeapon, sizeof(playersWeapon));

    StripPlayer(
        .client=client,
        .knife=true,
        .keepBomb=true,
        .stripGrenadesOnly=false,
        .KeepGrenades=true
    );
    int weapon = GivePlayerItem(client, weaponName);

    //if player has their knife or bomb out, don't switch to new weapon
    if(StrContains(playersWeapon, "c4") != -1 || StrContains(playersWeapon, "knife") != -1){
        if(StrContains(playersWeapon, "knife") != -1){
            FakeClientCommand(client, "use %s", "weapon_knife"); //ignored by weapon_knife_karambit etc.
            InstantSwitch(client, weapon);
        }else{
            FakeClientCommand(client, "use %s", playersWeapon);
            InstantSwitch(client, weapon);
        }
    }else{
        FakeClientCommand(client, "use %s", weaponName);
        InstantSwitch(client, weapon);
    }
}

public void InstantSwitch(int client, int weapon){	
    float GameTime = GetGameTime();
    SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GameTime);
    int ViewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
    SetEntProp(ViewModel, Prop_Send, "m_nSequence", 0);
}


/**
 * Knockback the player.
 * 
 * @param client     Client you want to knockback.
 * @param amount     Amount of knockback force. Negative force will have an opposite knockback (push the player forward)
 */
void DoKnockback(int client, float amount){
	if(!ValidAndAlive(client)) return;

	float vPlayerVelocity[3];
	float vPlayerEyeAngles[3];
	float vPlayerForward[3];

	// Get the player velocity
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", vPlayerVelocity);

	// Get the player forward direction
	GetClientEyeAngles(client, vPlayerEyeAngles);
	GetAngleVectors(vPlayerEyeAngles, vPlayerForward, NULL_VECTOR, NULL_VECTOR);

	// Compute the player weapon jump velocity
	vPlayerVelocity[0] -= vPlayerForward[0] * amount;
	vPlayerVelocity[1] -= vPlayerForward[1] * amount;
	vPlayerVelocity[2] -= vPlayerForward[2] * amount;
	vPlayerVelocity[2] += 100.0;
	// Set the player weapon jump
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vPlayerVelocity);
}


bool PlayerHasWeapon(int client, char[] weaponName){
	int size = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
	char itemName[64];

	for (int i; i < size; i++){
		int item = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", i);
		if (item == -1) continue;
		
		GetEntityClassname(item, itemName, sizeof(itemName));
		if(StrEqual(weaponName, itemName, false)){
			return true;
		}
	}
	return false;
}



/**
 * Gets total rounds played in the current map
 * 
 * @return     Return description
 */
stock int GetTotalRoundsPlayed(){
	return GameRules_GetProp("m_totalRoundsPlayed");
}


/**
 * Gets amount of time (in seconds) since round_freeze_end (after freeze time ends)
 * 
 * @return     Return description
 */
stock int GetRoundTime(){
	return g_iRoundTime;
}


/**
 * Gets amount of effects triggered in the map. Resets to 0 on map change.
 * 
 * @return     Return description
 */
stock int TotalEffectsRunThisMap(){
	return g_iTotalEffectsRunThisMap;
}


/**
 * Gets amount of effects run in the current map. Resets on round start.
 * 
 * @return     Return description
 */
stock int TotalEFfectsRunThisRound(){
	return g_iTotalEffectsRanThisRound;
}


/**
 * Effects run since the last meta effect
 * 
 * @return     Return description
 */
stock int EffectsSinceLastMeta(){
	return g_iEffectsSinceMeta;
}

/*
	This was used previously when i thought chickens were involved in a notorious crash involving with c4's and chicken.
	The crash has long since been fixed (unrelated to either c4's or chickens).
	This used to return true if a bomb has been planted. (not anymore since this comment)
	Consider this function deprecated, and will completely nuke it in later versions if there are no issues with chickens.
*/
stock int CanSpawnChickens(){
	return g_bCanSpawnChickens;
}

stock int CanSpawnNewEffect(){
	return g_bCanSpawnEffect;
}

bool IsValidClient(int client){
	if (client <= 0 || client > MaxClients) return false;
	return IsClientInGame(client);
}

stock bool ValidAndAlive(int client){
	return (IsValidClient(client) && IsPlayerAlive(client) && (GetClientTeam(client) == CS_TEAM_CT || GetClientTeam(client) == CS_TEAM_T));
}

/**
 * Calculate a coordinate along an axis between two points, based on a certain time before its final duration. 
 * 
 * For Example, after setting a start and end point, if time = 1.5, and duration = 3.0, this will return the center point between the two vectors.
 * 
 * @param start        Starting vector.
 * @param end          Ending vector.
 * @param time         How far into the duration should it calculate the point.
 * @param duration     How long it should take to get from `start` to `end`
 * @param buffer       Buffer to store the calculated point.
 */
void LerpVector(float start[3], float end[3], float time, float duration, float buffer[3]){
	float t = time / duration;
	float x = start[0] + (end[0] - start[0]) * t;
	float y = start[1] + (end[1] - start[1]) * t;
	float z = start[2] + (end[2] - start[2]) * t;
	buffer[0] = x;
	buffer[1] = y;
	buffer[2] = z;
}


float LerpDuration[MAXPLAYERS+1];
float LerpStartPos[MAXPLAYERS+1][3];
float LerpEndPos[MAXPLAYERS+1][3];
float TimeInLerp[MAXPLAYERS+1];
bool  IsInLerp[MAXPLAYERS+1];

void LerpToPoint(int client, float start[3], float end[3], float duration, bool PlaySoundEffect = true){
	if(!ValidAndAlive(client)) return;

	TimeInLerp[client] = 0.0;
	LerpStartPos[client] = start;
	LerpEndPos[client] = end;
	IsInLerp[client] = true;
	LerpDuration[client] = duration;

	if(PlaySoundEffect){
		ClientCommand(client, "playgamesound \"player/halloween/ghost_swish_c_02.wav\"");
		ClientCommand(client, "playgamesound \"player/halloween/ghost_swish_c_02.wav\"");
	}
}

void LerpOnGameFrame(){
	LoopValidPlayers(i){
		if(!IsInLerp[i]) continue;
		
		if(!IsPlayerAlive(i)){
			IsInLerp[i] = false;
			TimeInLerp[i] = 0.0;
			continue;
		}

		if(TimeInLerp[i] >= LerpDuration[i] |){
			if(!g_bActiveNoclip){ // niche check to see if Flying is active
				SetEntityMoveType(i, MOVETYPE_WALK);
			}else{
				SetEntityMoveType(i, MOVETYPE_NOCLIP);
			}
			TeleportEntity(i, .origin=LerpEndPos[i]);
			
			IsInLerp[i] = false;
			TimeInLerp[i] = 0.0;
			continue;
		}


		SetEntityMoveType(i, MOVETYPE_NONE);
		float pos[3];
		LerpVector(LerpStartPos[i], LerpEndPos[i], TimeInLerp[i], LerpDuration[i], pos);
		TeleportEntity(i, .origin=pos);
		TimeInLerp[i] += GetTickInterval();
	}
}