// char OriginalPlayerModels[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

Handle OriginalPlayerModels = INVALID_HANDLE;

void SpawnImpostors(){
	OriginalPlayerModels = CreateArray(PLATFORM_MAX_PATH);
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			char modelName[PLATFORM_MAX_PATH];
			GetEntPropString(i, Prop_Data, "m_ModelName", modelName, sizeof(modelName));
			PushArrayString(OriginalPlayerModels, modelName);
			// OriginalPlayerModels[i] = modelName;
		}
	}

		//todo: chickens get stuck, saw a video somewhere that its possible for them to move around like normal
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int chance = GetRandomInt(0,100);
		if(chance <= 25){
			int chicken = CreateEntityByName("chicken");
			int fakePlayer = CreateEntityByName("chicken");
			if(chicken != -1 && fakePlayer != -1){
				float vec[3];
				GetArrayArray(g_MapCoordinates, i, vec);
				// vec[2] = vec[2] + 25.0;
				TeleportEntity(chicken, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(chicken);

				SetEntityRenderMode(chicken , RENDER_NONE);
				SetEntityRenderColor(chicken, 255, 255, 255, 0);
				// SetEntProp(ent, Prop_Send, "m_fEffects", 0);
				// SetEntProp(ent, Prop_Data, "m_flGroundSpeed", 1);
				// CreateTimer(0.1, Timer_SetChickenModel, ent);

				char ImpostorModel[PLATFORM_MAX_PATH];
				int randomSkin = GetRandomInt(0, GetArraySize(OriginalPlayerModels) - 1);
				GetArrayString(OriginalPlayerModels, randomSkin, ImpostorModel, sizeof(ImpostorModel));

				vec[2] = vec[2] - 2.0;

				TeleportEntity(fakePlayer, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(fakePlayer);

				SetVariantString("!activator");
				AcceptEntityInput(fakePlayer, "SetParent", chicken, fakePlayer, 0);
				AcceptEntityInput(fakePlayer, "SetParentAttachmentMaintainOffset", fakePlayer, fakePlayer, 0);    


				SetEntityMoveType(fakePlayer, MOVETYPE_NOCLIP);   


				SetEntityModel(fakePlayer, ImpostorModel);
				// SetEntPropFloat(ent, Prop_Send, "m_flSpeed", 2.0);
				// SetVariantString("!activator");
			}
		}
	}

	delete OriginalPlayerModels;
}
