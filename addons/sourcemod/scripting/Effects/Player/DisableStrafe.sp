
int Disable_Strafe[MAXPLAYERS+1];
float Disable_Strafe_DisableKeys_OriginalPos[MAXPLAYERS+1][3];

public void Chaos_DisableStrafe_START(){
	g_bNoStrafe++;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SDKHook(i, SDKHook_PreThinkPost, Chaos_DisableStrafe_Hook_PreThinkPost);
		}
	}
}

public Action Chaos_DisableStrafe_RESET(bool EndChaos){
	if(g_bNoStrafe > 0) g_bNoStrafe--;
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SDKUnhook(i, SDKHook_PreThinkPost, Chaos_DisableStrafe_Hook_PreThinkPost);
		}
	}
}

public Action Chaos_DisableStrafe_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	Disable_Strafe[client] = 0;

	if(g_bNoStrafe > 0){
		if(buttons & IN_MOVELEFT){
			if(Disable_Strafe_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, Disable_Strafe_DisableKeys_OriginalPos[client]);
			}
			Disable_Strafe[client]++;
		}else if(buttons & IN_MOVERIGHT){
			if(Disable_Strafe_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, Disable_Strafe_DisableKeys_OriginalPos[client]);
			}
			Disable_Strafe[client]++;
		}
	}

	if(Disable_Strafe[client] == 0){ //not pressing any movement keys
		Disable_Strafe_DisableKeys_OriginalPos[client][0] = 0.0;
		Disable_Strafe_DisableKeys_OriginalPos[client][1] = 0.0;
		Disable_Strafe_DisableKeys_OriginalPos[client][2] = 0.0;
	}

}


public bool Chaos_DisableStrafe_HasNoDuration(){
	return false;
}

public bool Chaos_DisableStrafe_Conditions(){
	return true;
}


//todo put vel and vec variables outside, and index players;
public void Chaos_DisableStrafe_Hook_PreThinkPost(int client){

	float vel[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", vel);
	vel[0] = 0.0;
	vel[1] = 0.0;

	if(Disable_Strafe[client] > 0){
		float vec[3];
		GetClientAbsOrigin(client, vec);

		float vec2[3];
		vec2[0] = Disable_Strafe_DisableKeys_OriginalPos[client][0];
		vec2[1] = Disable_Strafe_DisableKeys_OriginalPos[client][1];
		vec2[2] = vec[2];
		if(GetVectorDistance(vec, Disable_Strafe_DisableKeys_OriginalPos[client]) > 5){
			Disable_Strafe_DisableKeys_OriginalPos[client][0] = 0.0;
			Disable_Strafe_DisableKeys_OriginalPos[client][1] = 0.0;
			Disable_Strafe_DisableKeys_OriginalPos[client][2] = 0.0;
		}
		if(Disable_Strafe_DisableKeys_OriginalPos[client][0] != 0.0){
			TeleportEntity(client, vec2, NULL_VECTOR, vel);
		}else{
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
		}
	}
	
}
