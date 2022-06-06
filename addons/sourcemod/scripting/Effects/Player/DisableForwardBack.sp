
int Disable_WS[MAXPLAYERS+1];
float Disable_WS_DisableKeys_OriginalPos[MAXPLAYERS+1][3];

public void Chaos_DisableForwardBack_START(){
	g_bNoForwardBack++;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SDKHook(i, SDKHook_PreThinkPost, Chaos_DisableForwardBack_Hook_PreThinkPost);
		}
	}
}

public Action Chaos_DisableForwardBack_RESET(bool EndChaos){
	if(g_bNoForwardBack > 0) g_bNoForwardBack--;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SDKUnhook(i, SDKHook_PreThinkPost, Chaos_DisableForwardBack_Hook_PreThinkPost);
		}
	}
}

public Action Chaos_DisableForwardBack_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	Disable_WS[client] = 0;
	if(g_bNoForwardBack > 0){
		if(buttons & IN_FORWARD){
			if(Disable_WS_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, Disable_WS_DisableKeys_OriginalPos[client]);
			}
			Disable_WS[client]++;
		}else if(buttons & IN_BACK){
			if(Disable_WS_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, Disable_WS_DisableKeys_OriginalPos[client]);
			}
			Disable_WS[client]++;
		}
	}
	
	if(Disable_WS[client] == 0){ //not pressing any movement keys
		Disable_WS_DisableKeys_OriginalPos[client][0] = 0.0;
		Disable_WS_DisableKeys_OriginalPos[client][1] = 0.0;
		Disable_WS_DisableKeys_OriginalPos[client][2] = 0.0;
	}

}


public bool Chaos_DisableForwardBack_HasNoDuration(){
	return false;
}

public bool Chaos_DisableForwardBack_Conditions(){
	return true;
}

public void Chaos_DisableForwardBack_Hook_PreThinkPost(int client){

	float vel[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", vel);
	vel[0] = 0.0;
	vel[1] = 0.0;

	if(Disable_WS[client] > 0){
		float vec[3];
		GetClientAbsOrigin(client, vec);

		float vec2[3];
		vec2[0] = Disable_WS_DisableKeys_OriginalPos[client][0];
		vec2[1] = Disable_WS_DisableKeys_OriginalPos[client][1];
		vec2[2] = vec[2];
		if(GetVectorDistance(vec, Disable_WS_DisableKeys_OriginalPos[client]) > 5){
			Disable_WS_DisableKeys_OriginalPos[client][0] = 0.0;
			Disable_WS_DisableKeys_OriginalPos[client][1] = 0.0;
			Disable_WS_DisableKeys_OriginalPos[client][2] = 0.0;
		}
		if(Disable_WS_DisableKeys_OriginalPos[client][0] != 0.0){
			TeleportEntity(client, vec2, NULL_VECTOR, vel);
		}else{
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
		}
	}
	
}
