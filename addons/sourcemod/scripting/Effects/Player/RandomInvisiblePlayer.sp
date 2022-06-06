public void Chaos_RandomInvisiblePlayer_START(){
	Handle players_array = CreateArray(4);
	int playerCount = -1;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)) PushArrayCell(players_array, i);
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
	Format(chaosMsg, 	sizeof(chaosMsg), "%s...", Truncate(chaosMsg, 10));
	Format(chaosMsg, 	sizeof(chaosMsg), "{orange}%s {default}has been made invisible", chaosMsg);
	AnnounceChaos(chaosMsg, -1.0);
	
	delete players_array;
}

public Action Chaos_RandomInvisiblePlayer_RESET(bool EndChaos){

}

public bool Chaos_RandomInvisiblePlayer_HasNoDuration(){
	return false;
}

public bool Chaos_RandomInvisiblePlayer_CustomAnnouncement(){
	return true;
}

public bool Chaos_RandomInvisiblePlayer_Conditions(){
	return true;
}