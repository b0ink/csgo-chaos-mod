float g_AllPositions[MAXPLAYERS+1][3];


bool ValidMapPoints(){
	if(g_MapCoordinates == INVALID_HANDLE) return false;
	return true;
}

bool ValidBombSpawns(){
	if(GetArraySize(bombSiteA) == 0 || GetArraySize(bombSiteB) == 0) return false;
	return true;
}




bool NotDecidingChaos(char[] EffectName = ""){
	//if effectname was provided manually, 
	if(!g_bDecidingChaos) return true;
	if(!g_sSelectedChaosEffect[0]) return true;
	if(EffectName[0] && g_sSelectedChaosEffect[0]){
		if(!g_bDecidingChaos
		|| ((StrContains(g_sSelectedChaosEffect, EffectName, false) == -1) 
		&& (StrContains(EffectName, g_sSelectedChaosEffect, false) == -1))){
			
			return true;
		}else{
			if(g_bFindingPotentialEffects){
				PushArrayString(Possible_Chaos_Effects, EffectName);
				return true;
			}else{
				Log("[Chaos] Running Effect: %s", EffectName);
				strcopy(g_sLastPlayedEffect, sizeof(g_sLastPlayedEffect), EffectName);
				g_sSelectedChaosEffect = "";
				g_bDecidingChaos = false;
				return false;
			}
		}
	}
	return true;
}


bool ClearChaos(bool EndChaos = false){
	if(g_bClearChaos || EndChaos) return true;
	return false;
}

bool IsChaosEnabled(char[] EffectName, int defaultEnable = 1){
	if(g_bClearChaos) return true;
	int Chaos_Properties[2];
	int enabled = 0;
	if(Chaos_Effects.GetArray(EffectName, Chaos_Properties, 2)){
		enabled = Chaos_Properties[CONFIG_ENABLED];
	}else{
		Log("[CONFIG] Couldnt find Effect Configuration: %s", EffectName);
		enabled = defaultEnable;
	}
	if(enabled == 1) return true;
	return false;
}

float GetChaosTime(char[] EffectName, float defaultTime = 15.0, bool raw = false){

	
	float OverwriteDuration = g_fChaos_OverwriteDuration;
	if(OverwriteDuration < -1.0){
		Log("Cvar 'OverwriteEffectDuration' set Out Of Bounds in Chaos_Settings.cfg, effects will use their durations in Chaos_Effects.cfg");
		OverwriteDuration = - 1.0;
	}

	int Chaos_Properties[2];
	float expire = defaultTime;
	if(Chaos_Effects.GetArray(EffectName, Chaos_Properties, 2)){
		expire = float(Chaos_Properties[CONFIG_EXPIRE]);

		// if(raw) return SanitizeTime(expire);
		if(raw) return expire;		
		
		if(OverwriteDuration != -1.0) expire = OverwriteDuration;

		if(expire < 0){
			//this should imply that per the config, it doesnt exist, lets provide it the plugins default time instead, just in case it does use it.
			expire = defaultTime;
			expire = SanitizeTime(expire);
		}else{
			if(expire != SanitizeTime(expire)){
				Log("Incorrect duration set for %s. You set: %f, defaulting to: %f", EffectName, expire, SanitizeTime(expire));
				expire = SanitizeTime(expire);
			}
		}
	
	}else{
		Log("[CONFIG] Could not find configuration for Effect: %s, using default of %f", EffectName, defaultTime);
	}
	// PrintToChatAll("%s duration is %f", EffectName, expire);
	return expire;
}


char[] GetChaosTitle(char[] function_name){
	char return_string[128];
	char temp_title[128];
	for(int i = 0; i < GetArraySize(Effect_Functions); i++){
		GetArrayString(Effect_Functions, i, temp_title, sizeof(temp_title));
		if(StrContains(temp_title, function_name, false) != -1){
			GetArrayString(Effect_Titles, i, return_string, sizeof(return_string));
			break;
		}
	}
	return return_string;
}



