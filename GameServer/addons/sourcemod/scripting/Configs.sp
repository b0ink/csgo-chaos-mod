Handle g_AutoCoord_Timer = INVALID_HANDLE;

public void ParseChaosEffects(){
	ChaosEffects.Clear();

	char function_name[64];
	int count = 0;
	for(int i = 0; i < sizeof(EffectNames); i++)
	{
		effect_data effect; // Ensures a new object every time
		Function effect_function = GetFunctionByName(GetMyHandle(), EffectNames[i]);

		if(effect_function == INVALID_FUNCTION){
			Log("Couldnt find setup function for %s", EffectNames[i]);
			continue;
		}
		count++;

		Call_StartFunction(GetMyHandle(), effect_function);
		Call_PushArrayEx(effect, sizeof(effect), SM_PARAM_COPYBACK);
		Call_Finish();

		Format(function_name, sizeof(function_name), "%s_START", EffectNames[i]);
		// effect.function_name_start = function_name;
		Function start_func = GetFunctionByName(GetMyHandle(), function_name);

		Format(function_name, sizeof(function_name), "%s_RESET", EffectNames[i]);
		// effect.function_name_reset = function_name;
		// Function reset_func = GetFunctionByName(GetMyHandle(), function_name);

		if(start_func == INVALID_FUNCTION){
			Log("Could not find start function for %s", EffectNames[i]);
			continue;
		}
		// if(start_func == INVALID_FUNCTION || reset_func == INVALID_FUNCTION) continue;

		if(effect.Duration > 0 && effect.HasNoDuration == true){
			effect.Duration = 0;
		}
		
		Format(function_name, sizeof(function_name), EffectNames[i]);
		Format(effect.FunctionName, sizeof(effect.FunctionName), "%s", function_name);
		effect.Enabled = true;

		char Chaos_Function_Title[64];

		// If valid translation exists, use translation, else use plugin default
		if(TranslationPhraseExists(effect.FunctionName) && IsTranslatedForLanguage(effect.FunctionName, LANG_SERVER)){
			Format(Chaos_Function_Title, sizeof(Chaos_Function_Title), "%t", effect.FunctionName, LANG_SERVER);
			effect.Title = Chaos_Function_Title;
		}

		ChaosEffects.PushArray(effect);

	}

	ChaosEffects.Sort(Sort_Ascending, Sort_String); // sort the effects alphabetically

	effect_data effect;
	char init_function[64];
	LoopAllEffects(effect, index){
		Format(init_function, sizeof(init_function), "%s_INIT", effect.FunctionName);
		Function func = GetFunctionByName(GetMyHandle(), init_function);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish();
		}
		effect.ID = index;
		ChaosEffects.SetArray(index, effect);
	}
}



public void OnConfigsExecuted(){
	
	ParseMapCoordinates("Chaos_Locations");
	// ParseChaosConfigEffects();
	ParseOverrideEffects();

	int warnings = 0;
	Log("---------------------------------CONFIGS EXECUTED---------------------------------");
	if(!ValidMapPoints()){
		warnings++;
		Log("ERROR: No valid spawn points were found for %s. Certain effects will not run.", mapName);
	}else{
		Log("MAP SPAWNS FOUND.");
	}
	if(isHostageMap()){
		warnings++;
		Log("WARNING: %s has been flagged as a hostage map, certain C4 effects will be disabled.", mapName);
	}
	if(!ValidBombSpawns()){
		warnings++;
		Log("No valid bomb spawns were found for %s. Certain C4 effects will not run.", mapName);
	}
	StopTimer(g_AutoCoord_Timer);

	if(!ValidMapPoints()){
		Log("No valid map points. Locations will be automatically saved");
		ParseMapCoordinates("Chaos_TempLocations");
		CreateTimer(2.5, Timer_SaveCoordinates, _, TIMER_REPEAT);
	}

	Run_OnMapStart_Functions();

}


void Run_OnMapStart_Functions(){
	effect_data effect;
	char init_function[64];
	LoopAllEffects(effect, index){
		Format(init_function, sizeof(init_function), "%s_OnMapStart", effect.FunctionName);
		Function func = GetFunctionByName(GetMyHandle(), init_function);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish();
		}
	}
}

