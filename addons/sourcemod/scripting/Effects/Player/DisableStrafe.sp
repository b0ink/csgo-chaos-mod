
int g_blockMovement[MAXPLAYERS+1];
float g_DisableKeys_OriginalPos[MAXPLAYERS+1][3];

public void Chaos_DisableStrafe_START(){
	g_bNoStrafe++;

}

public Action Chaos_DisableStrafe_RESET(bool EndChaos){
	if(g_bNoStrafe > 0) g_bNoStrafe--;
}

public Action Chaos_DisableStrafe_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	g_blockMovement[client] = 0;

	if(g_bNoStrafe > 0){
		if(buttons & IN_MOVELEFT){
			if(g_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, g_DisableKeys_OriginalPos[client]);
			}
			g_blockMovement[client]++;
		}else if(buttons & IN_MOVERIGHT){
			if(g_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, g_DisableKeys_OriginalPos[client]);
			}
			g_blockMovement[client]++;
		}
	}


	if(g_bNoForwardBack > 0){
		if(buttons & IN_FORWARD){
			if(g_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, g_DisableKeys_OriginalPos[client]);
			}
			g_blockMovement[client]++;
		}else if(buttons & IN_BACK){
			if(g_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, g_DisableKeys_OriginalPos[client]);
			}
			g_blockMovement[client]++;
		}
	}

	if(g_blockMovement[client] == 0){ //not pressing any movement keys
		g_DisableKeys_OriginalPos[client][0] = 0.0;
		g_DisableKeys_OriginalPos[client][1] = 0.0;
		g_DisableKeys_OriginalPos[client][2] = 0.0;
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

	if(g_blockMovement[client] > 0){
		float vec[3];
		GetClientAbsOrigin(client, vec);

		float vec2[3];
		vec2[0] = g_DisableKeys_OriginalPos[client][0];
		vec2[1] = g_DisableKeys_OriginalPos[client][1];
		vec2[2] = vec[2];
		if(GetVectorDistance(vec, g_DisableKeys_OriginalPos[client]) > 5){
			g_DisableKeys_OriginalPos[client][0] = 0.0;
			g_DisableKeys_OriginalPos[client][1] = 0.0;
			g_DisableKeys_OriginalPos[client][2] = 0.0;
		}
		if(g_DisableKeys_OriginalPos[client][0] != 0.0){
			TeleportEntity(client, vec2, NULL_VECTOR, vel);
		}else{
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
		}
	}
	
}
