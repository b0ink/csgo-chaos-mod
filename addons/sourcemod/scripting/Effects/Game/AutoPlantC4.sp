#pragma semicolon 1


//CREDIT:
//https://github.com/b3none/retakes-autoplant/blob/master/scripting/retakes_autoplant.sp

// public Plugin myinfo =
// {
//     name = "[Retakes] Autoplant",
//     author = "B3none",
//     description = "Automatically plant the bomb at the start of the round. This will work with all versions of the retakes plugin.",
//     version = "2.3.1",
//     url = "https://github.com/b3none"
// };

bool 	g_bBombPlanted = false;

int bomber;
int bombsite;

float bombPosition[3];
int bombTicking;
int g_PlantedSite = -1;


enum //Bombsites
{
    BOMBSITE_INVALID = -1,
    BOMBSITE_A = 0,
    BOMBSITE_B = 1
}

public void Chaos_AutoPlantC4(effect_data effect){
    effect.Title = "Auto Plant C4";
    effect.HasNoDuration = true;
    effect.HasCustomAnnouncement = true;
    effect.AddAlias("Bomb");
}

public void Chaos_AutoPlantC4_INIT(){
    bombTicking = FindSendPropInfo("CPlantedC4", "m_bBombTicking");
    HookEvent("bomb_planted", Chaos_AutoPlantC4_Event_BombPlanted);
}


public void Chaos_AutoPlantC4_Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	g_bBombPlanted = true;
}


public bool Chaos_AutoPlantC4_Conditions(bool EffectRunRandomly){
    if(!ValidBombSpawns() || isHostageMap() || !GameModeUsesC4()) return false;
    
    if(GetRoundTime() <= 16 && EffectRunRandomly) return false; // prevent a bomb plant as soon as the round starts
    if(
        (g_PlantedSite != BOMBSITE_A) && (bombSiteB == INVALID_HANDLE) &&
        (g_PlantedSite != BOMBSITE_B) && (bombSiteA == INVALID_HANDLE) &&
        (g_PlantedSite != -1)
    ){
        return false;
    }
    return true;
}


public void Chaos_AutoPlantC4_START(){
	if(g_bBombPlanted){
        TeleportC4ToNewBombSite();
        return;
	}
	AutoPlantC4();
	CreateTimer(0.1, Timer_EnsureSpawnedAutoPlant);
}


public void TeleportC4ToNewBombSite(){
    float newBombPosition[3];
    char newBombSiteName[64];

    if(bombSiteA == INVALID_HANDLE || bombSiteB == INVALID_HANDLE){
        return;
    }

    bool randomASite = false;
    bool randomBSite = false;
    if(g_PlantedSite == -1){
        if(GetRandomInt(1,100) < 50){
            randomASite = true;
        }else{
            randomBSite = true;
        }
    }

    if(g_PlantedSite == BOMBSITE_A || randomASite){
        int randomCoord = GetRandomInt(0, GetArraySize(bombSiteB)-1);
        GetArrayArray(bombSiteB, randomCoord, newBombPosition);
        newBombSiteName = "Bombsite B";
        g_PlantedSite = BOMBSITE_B; 
    }else if(g_PlantedSite == BOMBSITE_B || randomBSite){
        int randomCoord = GetRandomInt(0, GetArraySize(bombSiteA)-1);
        GetArrayArray(bombSiteA, randomCoord, newBombPosition);
        newBombSiteName = "Bombsite A";
        g_PlantedSite = BOMBSITE_A;
    }

    int bombEnt = FindEntityByClassname(-1, "planted_c4");
    if(GetC4ChickenEntity() != -1) bombEnt = GetC4ChickenEntity();
    // newBombPosition[2] = newBombPosition[2] - 64;
    if(bombEnt != -1){
        TeleportEntity(bombEnt, newBombPosition, NULL_VECTOR, NULL_VECTOR);
        char AnnounceMessage[128];
        FormatEx(AnnounceMessage, sizeof(AnnounceMessage), "Teleport bomb to %s", newBombSiteName);
        AnnounceChaos(AnnounceMessage, -1.0);
        return;
    }else{
        g_PlantedSite = -1; //fooked up
    }

}


public Action Timer_EnsureSpawnedAutoPlant(Handle timer){
	if(g_PlantedSite == BOMBSITE_A){
		AnnounceChaos(GetChaosTitle("Chaos_AutoPlantC4_A"), -1.0);
	}else if(g_PlantedSite == BOMBSITE_B){
		AnnounceChaos(GetChaosTitle("Chaos_AutoPlantC4_B"), -1.0);
	}else{
		AnnounceChaos(GetChaosTitle("Chaos_AutoPlantC4"), -1.0);
	}
	return Plugin_Continue;
}


void AutoPlantC4(){
    bomber = GetBomber();
    
    if(IsValidClient(bomber)){
        float pos[3];
        GetClientAbsOrigin(bomber, pos);
        bombsite = GetNearestBombsite(pos);
    }else{
        if((GetURandomInt() % 100) < 50){
            bombsite = BOMBSITE_A;
        }else{
            bombsite = BOMBSITE_B;
        }
    }

    g_PlantedSite = bombsite;

    if(bombsite == BOMBSITE_A){
        int randomCoord = GetRandomInt(0, GetArraySize(bombSiteA)-1);
        GetArrayArray(bombSiteA, randomCoord, bombPosition);
    }

    if(bombsite == BOMBSITE_B){
        int randomCoord = GetRandomInt(0, GetArraySize(bombSiteB)-1);
        GetArrayArray(bombSiteB, randomCoord, bombPosition);
    }

    int bombEntity = CreateEntityByName("planted_c4");

    GameRules_SetProp("m_bBombPlanted", 1);
    SetEntData(bombEntity, bombTicking, 1, 1, true);
    if(IsValidClient(bomber)){
        SendBombPlanted(bomber);
    }else{
        SendBombPlanted(getRandomAlivePlayer());
    }

    if (DispatchSpawn(bombEntity)){
        ActivateEntity(bombEntity);
        TeleportEntity(bombEntity, bombPosition, NULL_VECTOR, NULL_VECTOR);
        GroundEntity(bombEntity);
        g_bBombPlanted = true;
    }

}


public void AutoPlantRoundEnd(){
    if(g_bBombPlanted){
        g_bBombPlanted = false;
        GameRules_SetProp("m_bBombPlanted", 0);
        g_PlantedSite = -1;
    }
}


public void SendBombPlanted(int client){
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
            if (!RemoveEntity(worldModel)) return false;
        }
    }
    RemoveEntity(weapon);
    return true;
}

int GetBomber(){
    int bomb = -1;
    int owner = -1;
    while((bomb = FindEntityByClassname(bomb, "weapon_c4")) != -1){
        if(IsValidEntity(bomb)){
            int ent = GetEntPropEnt(bomb, Prop_Send, "m_hOwnerEntity");
            if(IsValidClient(ent)){
                owner = ent;
                SafeRemoveWeapon(owner, bomb);
            }else{
                RemoveEntity(bomb);
            }
        }
    }

    return owner;
}


stock int GetNearestBombsite(float pos[3]){
    // float pos[3];
    // GetClientAbsOrigin(client, pos);
    
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
