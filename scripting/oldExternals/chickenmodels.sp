char chickenModel[] = "models/chicken/chicken.mdl";
char playersModels[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

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