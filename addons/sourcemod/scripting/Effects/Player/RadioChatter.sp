ArrayList voiceOverList;
bool RadioChatter = false;

public void Chaos_RadioChatter(EffectData effect){
	effect.Title = "Radio Chatter";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_NoComms");
}

public void Chaos_RadioChatter_OnMapStart(){
	voiceOverList = new ArrayList(PLATFORM_MAX_PATH);
	ParseVoiceOvers();
	voiceOverList.Sort(Sort_Random, Sort_String);
}



public void Chaos_RadioChatter_START(){
	RadioChatter = true;
	CreateTimer(0.3, Timer_RadioChatter, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_RadioChatter(Handle timer){
	if(!RadioChatter) return Plugin_Stop;

	int random = GetURandomInt() % voiceOverList.Length;
	char soundPath[PLATFORM_MAX_PATH];
	voiceOverList.GetString(random, soundPath, PLATFORM_MAX_PATH);
	LoopValidPlayers(i){
		ClientCommand(i, "playgamesound %s", soundPath);
	}
	return Plugin_Continue;
}

public void Chaos_RadioChatter_RESET(int ResetType){
	 RadioChatter = false;
}


void ParseVoiceOvers(){
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, PLATFORM_MAX_PATH, "data/Chaos/voiceover.txt");
	
	File vo = OpenFile(path, "r");
	if(vo != INVALID_HANDLE){
		char filePath[PLATFORM_MAX_PATH];
		while(vo.ReadLine(filePath, PLATFORM_MAX_PATH)){
			voiceOverList.PushString(filePath[5]);
		}
	}

	delete vo;
}

public bool Chaos_RadioChatter_Conditions(bool EffectRunRandomly){
	return (voiceOverList.Length > 0);
}