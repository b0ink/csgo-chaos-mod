Handle Overlay_Que = INVALID_HANDLE;
void Overlay_INIT(){
	if(Overlay_Que == INVALID_HANDLE){
		Overlay_Que = CreateArray(256);
	}else{
		ClearArray(Overlay_Que);
	}
	HookEvent("player_death", Overlay_Event_PlayerDeath);
}

public Action Overlay_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	if(!g_bChaos_Enabled) return Plugin_Continue;
	int client = GetClientOfUserId(event.GetInt("userid"));

	if(IsValidClient(client)){
		ClientCommand(client, "r_screenoverlay \"\"");
	}
	return Plugin_Continue;
}
void Clear_Overlay_Que(){
	if(Overlay_Que != INVALID_HANDLE){
		ClearArray(Overlay_Que);
	}else{
		Overlay_Que = CreateArray(256);
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

	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"%s\"", path);
	}
}