bool PoolChaosEffects(char[] effectName = ""){

	ClearArray(Possible_Chaos_Effects);
	if(effectName[0]){
		FormatEx(g_sSelectedChaosEffect, sizeof(g_sSelectedChaosEffect), "%s", effectName);
	}else{
		g_sSelectedChaosEffect = "Chaos_";
	}
	g_bDecidingChaos = true;
	g_bClearChaos = false;
	g_bFindingPotentialEffects = true;
	Chaos();
	g_bFindingPotentialEffects = false;

	// SortChaosEffects();
	//todo: this is will not be an accurate sort because im sorting FUNCTION names
	//i could loop through Effect_Functions, see if it exists in possible_effects
	// SortADTArray(Possible_Chaos_Effects, Sort_Ascending, Sort_String);

}

// char letters[26] = "abcdefghijklmnopqrstuvwxyz";
// int CharToInt(char letter){
// 	return FindCharInString(letters, letter);
// }
// void SortChaosEffects(){
// 	PrintToChatAll("starting");
// 	bool sorted = false;
// 	Handle temp_array = CloneArray(Effect_Functions);

// 	char string1[64];
// 	char string2[64];

// 	char title1[64];
// 	char title2[64];

	
// 	int tryy = 0;
// 	while(!sorted){
// 		tryy++;
// 		if(tryy > 9999){
// 			PrintToChatAll("had to break");
// 			break;
// 		}

// 		sorted = true;
// 		for(int i = 0; i < GetArraySize(temp_array); i++){
// 			GetArrayString(temp_array, i, string1, sizeof(string1));
// 			Format(title1, sizeof(title1), "%s", GetChaosTitle(string1));
// 			for(int g = i+1; g < GetArraySize(temp_array); g++){
// 				GetArrayString(temp_array, i, string2, sizeof(string2));
// 				Format(title2, sizeof(title2), "%s", GetChaosTitle(string2));
// 				if(CharToInt(string1[0]) < CharToInt(string2[0])){
// 					SwapArrayItems(temp_array, i, g);
// 					sorted = false;
// 				}
// 			}
// 		}
// 	}
// 	ClearArray(Effect_Functions);
// 	Effect_Functions = CloneArray(temp_array);
// 	delete temp_array;

// 	PrintToChatAll("done");
// }




stock bool IsValidClient(int client, bool nobots = true){
    if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client))) {
        return false;
    }
    return IsClientInGame(client);
}

stock bool ValidAndAlive(int client){
	return (IsValidClient(client) && IsPlayerAlive(client) && (GetClientTeam(client) == CS_TEAM_CT || GetClientTeam(client) == CS_TEAM_T));
}

char[] RemoveMulticolors(char[] message){
	char finalMess[256];
	Format(finalMess, sizeof(finalMess), "%s", message);

	ReplaceString(finalMess, sizeof(finalMess),"{lightred}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{lightblue}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{lightgreen}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{olive}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{grey}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{yellow}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{bluegrey}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{orchid}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{lightred2}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{purple}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{lime}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{orange}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{red}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{blue}","", false); 
	ReplaceString(finalMess, sizeof(finalMess),"{darkred}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{darkblue}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{default}","", false);
	ReplaceString(finalMess, sizeof(finalMess),"{green}","", false);

	return finalMess;
}

void DisplayCenterTextToAll(char[] message){
	char finalMess[256];
	Format(finalMess, sizeof(finalMess), "%s", RemoveMulticolors(message));

	for (int i = 1; i <= MaxClients; i++){
		if(IsValidClient(i)){
			if(g_DynamicChannel){
				SetHudTextParams(-1.0, 0.8, 3.0, 255, 255, 255, 0, 0, 1.0, 0.5, 0.5);
				ShowHudText(i, GetDynamicChannel(3), "%s", finalMess);
			}else{
				PrintCenterText(i, "%s", finalMess);
			}
		}
	}
}

