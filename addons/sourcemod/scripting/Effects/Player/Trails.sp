#pragma semicolon 1

int trailSprite = -1;
float TrailsLastLoc[MAXPLAYERS+1][3];
bool Trails = false;

public void Chaos_Trails(EffectData effect){
	effect.Title = "Trails";
	effect.Duration = 30;
}

public void Chaos_Trails_OnMapStart(){
	trailSprite = PrecacheModel("materials/sprites/laser.vmt", true);
	AddFileToDownloadsTable("materials/sprites/laser.vmt");
	AddFileToDownloadsTable("materials/sprites/laser.vtf");
}

public void Chaos_Trails_START(){
	Trails = true;
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, TrailsLastLoc[i]);
		TrailsLastLoc[i][2] += 32.0;
	}

	CreateTimer(0.1, Timer_CreateTrail, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}


public void Chaos_Trails_RESET(int ResetType){
	Trails = false;
}


Action Timer_CreateTrail(Handle timer){
	if(!Trails) return Plugin_Stop;

	int color[4];
	float currentLoc[3];

	LoopAlivePlayers(i){
		if(GetClientTeam(i) == CS_TEAM_T){
			color = {255, 0, 0, 255};
		}else{
			color = {0, 0, 255, 255};
		}
		
		GetClientAbsOrigin(i, currentLoc);
		currentLoc[2] += 32.0;
		LoopValidPlayers(g){
			TE_SetupBeamPoints(TrailsLastLoc[i], currentLoc, trailSprite, 0, 0, 0, 10.0, 8.0, 8.0, 1, 0.0, color, 15);
			TE_SendToClient(g);
		}
		TrailsLastLoc[i] = currentLoc;
	}
	
	return Plugin_Continue;
}