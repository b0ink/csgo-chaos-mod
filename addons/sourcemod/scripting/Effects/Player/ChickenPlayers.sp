char chickenModel[] = "models/chicken/chicken.mdl";
char playersModels[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

public void Chaos_ChickenPlayers_START(){
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetChicken(i);
}

public Action Chaos_ChickenPlayers_RESET(bool EndChaos){
	if(EndChaos){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) DisableChicken(i);
	}
}

public bool Chaos_ChickenPlayers_HasNoDuration(){
	return false;
}

public bool Chaos_ChickenPlayers_Conditions(){
	return true;
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
	if(playersModels[client][0]){
		if(ValidAndAlive(client)){
			SetEntityModel(client, playersModels[client]);
		}
	}
}