void AnnounceChaos(char[] message, float EffectTime, bool endingChaos = false, bool megaChaos = false){
	char announcingMessage[128];
	if(megaChaos){
		DisplayCenterTextToAll(message);
		Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix_MegaChaos, message);
	}else if(endingChaos){
		Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix_EndChaos, message);
	}else{
		DisplayCenterTextToAll(message);
		Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix, message);
	}
	CPrintToChatAll(announcingMessage);

	char EffectName[256];
	FormatEx(EffectName, sizeof(EffectName), "%s", RemoveMulticolors(message));
	if(!endingChaos && EffectTime > -2.0){
		if(g_DynamicChannel){
			if(EffectTime == 0.0){
				AddEffectToHud(EffectName, 9999.0);
			}else{
				AddEffectToHud(EffectName, EffectTime);
			}
		}
	}
}


// UserMessageId for Fade.
UserMsg g_FadeUserMsgId;
void PerformBlind(int target, int amount)
{
	int targets[2];
	targets[0] = target;
	
	int duration = 1536;
	int holdtime = 1536;
	int flags;
	if (amount == 0)
	{
		flags = (0x0001 | 0x0010);
	}
	else
	{
		flags = (0x0002 | 0x0008);
	}
	
	int color[4] = { 0, 0, 0, 0 };
	color[3] = amount;
	g_FadeUserMsgId = GetUserMessageId("Fade");
	
	// Handle message = StartMessageEx(g_FadeUserMsgId, targets, 1);
	Handle message = StartMessageEx(g_FadeUserMsgId, targets, 1);
	if (GetUserMessageType() == UM_Protobuf){
		Protobuf pb = UserMessageToProtobuf(message);
		pb.SetInt("duration", duration);
		pb.SetInt("hold_time", holdtime);
		pb.SetInt("flags", flags);
		pb.SetColor("clr", color);
	}else{
		BfWrite bf = UserMessageToBfWrite(message);
		bf.WriteShort(duration);
		bf.WriteShort(holdtime);
		bf.WriteShort(flags);		
		bf.WriteByte(color[0]);
		bf.WriteByte(color[1]);
		bf.WriteByte(color[2]);
		bf.WriteByte(color[3]);
	}
	
	EndMessage();

}


stock bool SetClientMoney(int client, int money, bool absolute = false){
	if(IsValidClient(client)){
		if(absolute){
			SetEntProp(client, Prop_Send, "m_iAccount", money);
		}else{
			SetEntProp(client, Prop_Send, "m_iAccount", GetEntProp(client, Prop_Send, "m_iAccount")+money);
		}
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
		
		return false;
	}else{
		return false;
	}
} 

bool g_bRemovechicken_debounce = false;
void RemoveChickens(bool removec4Chicken = false){
	if(!g_bRemovechicken_debounce){
		Log("[Chaos] > Removing Chickens");
		g_bRemovechicken_debounce = true;
		int iMaxEnts = GetMaxEntities();
		char sClassName[64];
		for(int i=MaxClients;i<iMaxEnts;i++){
			if(IsValidEntity(i) && 
			IsValidEdict(i) && 
			GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
			StrEqual(sClassName, "chicken")
			&& GetEntPropEnt(i, Prop_Send, "m_hOwnerEntity") == -1){
				if(removec4Chicken){
					if(i == g_iC4ChickenEnt){
						RemoveEntity(i);
					}
				}else{
					if(i != g_iC4ChickenEnt){
						SetEntPropFloat(i, Prop_Data, "m_flModelScale", 1.0);
						RemoveEntity(i);
					}
				}

			}
		}
		CreateTimer(5.0, timer_resetchickendebounce);
	}
}  

public Action timer_resetchickendebounce(Handle timer){
	g_bRemovechicken_debounce = false;
}

public void ResizeChickens(){
    int iMaxEnts = GetMaxEntities();
    char sClassName[64];
    for(int i=MaxClients;i<iMaxEnts;i++){
        if(IsValidEntity(i) && 
           IsValidEdict(i) && 
           GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
           StrEqual(sClassName, "chicken") &&
           GetEntPropEnt(i, Prop_Send, "m_hOwnerEntity") == -1){
			SetEntPropFloat(i, Prop_Data, "m_flModelScale", 1.0);
        }
    }
}  



