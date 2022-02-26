Handle OriginalPlayerModels = INVALID_HANDLE;

void SpawnImpostors(){
	OriginalPlayerModels = CreateArray(PLATFORM_MAX_PATH);
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			char modelName[PLATFORM_MAX_PATH];
			GetEntPropString(i, Prop_Data, "m_ModelName", modelName, sizeof(modelName));
			PushArrayString(OriginalPlayerModels, modelName);
		}
	}

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int chance = GetRandomInt(0,100);
		if(chance <= 25){
			int chicken = CreateEntityByName("chicken");
			int fakePlayer = CreateEntityByName("chicken");
			if(chicken != -1 && fakePlayer != -1){
				float vec[3];
				GetArrayArray(g_MapCoordinates, i, vec);

				TeleportEntity(chicken, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(chicken);

				/*
					Thankyou backwards!
					https://discord.com/channels/335290997317697536/335290997317697536/840636933478678538
				*/

				float fChickenRot[3];
				GetEntPropVector(chicken, Prop_Data, "m_angAbsRotation", fChickenRot);

				float fForward[3], fSide[3], fUp[3];
				GetAngleVectors(fChickenRot, fForward, fSide, fUp);

				float fChickenPos[3];
				GetEntPropVector(chicken, Prop_Send, "m_vecOrigin", fChickenPos);

				float fChickenOffset[3];
				for(int g = 0;g<3;g++)
					fChickenOffset[g] = fChickenPos[g] + (fForward[g] * 5.0) + (fUp[g] * 10.0) - 10.0;

				TeleportEntity(fakePlayer, fChickenOffset, fChickenRot, NULL_VECTOR);

				SetVariantString("!activator");     
				AcceptEntityInput(fakePlayer, "SetParent", chicken);

				//Note: Entities must be parented before being sent this input. Use at least a 0.1 second delay between SetParent and SetParentAttachmentMaintainOffset inputs, to ensure they run in the right order.

				AcceptEntityInput(fakePlayer, "SetParentAttachmentMaintainOffset", fakePlayer, fakePlayer, 0);    
				
				char ImpostorModel[PLATFORM_MAX_PATH];
				int randomSkin = GetRandomInt(0, GetArraySize(OriginalPlayerModels) - 1);
				GetArrayString(OriginalPlayerModels, randomSkin, ImpostorModel, sizeof(ImpostorModel));

				SetEntityModel(fakePlayer, ImpostorModel);

				SetEntityRenderMode(chicken, RENDER_NONE);

				//causes those annoying messages when your chicken dies if i set the leader
				// SetEntPropEnt(chicken, Prop_Send, "m_leader", getRandomAlivePlayer());

			}
		}
	}

	delete OriginalPlayerModels;
}