void SaveBombPosition(){
	float c4_location[3];
	bool found = false;

	char classname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		if(StrEqual(classname, "planted_c4")){ //&& GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == -1){
			found = true;
			GetEntPropVector(ent, Prop_Send, "m_vecOrigin", c4_location);
		}
	}
	if(!found) return;

	int site = GetNearestBombsite(c4_location);
	if(site == BOMBSITE_INVALID) return;

	char c4_loc_string[64];
	FormatEx(c4_loc_string, sizeof(c4_loc_string), "%f %f %f", c4_location[0], c4_location[1], c4_location[2]);

	if(site == BOMBSITE_A){
		UpdateConfig(-1, "Chaos_TempLocations", "Maps", mapName, "bombA", c4_loc_string, .folderPath="data");
		PushArrayArray(bombSiteA, c4_location);
	}else if(site == BOMBSITE_B){
		UpdateConfig(-1, "Chaos_TempLocations", "Maps", mapName, "bombB", c4_loc_string, .folderPath="data");
		PushArrayArray(bombSiteB, c4_location);
	}



	PushArrayArray(g_MapCoordinates, c4_location);


}

public Action Timer_SaveCoordinates(Handle timer){
		
	if (GameRules_GetProp("m_bWarmupPeriod") == 1) return;

	float client_vec[3];
	float client_vel[3];
	float compare_vec[3];
	char client_vec_string[64];
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, client_vec);
		
		GetEntPropVector(i, Prop_Data, "m_vecVelocity", client_vel);
				
		if(!(GetClientButtons(i) & IN_DUCK) && client_vel[2] == 0.0 && GetEntityMoveType(i) == MOVETYPE_WALK && GetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue") == 1.0) { //ensure player isnt mid jump or falling down
			FormatEx(client_vec_string, sizeof(client_vec_string), "%f %f %f", client_vec[0], client_vec[1], client_vec[2]);
			if(GetArraySize(g_MapCoordinates) == 0){
				UpdateConfig(-1, "Chaos_TempLocations", "Maps", mapName, client_vec_string, client_vec_string, .folderPath="data");
				PushArrayArray(g_MapCoordinates, client_vec);
			}else{
				float distanceToBeat = 99999.0;
				for(int g = 0; g < GetArraySize(g_MapCoordinates); g++){
					GetArrayArray(g_MapCoordinates, g, compare_vec, sizeof(compare_vec));
					float dist = GetVectorDistance(client_vec, compare_vec);
					if(dist < distanceToBeat){
						distanceToBeat = dist;
					}
				}
				if(distanceToBeat > 250){
					UpdateConfig(-1, "Chaos_TempLocations", "Maps", mapName, client_vec_string, client_vec_string, .folderPath="data");
					PushArrayArray(g_MapCoordinates, client_vec);
				}
			}

		}
	}
}


void ParseOverrideEffects(){
	char filePath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, filePath, sizeof(filePath), "configs/Chaos/Chaos_Override.cfg");

	if(!FileExists(filePath)){
		return;
	}
	KeyValues kvConfig = new KeyValues("Effects");

	if(!kvConfig.ImportFromFile(filePath)){
		return;
	}

	if(!kvConfig.GotoFirstSubKey()){
		return;
	}

	do{
		char Chaos_Function_Name[64];

		if (kvConfig.GetSectionName(Chaos_Function_Name, sizeof(Chaos_Function_Name))){
			int enabled = kvConfig.GetNum("enabled", 1);
			int expires = kvConfig.GetNum("duration", -1);

			if(enabled != 0 && enabled != 1) enabled = 1;

			effect_data effect;

			LoopAllEffects(effect, index){
				if(StrEqual(effect.FunctionName, Chaos_Function_Name, false)){
					effect.Enabled = view_as<bool>(enabled);
					if(!effect.OverrideDuration && expires > -1){
						effect.Duration = expires;
					}else {
						if(expires > -1){
							Log("Can not set duration for effect '%s' as it is controlled by the plugin.", Chaos_Function_Name);
						}
					}
					ChaosEffects.SetArray(index, effect);
					// PrintToChatAll("Found %s override and setting enabled to %i and duration to %i", Chaos_Function_Name, enabled, expires);
				}
			}
		}
	} while(kvConfig.GotoNextKey());

	ChaosEffects.Sort(Sort_Ascending, Sort_String); // sort the effects alphabetically

	Log("Parsed Chaos_Override.cfg Effects succesfully!");
} 

