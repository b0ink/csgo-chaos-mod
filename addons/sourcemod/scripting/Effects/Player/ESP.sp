#pragma semicolon 1

#define EF_BONEMERGE (1 << 0)
#define EF_NOSHADOW (1 << 4)
#define EF_NORECEIVESHADOW (1 << 6)

int ESPColors[2][4] = {
  {144, 120, 72}, // T
  {72, 96, 144},  // CT
};

bool WallHacks = false;

int	 playerModels[MAXPLAYERS + 1] = {INVALID_ENT_REFERENCE, ...};
int	 playerModelsIndex[MAXPLAYERS + 1] = {-1, ...};

public void Chaos_ESP(EffectData effect) {
	effect.Title = "Wall Hacks";
	effect.Duration = 30;

	effect.AddAlias("Wallhacks");
	effect.AddAlias("Xray");
	effect.AddAlias("Cheats");
}

public void Chaos_ESP_START() {
	WallHacks = true;
	cvar("sv_force_transmit_players", "1");
	CreateTimer(1.0, Timer_CheckPlayerModels, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	RefreshGlows();
}

public void Chaos_ESP_RESET(int ResetType) {
	WallHacks = false;
	DestroyAllGlows();
}

public void Chaos_ESP_OnPlayerSpawn(int client) {
	AddGlow(client);
}

void RefreshGlows() {
	DestroyAllGlows();
	LoopAlivePlayers(i) {
		AddGlow(i);
	}
}

void DestroyAllGlows() {
	for(int i = 0; i <= MaxClients; i++) {
		DestroyGlow(i);
	}
}

void DestroyGlow(int client) {
	int skin = EntRefToEntIndex(playerModels[client]);
	if(IsValidEntity(skin) && skin > 0) {
		RemoveEntity(skin);
	}
	playerModels[client] = INVALID_ENT_REFERENCE;
	playerModelsIndex[client] = INVALID_ENT_REFERENCE;
}

void AddGlow(int client) {
	DestroyGlow(client);

	if(!ValidAndAlive(client)) {
		return;
	}

	char model[PLATFORM_MAX_PATH];
	GetClientModel(client, model, sizeof(model));

	int team = GetClientTeam(client);
	if(team <= 1) return;
	int skin = -1;

	// Create Skin
	skin = CreatePlayerModelProp(client, model, "primary", true, 1.0);
	if(IsValidEntity(skin)) {
		if(SDKHookEx(skin, SDKHook_SetTransmit, OnSetTransmit_All)) {
			int offset;
			// Get sendprop offset for prop_dynamic_override
			if(!offset && (offset = GetEntSendPropOffs(skin, "m_clrGlow")) == -1) {
				LogError("Unable to find property offset: \"m_clrGlow\"!");
				return;
			}

			// Enable glow for custom skin
			SetEntProp(skin, Prop_Send, "m_bShouldGlow", true);
			SetEntProp(skin, Prop_Send, "m_nGlowStyle", 0);
			SetEntPropFloat(skin, Prop_Send, "m_flGlowMaxDist", 10000.0);

			// So now setup given glow ESPColors for the skin
			for(int i = 0; i < 3; i++) {
				SetEntData(skin, offset + i, ESPColors[team - 2][i], _, true);
			}
		}
	}
}

public int CreatePlayerModelProp(int client, char[] sModel, char[] attachment, bool bonemerge, float scale) {
	int skin = CreateEntityByName("prop_dynamic_glow");
	DispatchKeyValue(skin, "model", sModel);
	DispatchKeyValue(skin, "solid", "0");
	DispatchKeyValue(skin, "fademindist", "1");
	DispatchKeyValue(skin, "fademaxdist", "1");
	DispatchKeyValue(skin, "fadescale", "2.0");
	SetEntProp(skin, Prop_Send, "m_CollisionGroup", 0);
	DispatchSpawn(skin);
	SetEntityRenderMode(skin, RENDER_GLOW);
	SetEntityRenderColor(skin, 0, 0, 0, 0);
	if(bonemerge) {
		SetEntProp(skin, Prop_Send, "m_fEffects", EF_BONEMERGE);
	}
	if(scale != 1.0) {
		SetEntPropFloat(skin, Prop_Send, "m_flModelScale", scale);
	}
	SetVariantString("!activator");
	AcceptEntityInput(skin, "SetParent", client, skin);
	SetVariantString(attachment);
	AcceptEntityInput(skin, "SetParentAttachment", skin, skin, 0);
	SetVariantString("OnUser1 !self:Kill::0.1:-1");
	AcceptEntityInput(skin, "AddOutput");
	playerModels[client] = EntIndexToEntRef(skin);
	playerModelsIndex[client] = skin;
	return skin;
}

public Action OnSetTransmit_All(int entity, int client) {
	if(playerModelsIndex[client] != entity) {
		return Plugin_Continue;
	}
	return Plugin_Stop;
}

/* If player models change while wallhack effect is active, recreate outlines */
Action Timer_CheckPlayerModels(Handle timer) {
	if(!WallHacks) return Plugin_Stop;
	char modelName[PLATFORM_MAX_PATH];
	LoopAlivePlayers(i) {
		GetEntPropString(i, Prop_Data, "m_ModelName", modelName, PLATFORM_MAX_PATH);
		int skin = EntRefToEntIndex(playerModels[i]);
		if(IsValidEntity(skin)) {
			char EspName[PLATFORM_MAX_PATH];
			GetEntPropString(skin, Prop_Data, "m_ModelName", EspName, PLATFORM_MAX_PATH);
			if(!StrEqual(modelName, EspName, false)) {
				RefreshGlows();
				break;
			}
		}
	}
	return Plugin_Continue;
}