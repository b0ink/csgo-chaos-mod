#pragma semicolon 1

/*
	Effect by Ozai
*/

bool Thunderstorm = false;
int thunder_count = 0;

ArrayList ThunderstormEnts;

public void Chaos_Thunderstorm(EffectData effect){
	effect.Title = "Thunderstorm";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_DecoyDodgeball");
	effect.IncompatibleWith("Chaos_OHKO");
	effect.AddAlias("Weather");
	effect.AddAlias("Visual");

	ThunderstormEnts = new ArrayList();
}


char ThunderstormExplosionSFX[] = "weapons/hegrenade/explode5.wav";

public void Chaos_Thunderstorm_OnMapStart(){
	AddFileToDownloadsTable("materials/ChaosMod/ColorCorrection/thunderstorm.raw");
	PrecacheSound(ThunderstormExplosionSFX);
}


public void Chaos_Thunderstorm_START(){
	thunder_count = 0;

	Thunderstorm = true;
	CreateTimer(0.1, Timer_LightningStrike); // starting lightning strikes
	
	int ent = SPAWN_WEATHER(RAIN, "Thunderstorm");
	ThunderstormEnts.Push(EntIndexToEntRef(ent));

	CREATE_CC("thunderstorm");
	DispatchKeyValue(0, "skyname", "sky_csgo_cloudy01"); // changing the skybot to rain (unrelated to rain entity)
	MinimalFog();
	
	int randomDistant = GetRandomInt(1, 3);

	LoopValidPlayers(i){
		if(randomDistant == 1){
			ClientCommand(i, "playgamesound \"%s\"", THUNDERDISTANT_1);
		}else if(randomDistant == 2){
			ClientCommand(i, "playgamesound \"%s\"", THUNDERDISTANT_2);
		}else if(randomDistant == 3){
			ClientCommand(i, "playgamesound \"%s\"", THUNDERDISTANT_3);
		}
	}
}

public void Chaos_Thunderstorm_RESET(int ResetType){
	Thunderstorm = false;
	CLEAR_CC("thunderstorm.raw");
	RemoveEntitiesInArray(ThunderstormEnts);
	MinimalFog(true);
}

/* Used in Chaos_Armageddon() */
void EnableThunderstorm(){
	Thunderstorm = true;
}

void DisableThunderstorm(){
	Thunderstorm = false;
}

Action Timer_LightningStrike(Handle timer) {
	if (!Thunderstorm) {
		return Plugin_Stop;
	}
	

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
		EmitAmbientSound(ThunderstormExplosionSFX, endpos, SOUND_FROM_PLAYER, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.25); // regular slay from os but much more quiet
	} else {
		EmitAmbientSound(SOUND_SUPERSLAY, endpos, SOUND_FROM_PLAYER, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.25); // one singular superslay boom
	}

	float pos[3];
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, pos);
		if (GetVectorDistance(pos, endpos) < 200.0){ // dealing damage to player if they are struck
			int health = GetClientHealth(i);
			if(health > 25){
				SlapPlayer(i, 10, false);
			}else{
				SlapPlayer(i, 2, false);
			}
		}
	}

	thunder_count++;
	if(thunder_count % 50 == 0){
		int randomThunder = GetRandomInt(1, 3);
		LoopValidPlayers(i){
			if(randomThunder == 1){
				ClientCommand(i, "playgamesound \"%s\"", THUNDER_1);
			}else if(randomThunder == 2){
				ClientCommand(i, "playgamesound \"%s\"", THUNDER_2);
			}else if(randomThunder == 3){
				ClientCommand(i, "playgamesound \"%s\"", THUNDER_3);
			}
		}
	}

	CreateTimer(0.1, Timer_LightningStrike);
	return Plugin_Continue;
}


public bool Chaos_Thunderstorm_Conditions(bool EffectRunRandomly){
	if(!ValidMapPoints()) return false;
	return true;
}