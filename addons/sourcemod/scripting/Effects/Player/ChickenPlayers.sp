#pragma semicolon 1

char chickenModel[] = "models/chicken/chicken.mdl";
bool ChickenPlayers = false;

public void Chaos_ChickenPlayers(EffectData effect){
	effect.Title = "Make all players a chicken";
	effect.Duration = 30;
	effect.AddFlag("playermodel");
}

public void Chaos_ChickenPlayers_START(){
	ChickenPlayers = true;
	LoopAlivePlayers(i){
		SetChicken(i);
	}
}

public void Chaos_ChickenPlayers_RESET(int ResetType){
	ChickenPlayers = false;
	if(ResetType & RESET_EXPIRED){
		RestorePlayerModels();
	}
	LoopValidPlayers(i){
		SDKUnhook(i, SDKHook_PostThink, ChickenPlayers_PostThink);
	}
}

public void Chaos_ChickenPlayers_OnPlayerSpawn(int client){
	CreateTimer(0.5, Timer_SetChickenModel, client);
}

Action Timer_SetChickenModel(Handle timer, int client){
	if(IsValidClient(client) && IsPlayerAlive(client)){
		SetChicken(client);
	}
	return Plugin_Continue;
}

void SetChicken(int client){
	//Only for hitbox -> Collision hull still the same

	SetEntityModel(client, chickenModel);
	SetEntityHealth(client, 50);
	
	SDKUnhook(client, SDKHook_PostThink, ChickenPlayers_PostThink);
	SDKHook(client, SDKHook_PostThink, ChickenPlayers_PostThink);
}


public void ChickenPlayers_PostThink(int client){
	if(!ChickenPlayers) return;
	float vec[3];
	vec[0] = 0.0;
	vec[1] = 0.0;
	vec[2] = 20.0;
	SetEntPropVector(client, Prop_Data, "m_vecViewOffset", vec);
}