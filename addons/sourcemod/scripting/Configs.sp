#define CONFIG_ENABLED 0
#define CONFIG_EXPIRE 1

Handle Effect_Functions = INVALID_HANDLE;
Handle Effect_Titles = INVALID_HANDLE;
Handle Effects_Functions_Titles = INVALID_HANDLE;

Handle g_AutoCoord_Timer = INVALID_HANDLE;

public void OnConfigsExecuted(){

	

	if(Effect_Functions != INVALID_HANDLE){
		ClearArray(Effect_Functions);
		ClearArray(Effect_Titles);
		ClearArray(Effects_Functions_Titles);
	}else{
		Effect_Functions = CreateArray(64);
		Effect_Titles = CreateArray(128);
		Effects_Functions_Titles = CreateArray(200);
	}
	
	ParseMapCoordinates("Chaos_Locations");
	ParseChaosEffects();
	ParseOverrideEffects();
	// ParseCore();

	int warnings = 0;
	Log("---------------------------------CONFIGS EXECUTED---------------------------------");
	Log("-------------------------------------ERRORS--------------------------------------");
	if(!ValidMapPoints()){
		warnings++;
		Log("No valid spawn points were found for %s. Certain effects will not run.", mapName);
	}
	if(isHostageMap()){
		warnings++;
		Log("WARNING: %s has been flagged as a hostage map, certain C4 effects will be disabled.", mapName);
	}
	if(!ValidBombSpawns()){
		warnings++;
		Log("No valid bomb spawns were found for %s. Certain C4 effects will not run.", mapName);
	}
	if(warnings == 0){
		Log("-------------------------------------NONE--------------------------------------");
	}else{
		Log("-------------------------------------------------------------------------------");
	}
	StopTimer(g_AutoCoord_Timer);

	if(!ValidMapPoints()){
		Log("No valid map points. Locations will be automatically saved");
		ParseMapCoordinates("Chaos_TempLocations");
		CreateTimer(2.5, Timer_SaveCoordinates, _, TIMER_REPEAT);
	}

	Run_Init_Functions();

	
}


void Run_Init_Functions(){
	effect foo;
	char init_function[64];
	for(int i = 0; i < alleffects.Length; i++){
		alleffects.GetArray(i, foo, sizeof(foo));
		Format(init_function, sizeof(init_function), "%s_INIT", foo.config_name);
		Function func = GetFunctionByName(GetMyHandle(), init_function);
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_Finish();
		}
	}
}


//todo check on bomb planted, check c4 location, get closest bomb site, save coord 
public Action Timer_SaveCoordinates(Handle timer){
		
	if (GameRules_GetProp("m_bWarmupPeriod") == 1) return;

	float client_vec[3];
	float client_vel[3];
	float compare_vec[3];
	char client_vec_string[64];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, client_vec);
			
			GetEntPropVector(i, Prop_Data, "m_vecVelocity", client_vel);
					
			if(!(GetClientButtons(i) & IN_DUCK) && client_vel[2] == 0.0 && GetEntityMoveType(i) == MOVETYPE_WALK && GetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue") == 1.0) { //ensure player isnt mid jump or falling down
				FormatEx(client_vec_string, sizeof(client_vec_string), "%f %f %f", client_vec[0], client_vec[1], client_vec[2]);
				if(GetArraySize(g_MapCoordinates) == 0){
					UpdateConfig(-1, "Chaos_TempLocations", "Maps", mapName, client_vec_string, client_vec_string);
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
						UpdateConfig(-1, "Chaos_TempLocations", "Maps", mapName, client_vec_string, client_vec_string);
						PushArrayArray(g_MapCoordinates, client_vec);
					}
				}

			}
		}
	}
}

public void PrecacheTextures(){
	PrecacheModel("models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl", true);

	PrecacheModel("models/props_survival/dronegun/dronegun.mdl", true);
	PrecacheModel("models/props_survival/drone/br_drone.mdl", true);
	PrecacheModel("models/props_survival/parachute/chute.mdl", true);
	PrecacheModel("models/props_survival/parachute/v_parachute.mdl", true);
	PrecacheModel("models/props_survival/cash/dufflebag.mdl", true);
	PrecacheModel("models/props_survival/cash/prop_cash_stack.mdl", true);
	PrecacheModel("models/props_survival/upgrades/upgrade_tablet_zone.mdl", true);
	PrecacheModel("models/props_survival/upgrades/parachutepack.mdl", true);
	PrecacheModel("models/props_survival/upgrades/upgrade_tablet_hires.mdl", true);
	PrecacheModel("models/props_survival/upgrades/upgrade_tablet_drone.mdl", true);
	PrecacheModel("models/props_survival/upgrades/upgrade_dz_helmet.mdl", true);
	PrecacheModel("models/props_survival/upgrades/upgrade_dz_armor_helmet.mdl", true);
	PrecacheModel("models/props_survival/upgrades/upgrade_dz_armor.mdl", true);
	PrecacheModel("models/props_survival/jammer/jammer.mdl", true);
	PrecacheModel("models/props_survival/crates/crate_ammobox.mdl", true);
	PrecacheModel("models/weapons/v_parachute.mdl", true);
	PrecacheModel("models/props_survival/briefcase/briefcase.mdl", true);

	PrecacheDecal("Chaos/binoculars.vmt", true);
	PrecacheDecal("Chaos/binoculars.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/binoculars.vtf");
	AddFileToDownloadsTable("materials/Chaos/binoculars.vmt");

	DownloadRawFiles();
}


