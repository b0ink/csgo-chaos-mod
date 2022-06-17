/*
	Effect by Ozai
*/

public void Chaos_Thunderstorm_OnMapStart(){
	PrintToChatAll("asdf");
	AddFileToDownloadsTable("/materials/Chaos/ColorCorrection/thunderstorm.raw");
}


bool Thunderstorm = false;
public void Chaos_Thunderstorm_START(){
	Thunderstorm = true;
	CreateTimer(0.1, Timer_LightningStrike); // starting lightning strikes
	
	SPAWN_WEATHER(RAIN);
	CREATE_CC("thunderstorm");
	DispatchKeyValue(0, "skyname", "sky_csgo_cloudy01"); // changing the skybot to rain (unrelated to rain entity)
}

public Action Chaos_Thunderstorm_RESET(bool EndChaos){
	CLEAR_CC("thunderstorm.raw");
	
	Thunderstorm = false;
	int iMaxEnts = GetMaxEntities(); // clearing rain
	char sClassName[64];
	for(int i=MaxClients;i<iMaxEnts;i++){
		if(IsValidEntity(i) && 
		IsValidEdict(i) && 
		GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
		StrEqual(sClassName, "func_precipitation")){
			RemoveEntity(i);
		}
	}
}


public bool Chaos_Thunderstorm_HasNoDuration(){
	return false;
}

public bool Chaos_Thunderstorm_Conditions(){
	return true;
}

public Action Timer_LightningStrike(Handle timer) {
	if (!Thunderstorm) {
		return;
	}
	
	CreateTimer(0.1, Timer_LightningStrike);

	float endpos[3];
	GetArrayArray(g_MapCoordinates, GetRandomInt(0, GetArraySize(g_MapCoordinates) - 1), endpos);

	endpos[0]    = endpos[0] + GetRandomInt(-30, 30);
	endpos[1]    = endpos[1] + GetRandomInt(-30, 30);

	float startpos[3];
	startpos = endpos;

	startpos[2]    = startpos[2] + 1000;
	startpos[0]    = startpos[0] + GetRandomInt(-200, 200);
	startpos[1]    = startpos[1] + GetRandomInt(-200, 200);

	int   color[4] = { 255, 255, 255, 255 };

	TE_SetupBeamPoints(startpos, endpos, LIGHTNING_sprite, 0, 0, 0, 1.0 /*beam life*/, 20.0, 10.0, 20, 1.0, color, 0);
	TE_SendToAll();

	if(GetRandomInt(0, 100) <= 50) { // 50/50 chance for slay or superslay boom
		EmitAmbientSound(EXPLOSION_HE, endpos, SOUND_FROM_PLAYER, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.5); // regular slay from os but much more quiet
	} else {
		EmitAmbientSound(SOUND_SUPERSLAY, endpos, SOUND_FROM_PLAYER, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.5); // one singular superslay boom
	}

	float pos[3];
	for(int i = 0; i <= MaxClients; i++){ // dealing damage to player if they are struck
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, pos);
			if (GetVectorDistance(pos, endpos) < 200.0){
				SlapPlayer(i, 30, false);
			}
		}
	}
}
