public void Chaos_RandomInvisiblePlayer(effect_data effect){
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
}

public void Chaos_RandomInvisiblePlayer_START(){
	cvar("sv_disable_immunity_alpha", "1");
	Handle players_array = CreateArray(4);
	int playerCount = -1;
	LoopAlivePlayers(i){
		PushArrayCell(players_array, i);
	}
	playerCount = GetArraySize(players_array);
	if(playerCount <= 1) {
		delete players_array;
		return;
	}
	int target_index = GetRandomInt(0, playerCount - 1);
	int target = GetArrayCell(players_array, target_index);

	SetEntityRenderMode(target, RENDER_TRANSCOLOR);
	SetEntityRenderColor(target, 255, 255, 255, 0);

	char chaosMsg[MAX_NAME_LENGTH];
	FormatEx(chaosMsg, 	sizeof(chaosMsg), "%N", target);
	Format(chaosMsg, 	sizeof(chaosMsg), "%s", Truncate(chaosMsg, 10));
	Format(chaosMsg, 	sizeof(chaosMsg), "{orange}%s {default}has been made invisible", chaosMsg);
	AnnounceChaos(chaosMsg, -1.0);
	
	delete players_array;
}

public bool Chaos_RandomInvisiblePlayer_Conditions(){
	Handle players_array = CreateArray(4);
	int playerCount = -1;
	LoopAlivePlayers(i){
		PushArrayCell(players_array, i);
	}
	playerCount = GetArraySize(players_array);
	delete players_array;
	if(playerCount <= 1)  return false;

	return true;
}