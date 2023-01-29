#pragma semicolon 1



bool GetEffectData(char[] function_name, effect_data return_data){
	effect_data effect;
	bool found = false;
	LoopAllEffects(effect, index){
		if(StrEqual(effect.FunctionName, function_name, false)){
			found = true;
			break;
		}
	}

	if(found) return_data = effect;
	return found;
	// return null;
}

float GetChaosTime(char[] EffectName, float defaultTime = 15.0, bool raw = false){
	float expire = defaultTime;
	effect_data effect;
	if(GetEffectData(EffectName, effect)){
		expire = effect.GetDuration(raw);
	}else{
		Log("[CONFIG] Could not find configuration for Effect: %s, using default of %f", EffectName, defaultTime);
	}
	return expire;
}

//TODO: remove the need for GetChaosTitle -> use GetEffectDate and use effect.Title more instead of this jank
char[] GetChaosTitle(char[] function_name){
	char return_string[128];

	effect_data effect;
	GetEffectData(function_name, effect);

	if(StrContains(function_name, "Chaos_") != -1){
		if(TranslationPhraseExists(function_name) && IsTranslatedForLanguage(function_name, LANG_SERVER)){
				FormatEx(return_string, sizeof(return_string), "%t", function_name, LANG_SERVER);
		}else{
			FormatEx(return_string, sizeof(return_string), "%s", effect.Title);
		}
	}else{
		FormatEx(return_string, sizeof(return_string), "%s", function_name);
	}

	return return_string;
}




stock bool IsValidClient(int client, bool nobots = false){
    if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client))) {
        return false;
    }
    return IsClientInGame(client);
}

stock bool ValidAndAlive(int client){
	return (IsValidClient(client) && IsPlayerAlive(client) && (GetClientTeam(client) == CS_TEAM_CT || GetClientTeam(client) == CS_TEAM_T));
}

char multicolors[][] = {"{lightred}", "{lightblue}", "{lightgreen}", "{olive}", "{grey}", "{yellow}", "{bluegrey}", "{orchid}", "{lightred2}",
"{purple}", "{lime}", "{orange}", "{red}", "{blue}", "{darkred}", "{darkblue}", "{default}", "{green}"};

char[] RemoveMulticolors(char[] message){
	char finalMess[256];
	Format(finalMess, sizeof(finalMess), "%s", message);
	for(int i = 0; i < sizeof(multicolors); i++){
		ReplaceString(finalMess, sizeof(finalMess), multicolors[i],"", false);
	}
	return finalMess;
}

void AnnounceChaos(char[] message, float EffectTime, bool endingChaos = false, bool megaChaos = false){
	if(!Meta_IsWhatsHappeningEnabled()){
		char announcingMessage[128];
		if(megaChaos){
			DisplayCenterTextToAll(message);
			Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix_MegaChaos, message);
		}else if(endingChaos){
			Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix_HasTimerEnded, message);
		}else{
			DisplayCenterTextToAll(message);
			Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix, message);
		}
		CPrintToChatAll(announcingMessage);
		PrintHTML(message);
	}


	//TODO: what if hud was purely based off which timers are active. .Run() would save the current game time to predict how long is left
	char EffectName[256];
	FormatEx(EffectName, sizeof(EffectName), "%s", RemoveMulticolors(message));

	if(!endingChaos && EffectTime > -2.0){
		if(g_bDynamicChannelsEnabled){
			if(EffectTime == 0.0){
				AddEffectToHud(EffectName, 9999.0, megaChaos);
			}else{
				AddEffectToHud(EffectName, EffectTime, megaChaos);
			}
		}
	}
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

public Action Timer_ResetChickenDebounce(Handle timer){
	g_bRemovechicken_debounce = false;
	return Plugin_Continue;
}


stock int GetPlayerCount(){
	int count = 0;
	LoopAllClients(i){
		if(IsValidClient(i)){
			count++;
		}
	}
	return count;
}

stock int GetAliveTCount(){
	int count = 0;
	LoopAlivePlayers(i){
		if(GetClientTeam(i) == CS_TEAM_T) count++;
	}
	return count;
}

stock int GetAliveCTCount(){
	int count = 0;
	LoopAlivePlayers(i){
		if(GetClientTeam(i) == CS_TEAM_CT) count++;
	}
	return count;
}



public int getRandomAlivePlayer(){
	Handle players = CreateArray(4);
	LoopAlivePlayers(i){
		PushArrayCell(players, i);
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


stock void CreateHostageRescue(){
    int iEntity = -1;
    if((iEntity = FindEntityByClassname(iEntity, "func_hostage_rescue")) == -1) {
        int iHostageRescueEnt = CreateEntityByName("func_hostage_rescue");
        DispatchKeyValue(iHostageRescueEnt, "targetname", "fake_hostage_rescue");
        // DispatchKeyValue(iHostageRescueEnt, "origin", "-3141 -5926 -5358");
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

#include "Global/Overlay.sp"