public void Chaos_ESP(effect_data effect){
    effect.Title = "Wall Hacks";
    effect.Duration = 30;
    
    effect.AddAlias("Wallhacks");
    effect.AddAlias("Cheats");
}

int portal_colors[2][4];
public void Chaos_ESP_INIT(){
	portal_colors[0][0] = 144;
	portal_colors[0][1] = 120;
	portal_colors[0][2] = 72;

	portal_colors[1][0] = 72;
	portal_colors[1][1] = 96;
	portal_colors[1][2] = 144;
}


public void Chaos_ESP_START(){
	cvar("sv_force_transmit_players", "1");
	createGlows();
}

public void Chaos_ESP_RESET(bool HasTimerEnded){
	ResetCvar("sv_force_transmit_players", "0", "1");
	destroyGlows();
}

int playerModels[MAXPLAYERS+1] = {INVALID_ENT_REFERENCE,...};
int playerModelsIndex[MAXPLAYERS+1] = {-1,...};

#define EF_BONEMERGE                (1 << 0)
#define EF_NOSHADOW                 (1 << 4)
#define EF_NORECEIVESHADOW          (1 << 6)

public void checkGlows(){
	destroyGlows();
	createGlows();
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

    // So now setup given glow portal_colors for the skin
    for(int i=0;i<3;i++) {
        SetEntData(entity, offset + i, color[i], _, true); 
    }
}

public void setGlowTeam(int skin, int team) {
    if(team >= 2) {
        SetupGlow(skin, portal_colors[team-2]);
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
    LoopAlivePlayers(i){
        RemoveSkin(i);
    }
}

public void createGlows() {
    char model[PLATFORM_MAX_PATH];
    char attachment[PLATFORM_MAX_PATH];
    int skin = -1;
    //Loop and setup a glow on alive players.
    attachment = "primary";
    LoopAlivePlayers(client){
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