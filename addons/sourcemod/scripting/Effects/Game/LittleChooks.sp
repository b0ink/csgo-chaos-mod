public void Chaos_LittleChooks_START(){
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int chance = GetRandomInt(0,100);
		if(chance <= 25){ //too many chickens is a no no
			int ent = CreateEntityByName("chicken");
			if(ent != -1){
				float vec[3];
				GetArrayArray(g_MapCoordinates, i, vec);
				TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(ent);
				float randomSize = GetRandomFloat(0.4, 0.9);
				SetEntPropFloat(ent, Prop_Data, "m_flModelScale", randomSize);
			}
		}
	
	}
}

public Action Chaos_LittleChooks_RESET(bool EndChaos){
	RemoveChickens();
	g_bCanSpawnChickens = true;
}

// public Action Chaos_LittleChooks_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }

public bool Chaos_LittleChooks_HasNoDuration(){
	return true;
}

public bool Chaos_LittleChooks_Conditions(){
	if(!g_bCanSpawnChickens) return false;
	return true;
}