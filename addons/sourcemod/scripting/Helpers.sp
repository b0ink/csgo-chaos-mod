
bool ValidMapPoints(){
	if(g_MapCoordinates == INVALID_HANDLE) return false;
	if(GetArraySize(g_MapCoordinates) == 0) return false;
	if(GetArraySize(g_MapCoordinates) < (GetPlayerCount() * 4)) return false;
	return true;
}

bool ValidBombSpawns(){
	if(bombSiteA == INVALID_HANDLE) return false;
	if(bombSiteB == INVALID_HANDLE) return false;
	if(GetArraySize(bombSiteA) == 0 || GetArraySize(bombSiteB) == 0) return false;
	return true;
}

bool GetEffectData(char[] function_name, effect return_data){
	effect effect_data;
	bool found = false;
	LoopAllEffects(effect_data){
		if(StrEqual(effect_data.config_name, function_name, false)){
			found = true;
			break;
		}
	}

	if(found) return_data = effect_data;
	return found;
	// return null;
}

float GetChaosTime(char[] EffectName, float defaultTime = 15.0, bool raw = false){
	float expire = defaultTime;
	effect effect_data;
	if(GetEffectData(EffectName, effect_data)){
		expire = effect_data.Get_Duration(raw);
	}else{
		Log("[CONFIG] Could not find configuration for Effect: %s, using default of %f", EffectName, defaultTime);
	}
	return expire;
}


char[] GetChaosTitle(char[] function_name){
	char return_string[128];
	char temp_title[128];
	if(StrContains(function_name, "Chaos_") != -1){
		FormatEx(temp_title, sizeof(temp_title), "%s_Title", function_name);
		FormatEx(return_string, sizeof(return_string), "%t", temp_title, LANG_SERVER);
	}else{
		FormatEx(return_string, sizeof(return_string), "%s", function_name);
	}

	return return_string;
}



bool PoolChaosEffects(char[] effectName = ""){

	Possible_Chaos_Effects.Clear();

	effect data;
	LoopAllEffects(data){
		if(effectName[0]){ //* if keyword was provided
			if(StrContains(data.config_name, effectName, false) != -1){ //TODO: allow for aliases
				Possible_Chaos_Effects.PushArray(data, sizeof(data));
			}
		}else{
			// if(foo.can_run_effect()){ //TODO: allow all?
			Possible_Chaos_Effects.PushArray(data, sizeof(data));
			// }
		}
	}

	Log("Size of pooled chaos effects: %i", Possible_Chaos_Effects.Length);
	// Log("Size of pooled chaos effects: %i", GetArraySize(Possible_Chaos_Effects));
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
			SetHudTextParams(-1.0, 0.8, 3.0, 255, 255, 255, 0, 0, 1.0, 0.5, 0.5);
			if(g_DynamicChannel){
				ShowHudText(i, GetDynamicChannel(3), "%s", finalMess);
			}else{
				ShowHudText(i, -1, "%s", finalMess);
				// PrintCenterText(i, "%s", finalMess);
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




stock int GetPlayerCount(){
	int count = 0;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			count++;
		}
	}
	return count;
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
	Handle players = CreateArray(4);
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			PushArrayCell(players, i);
		}
	}
	int random = GetRandomInt(0, GetArraySize(players) - 1);
	int target = GetArrayCell(players, random);
	delete players;
	return target;
}

stock void Log(const char[] format, any ...)
{
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

float g_AllPositions[MAXPLAYERS+1][3];

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
						if(DistanceToClosestEntity(vec, "prop_exploding_barrel") > 50){
							float dist = GetVectorDistance(playersVec, vec);
							if((dist < DistanceToBeat) && dist >= minDist){
								CoordinateIndex = coord;
								DistanceToBeat = dist;
							}
						}
					}
					if(CoordinateIndex != -1){
						float realVec[3];
						//TODO: come back to this??
						do{
							GetArrayArray(g_UnusedCoordinates, CoordinateIndex, realVec);
						}
						while(DistanceToClosestEntity(realVec, "prop_exploding_barrel") < 50);
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

// bool CurrentlyActive(Handle timer){
// 	if(timer != INVALID_HANDLE){
// 		Log("Effect is already currently running, trying new effect.");
// 		RetryEffect();
// 		return true;
// 	}
// 	return false;
// }



void DoRandomTeleport(int client = -1){
	Log("[Chaos] Running: DoRandomTeleport (function, not chaos event)");

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
				if(DistanceToClosestEntity(vec, "prop_exploding_barrel") > 50){
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
		if(DistanceToClosestEntity(vec, "prop_exploding_barrel") > 50){
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

int DistanceToClosestEntity(float vec[3], char[] entity){
	float dist = 999999.0;
	float barrelVec[3];

	int iMaxEnts = GetMaxEntities();
	char sClassName[64];
	for(int i=MaxClients;i<iMaxEnts;i++){
		if(IsValidEntity(i) && IsValidEdict(i) && 
		GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
		StrEqual(sClassName, entity)){
			GetEntPropVector(i, Prop_Send, "m_vecOrigin", barrelVec);
			if(GetVectorDistance(barrelVec, vec) < dist){
				dist = GetVectorDistance(barrelVec, vec);
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

bool g_bIsHostageMap = false;
void CheckHostageMap(){
	g_bIsHostageMap = false;
	int index = -1;
	index = FindEntityByClassname(index, "hostage_entity");
	if(index != -1){
		g_bIsHostageMap = true;
		return;
	}
	g_bIsHostageMap = false;
}

bool isHostageMap(){
	return g_bIsHostageMap;
}

//Overlays

Handle Overlay_Que = INVALID_HANDLE;
void Overlay_INIT(){
	if(Overlay_Que == INVALID_HANDLE){
		Overlay_Que = CreateArray(256);
	}else{
		ClearArray(Overlay_Que);
	}
}

void Clear_Overlay_Que(){
	if(Overlay_Que != INVALID_HANDLE){
		ClearArray(Overlay_Que);
	}else{
		Overlay_INIT();
	}
	Update_Overlay();
}

void Add_Overlay(char[] path){
	PushArrayString(Overlay_Que, path);
	Update_Overlay();
}

void Remove_Overlay(char[] path){
	int index = -1;
	while((index = FindStringInArray(Overlay_Que, path)) != -1){
		if(index != -1){
			RemoveFromArray(Overlay_Que, index);
		}else{
			break;
		}
	}
	Update_Overlay();
}

void Update_Overlay(){
	char path[256];
	if(GetArraySize(Overlay_Que) > 0){
		GetArrayString(Overlay_Que, 0, path, sizeof(path));
	}else{
		path = "";
	}

	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			ClientCommand(i, "r_screenoverlay \"%s\"", path);
		}
	}
}


void SetPlayersGravity(float amount){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntityGravity(i, amount);
		}
	}
}

void SetPlayersFOV(int fov){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntProp(i, Prop_Send, "m_iFOV", fov);
			SetEntProp(i, Prop_Send, "m_iDefaultFOV", fov);
		}
	}
}

void ResetPlayersFOV(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetEntProp(i, Prop_Send, "m_iFOV", 0);
			SetEntProp(i, Prop_Send, "m_iDefaultFOV", 90);
		}
	}
}
