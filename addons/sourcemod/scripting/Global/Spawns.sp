#pragma semicolon 1

Handle 	g_MapCoordinates = INVALID_HANDLE;
Handle 	g_UnusedCoordinates = INVALID_HANDLE;
Handle 	bombSiteA = INVALID_HANDLE;
Handle 	bombSiteB = INVALID_HANDLE;

float g_AllPositions[MAXPLAYERS+1][3];

void SavePlayersLocations(){
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, g_AllPositions[i]);
	}
}


#define LoopAllMapSpawns(%1,%2) for(int %2 = 0; %2 < GetArraySize(g_MapCoordinates); %2++)\
		if(GetArrayArray(g_MapCoordinates, %2, %1, sizeof(%1)) > 0)

float no_vel[3] = {0.0, 0.0, 0.0};

//make sure to SavePlayersLocations before using this.
void TeleportPlayersToClosestLocation(int client = -1, int minDist = 0){
	if(g_MapCoordinates != INVALID_HANDLE){
		ClearArray(g_UnusedCoordinates);

		for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			PushArrayArray(g_UnusedCoordinates, vec);
		}

		LoopAlivePlayers(i){
				if(client != -1 && client != i) continue; //only set specific player
				int CoordinateIndex = -1;
				float DistanceToBeat = 99999.0;
				if(GetArraySize(g_UnusedCoordinates) > 0){
					float playersVec[3];
					GetClientAbsOrigin(i, playersVec);
					for(int coord = 0; coord <= GetArraySize(g_UnusedCoordinates)-1; coord++){
						float vec[3];
						GetArrayArray(g_UnusedCoordinates, coord, vec);
						if(DistanceToClosestEntity(vec, "prop_exploding_barrel") > 50){
							float dist = GetVectorDistance(playersVec, vec);
							if((dist < DistanceToBeat) && dist >= minDist){
								CoordinateIndex = coord;
								DistanceToBeat = dist;
							}
						}
					}
					if(CoordinateIndex != -1){
						float realVec[3];
						//TODO: come back to this??
						do{
							GetArrayArray(g_UnusedCoordinates, CoordinateIndex, realVec);
						}
						while(DistanceToClosestEntity(realVec, "prop_exploding_barrel") < 50);
						// realVec[2] = realVec[2] - 60;

						// PrintToChatAll("flags: %i", GetEntProp(i, Prop_Send, "m_fEffects"));

						// SetEntProp(i, Prop_Send, "m_fEffects", 0);
						TeleportEntity(i, realVec, NULL_VECTOR, no_vel);
						// SetEntityFlags(i, ER_NO)

						// int effect = GetEntProp(i, Prop_Data, "m_fEffects");

						RemoveFromArray(g_UnusedCoordinates, CoordinateIndex);
						CoordinateIndex = -1;
						DistanceToBeat = 99999.0;
					}else{
						TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
					}
				}else{
					TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
				}
				SetEntityMoveType(i, MOVETYPE_WALK);
		}
			
	} else{
		LoopValidPlayers(i){
			TeleportEntity(i, g_AllPositions[i], NULL_VECTOR, no_vel);
			SetEntityMoveType(i, MOVETYPE_WALK);
		}
	}
	
}

void DoRandomTeleport(int client = -1){
	ShuffleMapSpawns();

	float vec[3];
	if(client == -1){
		int index = 0;
		LoopAlivePlayers(i){
			if(GetArraySize(g_MapCoordinates) > index){
				GetArrayArray(g_MapCoordinates, index, vec, sizeof(vec));
				if(DistanceToClosestEntity(vec, "prop_exploding_barrel") > 50){
					TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
					PrintToConsole(i, "%N to %f %f %f", i, vec[0], vec[1], vec[2]);
				}
				index++;
			}
		}
	}else{
		GetArrayArray(g_MapCoordinates, 0, vec);
		if(DistanceToClosestEntity(vec, "prop_exploding_barrel") > 50){
			TeleportEntity(client, vec, NULL_VECTOR, NULL_VECTOR);
			PrintToConsole(client, "%N to %f %f %f", client, vec[0], vec[1], vec[2]);
		}
	}
}


void ShuffleMapSpawns(){
	SortADTArray(g_MapCoordinates, Sort_Random, Sort_Float);
}

//returns the units between vec[3] and the closest player
int DistanceToClosestPlayer(float vec[3]){
	float dist = 999999.0;
	float playerVec[3];
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, playerVec);
		if(GetVectorDistance(playerVec, vec) < dist){
			dist = GetVectorDistance(playerVec, vec);
		}
	}
	return RoundToFloor(dist);
}

int DistanceToClosestEntity(float vec[3], char[] entity){
	float dist = 999999.0;
	float barrelVec[3];
	
	char classname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		if(StrEqual(classname, entity)){
			GetEntPropVector(ent, Prop_Send, "m_vecOrigin", barrelVec);
			if(GetVectorDistance(barrelVec, vec) < dist){
				dist = GetVectorDistance(barrelVec, vec);
			}
		}
	}
	
	return RoundToFloor(dist);
}

/**
 * Checks if there are valid map spawn points.
 * 
 * @return     Returns true if there is atleast 4 available spawn points for EVERY player.
 */
bool ValidMapPoints(){
	if(g_MapCoordinates == INVALID_HANDLE) return false;
	if(GetArraySize(g_MapCoordinates) == 0) return false;
	if(GetArraySize(g_MapCoordinates) < (GetPlayerCount() * 4)) return false;
	return true;
}

/**
 * Checks if there are valid bomb spawn points.
 * 
 * @return     Returns true if there is atleast one spawn point for BOTH bomsite A & B
 */
bool ValidBombSpawns(){
	if(bombSiteA == INVALID_HANDLE) return false;
	if(bombSiteB == INVALID_HANDLE) return false;
	if(GetArraySize(bombSiteA) == 0 || GetArraySize(bombSiteB) == 0) return false;
	return true;
}