stock void SetClip(int weaponid,int ammosize, int clipsize) {
    SetEntData(weaponid, g_iOffset_Clip1, ammosize);
    SetEntProp(weaponid, Prop_Send, "m_iPrimaryReserveAmmoCount", clipsize);
}

stock int GetAliveTCount(){
	int count = 0;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_T){
			count++;
		}
	}
	return count;
}

stock int GetAliveCTCount(){
	int count = 0;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_CT){
			count++;
		}
	}
	return count;
}



public int getRandomAlivePlayer(){
	int id = -1;
	int attempts = 0;
	while(!ValidAndAlive(id)){
		id = GetRandomInt(0,MAXPLAYERS+1);
		attempts++;
		if(attempts > 9999) break;
	}	
	return id;
}

stock void Log(const char[] format, any ...)
{
	char buffer[254];
	VFormat(buffer, sizeof(buffer), format, 2);
	char sLogPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sLogPath, sizeof(sLogPath), "logs/chaos_logs.log");
	LogToFile(sLogPath, buffer);
}

//HELPERS
public void cvar(char[] cvarname, char[] value){
	ConVar hndl = FindConVar(cvarname);
	if (hndl != null) hndl.SetString(value, true);
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




float SanitizeTime(float time){
	if(time <= 0) return 0.0;
	if(time < 5) return 5.0;
	if(time > 120) return 0.0;
	return time;
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

void SavePlayersLocations(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, g_AllPositions[i]);
		}
	}
}

//make sure to SavePlayersLocations before using this.
float no_vel[3] = {0.0, 0.0, 0.0};

void TeleportPlayersToClosestLocation(int client = -1, int minDist = 0){
	if(g_MapCoordinates != INVALID_HANDLE){
		ClearArray(g_UnusedCoordinates);

		for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			PushArrayArray(g_UnusedCoordinates, vec);
		}

		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				if(client != -1 && client != i) continue; //only set specific player
				int CoordinateIndex = -1;
				float DistanceToBeat = 99999.0;
				if(GetArraySize(g_UnusedCoordinates) > 0){
					float playersVec[3];
					GetClientAbsOrigin(i, playersVec);
					for(int coord = 0; coord <= GetArraySize(g_UnusedCoordinates)-1; coord++){
						float vec[3];
						GetArrayArray(g_UnusedCoordinates, coord, vec);
						if(DistanceToClosestBarrel(vec) > 50){
							float dist = GetVectorDistance(playersVec, vec);
							if((dist < DistanceToBeat) && dist >= minDist){
								CoordinateIndex = coord;
								DistanceToBeat = dist;
							}
						}
					}
					if(CoordinateIndex != -1){
						float realVec[3];
						do{
							GetArrayArray(g_UnusedCoordinates, CoordinateIndex, realVec);
						}
						while(DistanceToClosestBarrel(realVec) < 50);
						// realVec[2] = realVec[2] - 60;
						TeleportEntity(i, realVec, NULL_VECTOR, no_vel);
						RemoveFromArray(g_UnusedCoordinates, CoordinateIndex);
						CoordinateIndex = -1;
						DistanceToBeat = 99999.0;
					}else{
						TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
					}
				}else{
					TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
				}
				SetEntityMoveType(i, MOVETYPE_WALK);
			}
		}


	} else{
		for(int i = 0; i <= MaxClients; i++){
			if(IsValidClient(i)){
				TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
				SetEntityMoveType(i, MOVETYPE_WALK);
			}
		}
	}
	
}





