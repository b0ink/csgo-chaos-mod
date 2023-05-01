#pragma semicolon 1

public void Chaos_RandomInvisiblePlayer(EffectData effect){
	effect.Title = "Random Invisible Player";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_Invis");
	effect.BlockInCoopStrike = true;
}

public void Chaos_RandomInvisiblePlayer_START(){
	cvar("sv_disable_immunity_alpha", "1");
	int target = GetRandomAlivePlayer();
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
	char suffix[64];
	Format(suffix, 64, "%s",  GetChaosTitle("Chaos_RandomInvisiblePlayer_Custom"));
	if(suffix[0] == '\0'){
		Format(suffix, 64, "has been made invisible");
	}
	Format(chaosMsg, 	sizeof(chaosMsg), "{orange}%s {default}%s", chaosMsg, suffix);
	
	AnnounceChaos(chaosMsg, -1.0);
}

public void Chaos_RandomInvisiblePlayer_RESET(int ResetType){
	LoopValidPlayers(i){
		SetEntityRenderMode(i, RENDER_NORMAL);
		SetEntityRenderColor(i, 255, 255, 255, 255);
	}
}

public bool Chaos_RandomInvisiblePlayer_Conditions(bool EffectRunRandomly){
	if(GetAliveTCount() + GetAliveCTCount() <= 1)  return false;
	return true;
}