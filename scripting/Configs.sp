#define CONFIG_ENABLED 0
#define CONFIG_EXPIRE 1


public void OnConfigsExecuted(){
	ParseMapCoordinates();
	ParseChaosEffects();
}

public void PrecacheTextures(){
	PrecacheModel("models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl", true);
}


void ParseChaosEffects(){
	Chaos_Effects.Clear();
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
		if (kvConfig.GetSectionName(Chaos_Function_Name, sizeof(Chaos_Function_Name))){
			int enabled = kvConfig.GetNum("enabled", 1);
			int expires = kvConfig.GetNum("duration", 15);
			if(enabled != 0 && enabled != 1) enabled = 1;
			
			Chaos_Properties[CONFIG_ENABLED] = enabled;
			Chaos_Properties[CONFIG_EXPIRE] = expires;
			Chaos_Effects.SetArray(Chaos_Function_Name, Chaos_Properties, 2);
			// PrintToChatAll("%s: on: %i, dur: %i", Chaos_Function_Name, enabled, expires);
		}
	} while(kvConfig.GotoNextKey());

	Log("Parsed Chaos_Effects.cfg succesfully!");
}

//config
void ParseMapCoordinates() {
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/Chaos_Locations.cfg");
	// if(!FileExists(path)) SetFailState("Config file %s is not found", path);
	if(!FileExists(path)) return;
	
	char MapName[128];
	GetCurrentMap(MapName, sizeof(MapName));

	KeyValues kv = new KeyValues("Maps");

	if(!kv.ImportFromFile(path)){
		Log("Unable to parse Key Values from %s", path);
		// SetFailState("Unable to parse Key Values from %s", path);
		return;
	}
	//jump to key of map name
	if(!kv.JumpToKey(MapName)){
		Log("Unable to find %s Key from %s", MapName, path);
		// SetFailState("Unable to find %s Key from %s", MapName, path);
		return;
	}

	if(!kv.GotoFirstSubKey(false)){
		Log("Unable to find sub keys %s", path);
		// SetFailState("Unable to find sub keys %s", path);
		return;
	}
	g_MapCoordinates = CreateArray(3);
	bombSiteA = CreateArray(3);
	bombSiteB = CreateArray(3);
	//all keys are fine to go in the all map coordinates, but we ALSO want to add bombA and bombB to respective handles; 
	do{
		float vec[3];
		kv.GetVector(NULL_STRING, vec);
		// PrintToChatAll("FLOAT: %f %f %f", vec[0], vec[1], vec[2]);
		char key[25];
		kv.GetSectionName(key, sizeof(key));
		// PrintToChatAll("Key name: %s", key);
		if(strcmp(key, "bombA", false) == 0) PushArrayArray(bombSiteA, vec);
		if(strcmp(key, "bombB", false) == 0) PushArrayArray(bombSiteB, vec);
		PushArrayArray(g_MapCoordinates, vec);
	} while(kv.GotoNextKey(false));

	delete kv;
}