void ParseChaosEffects(){
	Chaos_Effects.Clear();
	ClearArray(Effect_Functions);
	ClearArray(Effect_Titles);
	ClearArray(Effects_Functions_Titles);
	alleffects.Clear();
	char filePath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, filePath, sizeof(filePath), "configs/Chaos/Chaos_Effects.cfg");

	if(!FileExists(filePath)){
		Log("Configuration file: %s not found.", filePath);
		LogError("Configuration file: %s not found.", filePath);
		SetFailState("[CHAOS] Could not find configuration file: %s", filePath);
		return;
	}
	KeyValues kvConfig = new KeyValues("Effects");

	if(!kvConfig.ImportFromFile(filePath)){
		Log("Unable to parse Key Values file %s", filePath);
		LogError("Unable to parse Key Values file %s", filePath);
		SetFailState("Unable to parse Key Values file %s", filePath);
		return;
	}

	if(!kvConfig.GotoFirstSubKey()){
		Log("Unable to find 'Effects' Section in file %s", filePath);
		LogError("Unable to find 'Effects' Section in file %s", filePath);
		SetFailState("Unable to find 'Effects' Section in file %s", filePath);
		return;
	}

	int  Chaos_Properties[2];
	do{
		char Chaos_Function_Name[64];
		char Chaos_Function_Title[64];
		char Chaos_Function_v_Title[200];
		char chaos_translation_key[64];
		if (kvConfig.GetSectionName(Chaos_Function_Name, sizeof(Chaos_Function_Name))){
			int enabled = kvConfig.GetNum("enabled", 1);
			int expires = kvConfig.GetNum("duration", 15);
			
			Format(chaos_translation_key, sizeof(chaos_translation_key), "%s_Title", Chaos_Function_Name);
			Format(Chaos_Function_Title, sizeof(Chaos_Function_Title), "%t", chaos_translation_key, LANG_SERVER);
			// kvConfig.GetString("name", Chaos_Function_Title, sizeof(Chaos_Function_Title), Chaos_Function_Name);

			if(enabled != 0 || enabled != 1) enabled = 1;
			//todo better error logging eg. if enabled or duration out of bounds

			Format(chaos_translation_key, sizeof(chaos_translation_key), "%s_START", Chaos_Function_Name);
			Function func = GetFunctionByName(GetMyHandle(), chaos_translation_key);
			if(func != INVALID_FUNCTION){
				//todo strip ** from both titles and functions??
				Format(Chaos_Function_v_Title, sizeof(Chaos_Function_v_Title), "%s**%s**%i", GetChaosTitle(Chaos_Function_Name), Chaos_Function_Name, expires);
				PushArrayString(Effects_Functions_Titles, Chaos_Function_v_Title);
				Chaos_Properties[CONFIG_ENABLED] = enabled;
				Chaos_Properties[CONFIG_EXPIRE] = expires;
				Chaos_Effects.SetArray(Chaos_Function_Name, Chaos_Properties, 2);
			}else{
				Log("Could not find start function for: %s. This effect will not run.", Chaos_Function_Name);
			}
			// PrintToChatAll("test");

		}
	} while(kvConfig.GotoNextKey());

	SortADTArray(Effects_Functions_Titles, Sort_Ascending, Sort_String);

	char title_function[3][64];
	char temp_string[200];
	effect new_chaos_effect;

	for(int i = 0; i < GetArraySize(Effects_Functions_Titles); i++){
		GetArrayString(Effects_Functions_Titles, i, temp_string, sizeof(temp_string));
		ExplodeString(temp_string, "**", title_function, sizeof(title_function), sizeof(title_function[]));
		// PushArrayString(Effect_Titles, title_function[0]);
		// PushArrayString(Effect_Functions, title_function[1]);
		global_id_count++;
		char function_name[64];
		Format(function_name, sizeof(function_name), "%s_START", title_function[1]);
		new_chaos_effect.function_name_start = function_name;
		Format(function_name, sizeof(function_name), "%s_RESET", title_function[1]);
		new_chaos_effect.function_name_reset = function_name;
		new_chaos_effect.title = title_function[0];
		new_chaos_effect.config_name = title_function[1];
		new_chaos_effect.duration = StringToInt(title_function[2]);
		new_chaos_effect.id = global_id_count;
		alleffects.PushArray(new_chaos_effect, sizeof(new_chaos_effect));

		// Log("Adding: %s", new_chaos_effect.title);
		//todo: check if _HasNoDuration exists
	}


	// for(int i = 0; i < alleffects.Length; i++){
	// 	alleffects.GetArray(i, new_chaos_effect, sizeof(new_chaos_effect));

	// 	Format(temp_string, sizeof(temp_string), "%s_ADDEFFECT", new_chaos_effect.config_name);
	// 	Function func = GetFunctionByName(GetMyHandle(), temp_string);

	// 	if(func != INVALID_FUNCTION){
	// 		Call_StartFunction(GetMyHandle(), func);
	// 		Call_Finish();
	// 	}else{
	// 		Log("Error finding effect function for %s", temp_string);
	// 	}
	// 	// new_chaos_effect.run_effect();
		
	// }

	Log("Parsed Chaos_Effects.cfg succesfully!");
}


