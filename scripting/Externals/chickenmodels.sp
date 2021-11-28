char chickenModel[] = "models/chicken/chicken.mdl";
char playersModels[MAXPLAYERS + 1][PLATFORM_MAX_PATH];



void SetChicken(int client_index)
{
	// isChicken[client_index] = true;
	//Delete fake model to prevent glitches
	// DisableFakeModel(client_index);
	
	// Get player model to revert it on chicken disable
	char modelName[PLATFORM_MAX_PATH];
	GetEntPropString(client_index, Prop_Data, "m_ModelName", modelName, sizeof(modelName));
	playersModels[client_index] = modelName;
	
	//Only for hitbox -> Collision hull still the same
	SetEntityModel(client_index, chickenModel);
	//Little chicken is weak
	// SetEntityHealth(client_index, chickenHealth);
	//Hide the real player model (because animations won't play)
	//SDKHook(client_index, SDKHook_SetTransmit, Hook_SetTransmit); //Crash server
			// SetEntityRenderMode(client_index, RENDER_NONE); //Make sure immunity alpha is set to 0 or it won't work
	//Create a fake chicken model with animation
	// CreateFakeModel(client_index);
}

void DisableChicken(int client){
	PrintToChatAll("THE PLAYER MODEL NAME IS: %s", playersModels[client]);
	if(playersModels[client][0]){
		if(ValidAndAlive(client)){
			SetEntityModel(client, playersModels[client]);
		}
	}

}