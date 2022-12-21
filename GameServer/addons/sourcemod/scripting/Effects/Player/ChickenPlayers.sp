#define EFFECTNAME ChickenPlayers

char chickenModel[] = "models/chicken/chicken.mdl";
char playersModels[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

SETUP(effect_data effect){
	effect.Title = "Make all players a chicken";
	effect.Duration = 30;
}

START(){
	LoopAlivePlayers(i){
		SetChicken(i);
	}
}

RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			DisableChicken(i);
		}
	}
}

public void Chaos_ChickenPlayers_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		CreateTimer(0.5, Timer_SetChickenModel, client);
	}
}

public Action Timer_SetChickenModel(Handle timer, int client){
	if(IsValidClient(client) && IsPlayerAlive(client)){
		SetChicken(client);
	}
}

void SetChicken(int client){
	// Get player model to revert it on chicken disable
	char modelName[PLATFORM_MAX_PATH];
	GetEntPropString(client, Prop_Data, "m_ModelName", modelName, sizeof(modelName));
	playersModels[client] = modelName;
	
	//Only for hitbox -> Collision hull still the same
	SetEntityModel(client, chickenModel);
	SetEntityHealth(client, 50);
}

void DisableChicken(int client){
	if(playersModels[client][0] != '\0'){
		if(ValidAndAlive(client)){
			SetEntityModel(client, playersModels[client]);
		}
	}
}