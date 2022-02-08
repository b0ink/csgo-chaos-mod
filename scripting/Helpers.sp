float g_AllPositions[MAXPLAYERS+1][3];


bool findInArray(int[] array, int target, int arraysize){
	bool found = false;
	for(int i = 0; i < arraysize; i++) if(array[i] == target) found = true;
	if(found) return true;
	return false;
}


bool ValidMapPoints(){
	if(g_MapCoordinates == INVALID_HANDLE) return false;
	return true;
}

bool ValidBombSpawns(){
	if(GetArraySize(bombSiteA) == 0 || GetArraySize(bombSiteB) == 0) return false;
	return true;
}

bool CountingCheckDecideChaos(){
	if(g_bCountingChaos) {	g_iChaos_Event_Count++;	if(!g_bDecidingChaos) {  return true;  }}
	return false;
}

bool DecidingChaos(char[] EffectName = ""){
	//if effectname was provided manually, 
	if(EffectName[0] && g_sSelectedChaosEffect[0]){
		if(!g_bDecidingChaos
					|| ((StrContains(g_sSelectedChaosEffect, EffectName, false) == -1) 
					&& (StrContains(EffectName, g_sSelectedChaosEffect, false) == -1))){
						return true;
					}else{
						CreateTimer(0.5, Timer_ResetCustomChaosSelection);
						return false;
					}
	}
	if(g_bClearChaos || !g_bDecidingChaos || (g_iChaos_Event_Count != g_iRandomEvent)) return true;
	return false;
}


void CountChaos(bool Reset = false){
	if(Reset) g_bClearChaos = true;
	g_iChaos_Event_Count = 0;
	g_bDecidingChaos = false;
	g_bCountingChaos = true;
	Chaos();
}



//currently a hotfix but there is a bool value somewhere that handles the custom selection just fine.. todo for another time.
public Action Timer_ResetCustomChaosSelection(Handle timer){
	g_sSelectedChaosEffect = "";
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

float GetChaosTime(char[] EffectName, float defaultTime = 15.0){
	float OverwriteDuration = g_fChaos_OverwriteDuration;
	if(OverwriteDuration < -1.0){
		Log("Cvar 'OverwriteEffectDuration' set Out Of Bounds in Chaos_Settings.cfg, effects will use their durations in Chaos_Effects.cfg");
		OverwriteDuration = - 1.0;
	}

	int Chaos_Properties[2];
	float expire = defaultTime;
	if(Chaos_Effects.GetArray(EffectName, Chaos_Properties, 2)){
		if(OverwriteDuration == -1.0){
			expire = float(Chaos_Properties[CONFIG_EXPIRE]);
		}else{
			expire = OverwriteDuration;
		}
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

	return expire;
}









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
			PrintCenterText(i, "%s", finalMess);
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
		if(g_DynamicChannel) AddEffectToHud(EffectName, EffectTime);
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
	if (IsValidClient(client) && IsPlayerAlive(client)){
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
		if(IsValidClient(i) && IsPlayerAlive(i)){
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
			if(IsValidClient(i) && IsPlayerAlive(i)){
				if(client != -1 && client != i) continue; //only set specific player
				int CoordinateIndex = -1;
				float DistanceToBeat = 99999.0;
				if(GetArraySize(g_UnusedCoordinates) > 0){
					float playersVec[3];
					GetClientAbsOrigin(i, playersVec);
					for(int coord = 0; coord <= GetArraySize(g_UnusedCoordinates)-1; coord++){
						float vec[3];
						GetArrayArray(g_UnusedCoordinates, coord, vec);
						float dist = GetVectorDistance(playersVec, vec);
						if((dist < DistanceToBeat) && dist >= minDist){
							CoordinateIndex = coord;
							DistanceToBeat = dist;
						}
					}
					if(CoordinateIndex != -1){
						float realVec[3];
						GetArrayArray(g_UnusedCoordinates, CoordinateIndex, realVec);
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
		RetryEvent();
	}
	return false;
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
			if(IsValidClient(i) && IsPlayerAlive(i) && GetArraySize(g_UnusedCoordinates) > 0){
				int randomCoord = GetRandomInt(0, GetArraySize(g_UnusedCoordinates)-1);
				float vec[3];
				GetArrayArray(g_UnusedCoordinates, randomCoord, vec);
				TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
				PrintToConsole(i, "%N to %f %f %f", i, vec[0], vec[1], vec[2]);
				RemoveFromArray(g_UnusedCoordinates, randomCoord);
			}
		}
	}else{
		int randomCoord = GetRandomInt(0, GetArraySize(g_UnusedCoordinates)-1);
		float vec[3];
		GetArrayArray(g_UnusedCoordinates, randomCoord, vec);
		TeleportEntity(client, vec, NULL_VECTOR, NULL_VECTOR);
		PrintToConsole(client, "%N to %f %f %f", client, vec[0], vec[1], vec[2]);
		RemoveFromArray(g_UnusedCoordinates, randomCoord);
	}
}

void UpdateCvars(){
	g_bChaos_Enabled = g_cvChaosEnabled.BoolValue;
	g_fChaos_EffectInterval = g_cvChaosEffectInterval.FloatValue;
	g_bChaos_Repeating = g_cvChaosRepeating.BoolValue;
	g_fChaos_OverwriteDuration = g_cvChaosOverwriteDuration.FloatValue;
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