void COORD_INIT() {g_UnusedCoordinates = CreateArray(3); }

void ParseMapCoordinates(char[] config) {
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "data/Chaos/%s.cfg", config);

	if(g_MapCoordinates == INVALID_HANDLE){
		g_MapCoordinates = CreateArray(3);
		bombSiteA = CreateArray(3);
		bombSiteB = CreateArray(3);
	}else{
		if(StrEqual(config, "Chaos_Locations", false)){
			ClearArray(g_MapCoordinates);
			ClearArray(bombSiteA);
			ClearArray(bombSiteB);
		}
	}

	if(!FileExists(path)){
		Log("Could not find %s. Effects that rely on map data will not run.", path);
		return;
	}
	
	char MapName[128];
	GetCurrentMap(MapName, sizeof(MapName));

	KeyValues kv = new KeyValues("Maps");
	
	if(!kv.ImportFromFile(path)){
		Log("Unable to parse Key Values from %s", path);
		return;
	}
	//jump to key of map name
	if(!kv.JumpToKey(MapName)){
		Log("Unable to find %s Key from %s", MapName, path);
		return;
	}

	if(!kv.GotoFirstSubKey(false)){
		Log("Unable to find sub keys %s", path);
		return;
	}

	//all keys are fine to go in the all map coordinates, but we ALSO want to add bombA and bombB to respective handles; 
	do{
		float vec[3];
		kv.GetVector(NULL_STRING, vec);
		char key[25];
		kv.GetSectionName(key, sizeof(key));
		if(StrContains(key, "bombA", false) != -1) PushArrayArray(bombSiteA, vec);
		if(StrContains(key, "bombB", false) != -1) PushArrayArray(bombSiteB, vec);
		PushArrayArray(g_MapCoordinates, vec);
	} while(kv.GotoNextKey(false));

	delete kv;
}

void UpdateConfig(int client = -1, char[] config, char[] KeyValues_name, char[] function_name, char[] key, char[] newValue, char[] folderPath="configs"){
	char path[PLATFORM_MAX_PATH];
	//TODO: for /data and /configs
	BuildPath(Path_SM, path, sizeof(path), "%s/Chaos/%s.cfg", folderPath, config);

	KeyValues kvConfig = new KeyValues(KeyValues_name);

	if(!FileExists(path)){
		Handle FileHandle = OpenFile(path, "w");
		if(!FileHandle){
			CloseHandle(FileHandle);
			return;
		}
		CloseHandle(FileHandle);
	}else{
		if(!kvConfig.ImportFromFile(path)){
			Log("Unable to parse Key Values file %s.", path);
		}
	}

	kvConfig.JumpToKey(function_name, true);
	kvConfig.SetString(key, newValue);
	kvConfig.Rewind();
	kvConfig.ExportToFile(path);

	if(kvConfig.ExportToFile(path)){

		if(IsValidClient(client)){
			PrintToChatAll("Effect '%s' modified in config. Key '%s' has been set to '%s'", function_name, key, newValue);
			Log("Effect '%s' modified in config. Key '%s' has been set to '%s'", function_name, key, newValue);
		}
		if(StrEqual(KeyValues_name, "Effects", false)){
			// ParseChaosConfigEffects();
			ParseOverrideEffects();
		}
	}else{
		if(IsValidClient(client)){
			PrintToChat(client, "[Chaos] Failed to update config.");
		}
	}
	delete 	kvConfig;
}


void LogEffect(char[] function_name){
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "data/Chaos/Chaos_Statistics.cfg");

	KeyValues kvConfig = new KeyValues("Stats");

	if(!FileExists(path)){
		Handle FileHandle = OpenFile(path, "w");
		if(!FileHandle){
			CloseHandle(FileHandle);
			return;
		}
		CloseHandle(FileHandle);
	}else{
		if(!kvConfig.ImportFromFile(path)){
			Log("Unable to parse Key Values file %s.", path);
		}
	}

	kvConfig.JumpToKey(function_name, true);

	int currentValue = kvConfig.GetNum("Times Ran", 0);
	kvConfig.SetNum("Times Ran", currentValue + 1);
	kvConfig.Rewind();
	kvConfig.ExportToFile(path);

	if(!kvConfig.ExportToFile(path)){
		Log("Error saving to %s", path);
	}

	delete 	kvConfig;
}