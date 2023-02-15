#pragma semicolon 1

public void Chaos_DoorStuck(EffectData effect){
	effect.Title = "DOOR STUCK!";
	effect.Duration = 30;	
}

char DoorStuckModel[] = "models/props/hr_massive/rural_door_1/rural_door_1.mdl";

public void Chaos_DoorStuck_OnMapStart(){
	PrecacheModel(DoorStuckModel, true);
}

public void Chaos_DoorStuck_START(){
	LoopAlivePlayers(i){
		ClientCommand(i, "playgamesound doors/wood_stop1.wav");
		SpawnDoor(i);
	}
}

public void Chaos_DoorStuck_RESET(int ResetType){
	char classname[64];
	char targetname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		if(StrEqual(classname, "prop_door_rotating")){
			GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
			if(StrEqual(targetname, "DoorStuck", false)){
				RemoveEntity(ent);
			}else{
				continue;
			}
		}
	}
}

void SpawnDoor(int client){
	int door = CreateEntityByName("prop_door_rotating");
	SetEntityModel(door, DoorStuckModel);
	DispatchKeyValue(door, "targetname", "DoorStuck");
	

	float clientAngles[3];
	float clientPosition[3];
	GetClientAbsAngles(client, clientAngles);
	GetClientAbsOrigin(client, clientPosition);

	float direction[3], newPosition[3];

	// Here we get the forward vector of the client, set the distance to move forward and store it
	GetAngleVectors(clientAngles, direction, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(direction, 25.0);
	AddVectors(clientPosition, direction, newPosition);
							
	// Then from the forwards position, get the right vector, negate it since we want to move left, set the distance to move left and overwrite newPosition
	GetAngleVectors(clientAngles, NULL_VECTOR, direction, NULL_VECTOR);
	NegateVector(direction);
	ScaleVector(direction, -25.0);
	AddVectors(newPosition, direction, newPosition);

	newPosition[2] += 45.0;
	TeleportEntity(door, newPosition, clientAngles, NULL_VECTOR);
	
	DispatchKeyValueFloat(door, "returndelay", -1.0);
	// +use closes door & breakable door
	DispatchKeyValue(door, "spawnflags", "532480");
	DispatchSpawn(door);
	
	// brown wood colour
	// SetEntityRenderMode(door, RENDER_TRANSALPHA);
	// SetEntityRenderColor(door, 87, 43, 0, 255);
}