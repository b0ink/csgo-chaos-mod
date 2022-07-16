//TODO: Prevent spawnables such as barrels from spawning on bomb spawns, on the off chance it blocks the bomb.. but meme?

public void Chaos_SpawnExplodingBarrels_START(){
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec, sizeof(vec));
			if(DistanceToClosestPlayer(vec) > 50){
				int barrel = CreateEntityByName("prop_exploding_barrel");
				TeleportEntity(barrel, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(barrel);
			}
		}
	}
}

public Action Chaos_SpawnExplodingBarrels_RESET(bool HasTimerEnded){

}

public Action Chaos_SpawnExplodingBarrels_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_SpawnExplodingBarrels_HasNoDuration(){
	return true;
}

public bool Chaos_SpawnExplodingBarrels_Conditions(){
	return true;
}