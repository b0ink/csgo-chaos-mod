char chickenModel[] = "models/chicken/chicken.mdl";
char playersModels[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

public void Chaos_ChickenPlayers(effect_data effect){
	effect.Title = "Make all players a chicken";
	effect.Duration = 30;
}

public void Chaos_ChickenPlayers_START(){
	LoopAlivePlayers(i){
		SetChicken(i);
	}
}

public Action Chaos_ChickenPlayers_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			DisableChicken(i);
		}
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