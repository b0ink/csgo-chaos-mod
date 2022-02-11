//CREDIT:
//https://github.com/b3none/retakes-autoplant/blob/master/scripting/retakes_autoplant.sp

int bomber;
int bombsite;

bool g_bHasBombBeenDeleted;
float bombPosition[3];
// Handle bombTimer;
int bombTicking;


enum //Bombsites
{
    BOMBSITE_INVALID = -1,
    BOMBSITE_A = 0,
    BOMBSITE_B = 1
}

// public Plugin myinfo =
// {
//     name = "[Retakes] Autoplant",
//     author = "B3none",
//     description = "Automatically plant the bomb at the start of the round. This will work with all versions of the retakes plugin.",
//     version = "2.3.1",
//     url = "https://github.com/b3none"
// };


public void AUTOPLANT_INIT(){
    bombTicking = FindSendPropInfo("CPlantedC4", "m_bBombTicking");
}

int g_PlantedSite = -1;
void AutoPlantC4(bool ForcedRetry = false){
    g_bHasBombBeenDeleted = false;
    bomber = GetBomber();
    
    if (IsValidClient(bomber)){
        bombsite = GetNearestBombsite(bomber);
        g_PlantedSite = bombsite;
        if(bombsite == BOMBSITE_A && bombSiteA != INVALID_HANDLE){
            int randomCoord = GetRandomInt(0, GetArraySize(bombSiteA)-1);
            GetArrayArray(bombSiteA, randomCoord, bombPosition);
        }
        if(bombsite == BOMBSITE_B && bombSiteB != INVALID_HANDLE){
            int randomCoord = GetRandomInt(0, GetArraySize(bombSiteB)-1);
            GetArrayArray(bombSiteB, randomCoord, bombPosition);
        }

        int bomb = GetPlayerWeaponSlot(bomber, 4);
        g_bHasBombBeenDeleted = SafeRemoveWeapon(bomber, bomb);
        PlantBomb(INVALID_HANDLE, bomber);

    }else if(!ForcedRetry){
        int iMaxEnts = GetMaxEntities();
        char sClassName[64];
        for(int i=MaxClients;i<iMaxEnts;i++){
            if(IsValidEntity(i) && IsValidEdict(i) && GetEdictClassname(i, sClassName, sizeof(sClassName)) &&
            StrEqual(sClassName, "weapon_c4")
            && GetEntPropEnt(i, Prop_Send, "m_hOwnerEntity") == -1){
                RemoveEntity(i);
            }
        }
        for(int i = 0; i <= MaxClients; i++){
            if(ValidAndAlive(i) && GetClientTeam(i) == CS_TEAM_T){
                GivePlayerItem(i, "weapon_c4");
                CreateTimer(0.5, Timer_RetryAutoPlant);
                break;
            }
        }
    }
}

public Action Timer_RetryAutoPlant(Handle timer){
    AutoPlantC4(true);
}

public void AutoPlantRoundEnd(){
    if(g_bBombPlanted){
        g_bBombPlanted = false;
        GameRules_SetProp("m_bBombPlanted", 0);
        g_PlantedSite = -1;
    }
}


public Action PlantBomb(Handle timer, int client){
    if (IsValidClient(client) || !g_bHasBombBeenDeleted){
        if (g_bHasBombBeenDeleted){
            int bombEntity = CreateEntityByName("planted_c4");

            GameRules_SetProp("m_bBombPlanted", 1);
            SetEntData(bombEntity, bombTicking, 1, 1, true);
            Sendg_bBombPlanted(client);

            if (DispatchSpawn(bombEntity)){
				ActivateEntity(bombEntity);
				TeleportEntity(bombEntity, bombPosition, NULL_VECTOR, NULL_VECTOR);
				GroundEntity(bombEntity);
				g_bBombPlanted = true;
            }
        }
    }else{
        PrintToChatAll("something weird happened");
        // CS_TerminateRound(1.0, CSRoundEnd_Draw); // todo; ??
    }
}

public void Sendg_bBombPlanted(int client){
    Event event = CreateEvent("bomb_planted");
    if (event != null){
        event.SetInt("userid", GetClientUserId(client));
        event.SetInt("site", bombsite);
        event.Fire();
    }
}

stock bool SafeRemoveWeapon(int client, int weapon){
    if (!IsValidEntity(weapon) || !IsValidEdict(weapon) || !HasEntProp(weapon, Prop_Send, "m_hOwnerEntity")) return false;

    int ownerEntity = GetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity");
    if (ownerEntity != client) SetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity", client);

    SDKHooks_DropWeapon(client, weapon, NULL_VECTOR, NULL_VECTOR);

    if (HasEntProp(weapon, Prop_Send, "m_hWeaponWorldModel")){
        int worldModel = GetEntPropEnt(weapon, Prop_Send, "m_hWeaponWorldModel");
        if (IsValidEdict(worldModel) && IsValidEntity(worldModel)){
            if (!AcceptEntityInput(worldModel, "Kill")) return false;
        }
    }
    
    return AcceptEntityInput(weapon, "Kill");
}

stock int GetBomber(){
    for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i) && HasBomb(i)) return i;
    return -1;
}

stock bool HasBomb(int client){
    return GetPlayerWeaponSlot(client, 4) != -1;
}


stock bool IsWarmup(){
    return GameRules_GetProp("m_bWarmupPeriod") == 1;
}

stock int GetNearestBombsite(int client){
    float pos[3];
    GetClientAbsOrigin(client, pos);
    
    int playerResource = GetPlayerResourceEntity();
    if (playerResource == -1) return BOMBSITE_INVALID;
    
    float aCenter[3], bCenter[3];
    GetEntPropVector(playerResource, Prop_Send, "m_bombsiteCenterA", aCenter);
    GetEntPropVector(playerResource, Prop_Send, "m_bombsiteCenterB", bCenter);
    
    float aDist = GetVectorDistance(aCenter, pos, true);
    float bDist = GetVectorDistance(bCenter, pos, true);
    
    if (aDist < bDist) return BOMBSITE_A;
    
    return BOMBSITE_B;
}

/**
 * https://forums.alliedmods.net/showpost.php?p=2239502&postcount=2
 */
void GroundEntity(int entity){
    float flPos[3], flAng[3];
    
    GetEntPropVector(entity, Prop_Send, "m_vecOrigin", flPos);
    flAng[0] = 90.0;
    flAng[1] = 0.0;
    flAng[2] = 0.0;
    Handle hTrace = TR_TraceRayFilterEx(flPos, flAng, MASK_SHOT, RayType_Infinite, TraceFilterIgnorePlayers, entity);
    if (hTrace != INVALID_HANDLE && TR_DidHit(hTrace)){
        float endPos[3];
        TR_GetEndPosition(endPos, hTrace);
        CloseHandle(hTrace);
        TeleportEntity(entity, endPos, NULL_VECTOR, NULL_VECTOR);
    }else{
        PrintToServer("Attempted to put entity on ground, but no end point found!");
    }
}

public bool TraceFilterIgnorePlayers(int entity, int contentsMask, int client){
    if (entity >= 1 && entity <= MaxClients) return false;
    return true;
} 