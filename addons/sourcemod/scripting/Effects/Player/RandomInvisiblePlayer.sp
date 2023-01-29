#pragma semicolon 1

public void Chaos_RandomInvisiblePlayer(effect_data effect){
	effect.Title = "Random Invisible Player";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_Invis");
}

public void Chaos_RandomInvisiblePlayer_START(){
	cvar("sv_disable_immunity_alpha", "1");
	int target = getRandomAlivePlayer();
	if(target == -1) return;

	LoopValidPlayers(i){
		SetEntityRenderMode(i, RENDER_NORMAL);
		SetEntityRenderColor(i, 255, 255, 255, 255);
	}

	SetEntityRenderMode(target, RENDER_NONE);
	SetEntityRenderColor(target, 255, 255, 255, 0);

	char chaosMsg[MAX_NAME_LENGTH];
	FormatEx(chaosMsg, 	sizeof(chaosMsg), "%N", target);
	Format(chaosMsg, 	sizeof(chaosMsg), "%s", Truncate(chaosMsg, 10));
	Format(chaosMsg, 	sizeof(chaosMsg), "{orange}%s {default}has been made invisible", chaosMsg);
	AnnounceChaos(chaosMsg, -1.0);
}

public void Chaos_RandomInvisiblePlayer_RESET(bool HasTimerEnded){
	LoopValidPlayers(i){
		SetEntityRenderMode(i, RENDER_NORMAL);
		SetEntityRenderColor(i, 255, 255, 255, 255);
	}
}

public bool Chaos_RandomInvisiblePlayer_Conditions(){
	if(GetAliveTCount() + GetAliveCTCount() <= 1)  return false;
	return true;
}