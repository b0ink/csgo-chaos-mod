
Handle TPos = INVALID_HANDLE;
Handle CTPos = INVALID_HANDLE;
Handle tIndex = INVALID_HANDLE;
Handle ctIndex = INVALID_HANDLE;

SETUP(effect_data effect){
	effect.Title = "Teammate Swap";
	effect.HasNoDuration = true;
}

INIT(){
	if(TPos == INVALID_HANDLE) TPos = CreateArray(3);
	if(CTPos == INVALID_HANDLE) CTPos = CreateArray(3);
	if(tIndex == INVALID_HANDLE) tIndex = CreateArray(1);
	if(ctIndex == INVALID_HANDLE) ctIndex = CreateArray(1);
}

START(){
	if(TPos == INVALID_HANDLE){
		Chaos_TeammateSwap_INIT();
	}
	ClearArray(TPos);
	ClearArray(CTPos);
	ClearArray(tIndex);
	ClearArray(ctIndex);

	
	float vec[3];
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, vec);
			if(GetClientTeam(i) == CS_TEAM_T) 	PushArrayArray(TPos, vec);
			if(GetClientTeam(i) == CS_TEAM_CT) 	PushArrayArray(CTPos, vec);
		}
	}

	for(int i = MaxClients; i >= 0; i--){
		if(ValidAndAlive(i)){
			if(GetClientTeam(i) == CS_TEAM_T) 	PushArrayCell(tIndex, i);
			if(GetClientTeam(i) == CS_TEAM_CT) 	PushArrayCell(ctIndex, i);
		}
	}

	for(int i = 0; i < GetArraySize(ctIndex); i++){
		GetArrayArray(CTPos, i, vec);
		TeleportEntity(GetArrayCell(ctIndex, i), vec, NULL_VECTOR, NULL_VECTOR);
	}

	for(int i = 0; i < GetArraySize(tIndex); i++){
		GetArrayArray(TPos, i, vec);
		TeleportEntity(GetArrayCell(tIndex, i), vec, NULL_VECTOR, NULL_VECTOR);
	}
}

CONDITIONS(){
	if(GetAliveCTCount() <= 1 && GetAliveTCount() <= 1) return false;
	return true;
}