void ParseOverrideEffects(){
	char filePath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, filePath, sizeof(filePath), "configs/Chaos/Chaos_Override.cfg");

	if(!FileExists(filePath)) return;

	KeyValues kvConfig = new KeyValues("Effects");
	
	if(!kvConfig.ImportFromFile(filePath)){
		Log("Unable to parse Key Values file %s", filePath);
		return;
	}

	if(!kvConfig.GotoFirstSubKey()){
		Log("Unable to find 'Effects' Section in file %s", filePath);
		return;
	}

	int  Chaos_Properties[2];
	char Chaos_Function_Name[64];
	do{
		if (kvConfig.GetSectionName(Chaos_Function_Name, sizeof(Chaos_Function_Name))){
			int enabled = kvConfig.GetNum("enabled", 1);
			int expires = kvConfig.GetNum("duration", 15);
			if(enabled != 0 && enabled != 1) enabled = 1;

			Chaos_Properties[CONFIG_ENABLED] = enabled;
			Chaos_Properties[CONFIG_EXPIRE] = expires;

			Chaos_Effects.SetArray(Chaos_Function_Name, Chaos_Properties, 2);
			
		}
	} while(kvConfig.GotoNextKey());
	Log("Parsed Chaos_Override.cfg successfully!");
}

void COORD_INIT() {g_UnusedCoordinates = CreateArray(3); }

void ParseMapCoordinates(char[] config) {
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/%s.cfg", config);

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

/*
	ParseCore() is used to figure out the value of 'SlowScriptTimeout' found in addons/sourcemod/configs/core.cfg
	Chaos_FakeCrash relies on SourceMod disabling the script when it times out (infinite loop) for 8 seconds.

	In the rare case SlowScriptTimeout is disabled (value of 0) or 10+ seconds, we check that to prevent Chaos_Fakecrash from running
 */

// int g_SlowScriptTimeout = -1;
// void ParseCore(){
// 	char path[PLATFORM_MAX_PATH];
// 	BuildPath(Path_SM, path, sizeof(path), "configs/core.cfg");
	
// 	if(!FileExists(path)) return;

// 	File file = OpenFile(path, "r"); 
// 	if (file == null) return;

// 	char line[256];

// 	while (file.ReadLine(line, sizeof(line))) {
// 		if (strlen(line) > 0 && line[strlen(line) - 1] == '\n') {
// 			line[strlen(line) - 1] = '\0';
// 		}
// 		TrimString(line); 
// 		if(StrContains(line, "\"SlowScriptTimeout\"", false) != -1){
// 			int len = strlen(line);
// 			g_SlowScriptTimeout = StringToInt(line[len-2]);
// 			//check if its a two digit number eg. 10+
// 			int doubleDigit = StringToInt(line[len-3]);
// 			if(doubleDigit != 0){
// 				doubleDigit = doubleDigit * 10;
// 				g_SlowScriptTimeout = doubleDigit + g_SlowScriptTimeout;
// 			}
// 		}
// 	}

// 	delete file;
// 	file.Close();

// 	Log("[DEBUG] SlowScriptTimeout is set to %i", g_SlowScriptTimeout);

// 	if(g_SlowScriptTimeout == -1){
// 		Log("Error parsing configs/core.cfg, could not read 'SlowScriptTimeout' Value. Chaos_FakeCrash will be disabled.");
// 	}else if(g_SlowScriptTimeout == 0){
// 		Log("Chaos_FakeCrash will be disabled due to configs/core.cfg value 'SlowScriptTimeout' set to 0.");
// 	}else if(g_SlowScriptTimeout > 8){
// 		Log("Chaos_FakeCrash will be disabled due to configs/core.cfg value 'SlowScriptTimeout' set higher than 8 seconds.");
// 	}
// }

// int GetSlowScriptTimeout(){
// 	return g_SlowScriptTimeout;
// }

void UpdateConfig(int client = -1, char[] config, char[] KeyValues_name, char[] function_name, char[] key, char[] newValue){
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/%s.cfg", config);

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
			//todo: convar to who this message should be sent to.
			PrintToChatAll("Effect '%s' modified in config. Key '%s' has been set to '%s'", function_name, key, newValue);
			Log("Effect '%s' modified in config. Key '%s' has been set to '%s'", function_name, key, newValue);
		}
		if(StrEqual(KeyValues_name, "Effects", false)){
			ParseChaosEffects();
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
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/Chaos_Statistics.cfg");

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