bool CreateParticle(char []particle, float[3] vec){
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

bool CurrentlyActive(Handle timer){
	if(timer != INVALID_HANDLE){
		Log("Effect is already currently running, trying new effect.");
		RetryEffect();
		return true;
	}
	return false;
}

int DistanceToClosestBarrel(float vec[3]){
	float dist = 999999.0;
	float barrelVec[3];

	int iMaxEnts = GetMaxEntities();
	char sClassName[64];
	for(int i=MaxClients;i<iMaxEnts;i++){
		if(IsValidEntity(i) && IsValidEdict(i) && 
		GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
		StrEqual(sClassName, "prop_exploding_barrel")){
			GetEntPropVector(i, Prop_Send, "m_vecOrigin", barrelVec);
			if(GetVectorDistance(barrelVec, vec) < dist){
				dist = GetVectorDistance(barrelVec, vec);
			}
		}
	}
	return RoundToFloor(dist);
}


void DoRandomTeleport(int client = -1){
	Log("[Chaos] Running: DoRandomTeleport (function, not chaos event)");

	// if(g_MapCoordinates == INVALID_HANDLE) return false;

	ClearArray(g_UnusedCoordinates);

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		float vec[3];
		GetArrayArray(g_MapCoordinates, i, vec);
		PushArrayArray(g_UnusedCoordinates, vec);
	}
	if(client == -1){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i) && GetArraySize(g_UnusedCoordinates) > 0){
				int randomCoord = GetRandomInt(0, GetArraySize(g_UnusedCoordinates)-1);
				float vec[3];
				GetArrayArray(g_UnusedCoordinates, randomCoord, vec);
				if(DistanceToClosestBarrel(vec) > 50){
					TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
					PrintToConsole(i, "%N to %f %f %f", i, vec[0], vec[1], vec[2]);
					RemoveFromArray(g_UnusedCoordinates, randomCoord);
				}
			}
		}
	}else{
		int randomCoord = GetRandomInt(0, GetArraySize(g_UnusedCoordinates)-1);
		float vec[3];
		GetArrayArray(g_UnusedCoordinates, randomCoord, vec);
		if(DistanceToClosestBarrel(vec) > 50){
			TeleportEntity(client, vec, NULL_VECTOR, NULL_VECTOR);
			PrintToConsole(client, "%N to %f %f %f", client, vec[0], vec[1], vec[2]);
			RemoveFromArray(g_UnusedCoordinates, randomCoord);
		}
	}
}




stock void CreateHostageRescue(){
    int iEntity = -1;
    if((iEntity = FindEntityByClassname(iEntity, "func_hostage_rescue")) == -1) {
        int iHostageRescueEnt = CreateEntityByName("func_hostage_rescue");
        DispatchKeyValue(iHostageRescueEnt, "targetname", "fake_hostage_rescue");
        DispatchKeyValue(iHostageRescueEnt, "origin", "-3141 -5926 -5358");
        DispatchSpawn(iHostageRescueEnt);
    }
}

stock int GetSlotByWeaponName (int client, const char[] szName){
	char szClassname[36];
	int entity = -1;
	for (int i; i <= 20; i++){
		// if ((entity = GetPlayerWeaponSlot(client, i)) <= MaxClients || !IsValidEntity(entity)) continue;
		entity = GetPlayerWeaponSlot(client, i);
		if(!IsValidEntity(entity)) continue;
		GetEntityClassname(entity, szClassname, sizeof szClassname);
		if (strcmp(szName, szClassname) == 0)return i;
	}
	return -1;
}

//returns the units between vec[3] and the closest player
int DistanceToClosestPlayer(float vec[3]){
	float dist = 999999.0;
	float playerVec[3];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, playerVec);
			if(GetVectorDistance(playerVec, vec) < dist){
				dist = GetVectorDistance(playerVec, vec);
			}
		}
	}
	return RoundToFloor(dist);
}

stock int ScreenShake(int iClient, float fAmplitude = 50.0, float duration = 7.0){
	Handle hMessage = StartMessageOne("Shake", iClient, 1);
	
	PbSetInt(hMessage, "command", 0);
	PbSetFloat(hMessage, "local_amplitude", fAmplitude);
	PbSetFloat(hMessage, "frequency", 255.0);
	PbSetFloat(hMessage, "duration", duration);
	
	EndMessage();
}



bool HasMenuOpen(int client){
	if(GetClientMenu(client) != MenuSource_None) return true;
	return false;
}

// void CancelMenu(int client){
// 	CancelClientMenu(client,true);
// }
