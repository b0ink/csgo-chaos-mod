#pragma semicolon 1

public void Chaos_LSD(effect_data effect){
	effect.Title = "LSD";
	effect.Duration = 30;
	effect.AddFlag("colorcorrection");
	effect.AddAlias("Visual");
}

bool lsdMaterials = true;

public void Chaos_LSD_OnMapStart(){
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/env_1.raw");
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/env_2.raw");
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/env_3.raw");
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/env_4.raw");
	AddFileToDownloadsTable("materials/Chaos/ColorCorrection/env_5.raw");

	if(!FileExists("materials/Chaos/ColorCorrection/env_1.raw")) lsdMaterials = false;
	if(!FileExists("materials/Chaos/ColorCorrection/env_2.raw")) lsdMaterials = false;
	if(!FileExists("materials/Chaos/ColorCorrection/env_3.raw")) lsdMaterials = false;
	if(!FileExists("materials/Chaos/ColorCorrection/env_4.raw")) lsdMaterials = false;
	if(!FileExists("materials/Chaos/ColorCorrection/env_5.raw")) lsdMaterials = false;

}

Handle g_LSD_Timer_Repeat = INVALID_HANDLE;
bool g_LSD = false;
int g_Previous_LSD = -1;

public void Chaos_LSD_START(){
	g_LSD = true;
	g_Previous_LSD = 1;
	CREATE_CC("env_1");

	g_LSD_Timer_Repeat = CreateTimer(5.0, Timer_SpawnNewLSD);
}

public void Chaos_LSD_RESET(bool HasTimerEnded){
		StopTimer(g_LSD_Timer_Repeat);
		CLEAR_CC("env_1.raw");
		CLEAR_CC("env_2.raw");
		CLEAR_CC("env_3.raw");
		CLEAR_CC("env_4.raw");
		CLEAR_CC("env_5.raw");
		g_LSD = false;
		g_Previous_LSD = -1;
}

public Action Timer_SpawnNewLSD(Handle Timer){
	g_LSD_Timer_Repeat = INVALID_HANDLE;

	CLEAR_CC("env_1.raw");
	CLEAR_CC("env_2.raw");
	CLEAR_CC("env_3.raw");
	CLEAR_CC("env_4.raw");
	CLEAR_CC("env_5.raw");
	
	if(g_LSD){
		int test = g_Previous_LSD;
		while(test == g_Previous_LSD) test = GetRandomInt(1,5);

		if(test == 1) CREATE_CC("env_1");
		if(test == 2) CREATE_CC("env_2");
		if(test == 3) CREATE_CC("env_3");
		if(test == 4) CREATE_CC("env_4");
		if(test == 5) CREATE_CC("env_5");
		g_LSD_Timer_Repeat = CreateTimer(5.0, Timer_SpawnNewLSD);
	}
	return Plugin_Continue;
}

public bool Chaos_LSD_Conditions(){
	return lsdMaterials;
}