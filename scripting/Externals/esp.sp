int playerModels[MAXPLAYERS+1] = {INVALID_ENT_REFERENCE,...};
int playerModelsIndex[MAXPLAYERS+1] = {-1,...};

#define EF_BONEMERGE                (1 << 0)
#define EF_NOSHADOW                 (1 << 4)
#define EF_NORECEIVESHADOW          (1 << 6)

public void checkGlows(){
	destroyGlows();
	createGlows();
}

int colors[2][4];
public void ESP_INIT(){
	colors[0][0] = 144;
	colors[0][1] = 120;
	colors[0][2] = 72;

	colors[1][0] = 72;
	colors[1][1] = 96;
	colors[1][2] = 144;
}



public void SetupGlow(int entity, int color[4]) {
    int offset;
    // Get sendprop offset for prop_dynamic_override
    if (!offset && (offset = GetEntSendPropOffs(entity, "m_clrGlow")) == -1) {
        LogError("Unable to find property offset: \"m_clrGlow\"!");
        return;
    }

    // Enable glow for custom skin
    SetEntProp(entity, Prop_Send, "m_bShouldGlow", true);
    SetEntProp(entity, Prop_Send, "m_nGlowStyle", 0);
    SetEntPropFloat(entity, Prop_Send, "m_flGlowMaxDist", 10000.0);

    // So now setup given glow colors for the skin
    for(int i=0;i<3;i++) {
        SetEntData(entity, offset + i, color[i], _, true); 
    }
}

public void setGlowTeam(int skin, int team) {
    if(team >= 2) {
        SetupGlow(skin, colors[team-2]);
    }
}

public void RemoveSkin(int client) {
    int index = EntRefToEntIndex(playerModels[client]);
    if(index > MaxClients && IsValidEntity(index)) {
        SetEntProp(index, Prop_Send, "m_bShouldGlow", false);
        AcceptEntityInput(index, "FireUser1");
    }
    playerModels[client] = INVALID_ENT_REFERENCE;
    playerModelsIndex[client] = -1;
}
public void destroyGlows() {
    for(int client = 1; client <= MaxClients; client++) {
        if(IsClientInGame(client)) {
            if(ValidAndAlive(client)){
                RemoveSkin(client);
            }
        }
    }
}


public void createGlows() {
	char model[PLATFORM_MAX_PATH];
	char attachment[PLATFORM_MAX_PATH];
	int skin = -1;
	//Loop and setup a glow on alive players.
	attachment = "primary";
	for(int client = 1; client <= MaxClients; client++) {
        if(!IsClientInGame(client) || !IsPlayerAlive(client)) continue;
        int team = GetClientTeam(client);
        if(team <= 1) continue;
        //Create Skin
        GetClientModel(client, model, sizeof(model));
        skin = CreatePlayerModelProp(client, model, attachment, true, 1.0);
        if(skin > MaxClients) {
			if(SDKHookEx(skin, SDKHook_SetTransmit, OnSetTransmit_All)) setGlowTeam(skin, team);
        }
    }
}

public int CreatePlayerModelProp(int client, char[] sModel, char[] attachment, bool bonemerge, float scale) {
    RemoveSkin(client);
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