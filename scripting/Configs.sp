#define CONFIG_ENABLED 0
#define CONFIG_EXPIRE 1

Handle Effect_Functions = INVALID_HANDLE;
Handle Effect_Titles = INVALID_HANDLE;
Handle Effects_Functions_Titles = INVALID_HANDLE;

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
	
	ParseMapCoordinates();
	ParseChaosEffects();
	ParseOverrideEffects();
	ParseCore();
}

public void PrecacheTextures(){
	PrecacheModel("models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl", true);
}


void ParseChaosEffects(){
	Chaos_Effects.Clear();
	ClearArray(Effect_Functions);
	ClearArray(Effect_Titles);
	ClearArray(Effects_Functions_Titles);
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
		char Chaos_Function_Title[128];
		char Chaos_Function_v_Title[200];
		if (kvConfig.GetSectionName(Chaos_Function_Name, sizeof(Chaos_Function_Name))){
			int enabled = kvConfig.GetNum("enabled", 1);
			int expires = kvConfig.GetNum("duration", 15);
			kvConfig.GetString("name", Chaos_Function_Title, sizeof(Chaos_Function_Title), Chaos_Function_Name);
			if(enabled != 0 && enabled != 1) enabled = 1;
			//todo better error logging eg. if enabled or duration out of bounds

			//todo strip ** from both titles and functions??
			Format(Chaos_Function_v_Title, sizeof(Chaos_Function_v_Title), "%s**%s", Chaos_Function_Title, Chaos_Function_Name);
			PushArrayString(Effects_Functions_Titles, Chaos_Function_v_Title);
			Chaos_Properties[CONFIG_ENABLED] = enabled;
			Chaos_Properties[CONFIG_EXPIRE] = expires;
			Chaos_Effects.SetArray(Chaos_Function_Name, Chaos_Properties, 2);

		}
	} while(kvConfig.GotoNextKey());

	SortADTArray(Effects_Functions_Titles, Sort_Ascending, Sort_String);

	char title_function[2][128];
	char temp_string[200];
	for(int i = 0; i < GetArraySize(Effects_Functions_Titles); i++){
		GetArrayString(Effects_Functions_Titles, i, temp_string, sizeof(temp_string));
		ExplodeString(temp_string, "**", title_function, sizeof(title_function), sizeof(title_function[]));
		PushArrayString(Effect_Titles, title_function[0]);
		PushArrayString(Effect_Functions, title_function[1]);
	}

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
	do{
		char Chaos_Function_Name[64];
		
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


void ParseMapCoordinates() {
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/Chaos_Locations.cfg");
	if(!FileExists(path)){
		Log("Could not find %s. Effects that rely on map data will no run.", path);
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
	g_MapCoordinates = CreateArray(3);
	bombSiteA = CreateArray(3);
	bombSiteB = CreateArray(3);
	//all keys are fine to go in the all map coordinates, but we ALSO want to add bombA and bombB to respective handles; 
	do{
		float vec[3];
		kv.GetVector(NULL_STRING, vec);
		char key[25];
		kv.GetSectionName(key, sizeof(key));
		if(strcmp(key, "bombA", false) == 0) PushArrayArray(bombSiteA, vec);
		if(strcmp(key, "bombB", false) == 0) PushArrayArray(bombSiteB, vec);
		PushArrayArray(g_MapCoordinates, vec);
	} while(kv.GotoNextKey(false));

	delete kv;
}

/*
	ParseCore() is used to figure out the value of 'SlowScriptTimeout' found in addons/sourcemod/configs/core.cfg
	Chaos_FakeCrash relies on SourceMod disabling the script when it times out (infinite loop) for 8 seconds.

	In the rare case SlowScriptTimeout is disabled (value of 0) or 10+ seconds, we check that to prevent Chaos_Fakecrash from running
 */

int g_SlowScriptTimeout = -1;
void ParseCore(){
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/core.cfg");
	
	if(!FileExists(path)) return;

	File file = OpenFile(path, "r"); 
	if (file == null) return;

	char line[256];

	while (file.ReadLine(line, sizeof(line))) {
		if (strlen(line) > 0 && line[strlen(line) - 1] == '\n') {
			line[strlen(line) - 1] = '\0';
		}
		TrimString(line); 
		if(StrContains(line, "\"SlowScriptTimeout\"", false) != -1){
			int len = strlen(line);
			g_SlowScriptTimeout = StringToInt(line[len-2]);
			//check if its a two digit number eg. 10+
			int doubleDigit = StringToInt(line[len-3]);
			if(doubleDigit != 0){
				doubleDigit = doubleDigit * 10;
				g_SlowScriptTimeout = doubleDigit + g_SlowScriptTimeout;
			}
		}
	}

	delete file;
	file.Close();

	Log("[DEBUG] SlowScriptTimeout is set to %i", g_SlowScriptTimeout);

	if(g_SlowScriptTimeout == -1){
		Log("Error parsing configs/core.cfg, could not read 'SlowScriptTimeout' Value. Chaos_FakeCrash will be disabled.");
	}else if(g_SlowScriptTimeout == 0){
		Log("Chaos_FakeCrash will be disabled due to configs/core.cfg value 'SlowScriptTimeout' set to 0.");
	}else if(g_SlowScriptTimeout > 8){
		Log("Chaos_FakeCrash will be disabled due to configs/core.cfg value 'SlowScriptTimeout' set higher than 8 seconds.");
	}
}

int GetSlowScriptTimeout(){
	return g_SlowScriptTimeout;
}

void UpdateConfig_UpdateEffect(int client = -1, char[] function_name, char[] key, char[] newValue){
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/Chaos_Override.cfg");

	KeyValues kvConfig = new KeyValues("Effects");

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
		ParseChaosEffects();
		ParseOverrideEffects();
	}else{
		if(IsValidClient(client)){
			PrintToChat(client, "[Chaos] Failed to update config.");
		}
	}
	delete 	kvConfig;
}