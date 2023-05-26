#pragma semicolon 1

ArrayList DoorStuckEnt;
public void Chaos_DoorStuck(EffectData effect){
	effect.Title = "DOOR STUCK!";
	effect.Duration = 10;	
	DoorStuckEnt = new ArrayList();
}

char DoorStuckModel[] = "models/props/hr_massive/rural_door_1/rural_door_1.mdl";

public void Chaos_DoorStuck_OnMapStart(){
	PrecacheModel(DoorStuckModel, true);
}

public void Chaos_DoorStuck_START(){
	LoopValidPlayers(i){
		ClientCommand(i, "playgamesound doors/wood_stop1.wav");
		SpawnDoor(i);
	}
}

public void Chaos_DoorStuck_RESET(int ResetType){
	RemoveEntitiesInArray(DoorStuckEnt);
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
	DoorStuckEnt.Push(EntIndexToEntRef(door));
	// brown wood colour
	// SetEntityRenderMode(door, RENDER_TRANSALPHA);
	// SetEntityRenderColor(door, 87, 43, 0, 255);
}