
int 	g_bNoStrafe = 0;

int Disable_Strafe[MAXPLAYERS+1];
float Disable_Strafe_DisableKeys_OriginalPos[MAXPLAYERS+1][3];
public void Chaos_DisableStrafe(effect_data effect){
	effect.Title = "Disable A / D Keys";
	effect.Duration = 30;
}


public void Chaos_DisableStrafe_START(){
	g_bNoStrafe++;
}

public Action Chaos_DisableStrafe_RESET(bool HasTimerEnded){
	if(g_bNoStrafe > 0) g_bNoStrafe--;
}

public Action Chaos_DisableStrafe_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	Disable_Strafe[client] = 0;

	if(g_bNoStrafe > 0){
		if(buttons & IN_MOVELEFT){ //TODO: && if vel[x] != 0.0
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

float disableStrafe_vel[3];
float disableStrafe_vec[3];
float disableStrafe_vec2[3];

public void Chaos_DisableStrafe_Hook_PreThinkPost(int client){
	if(g_bNoStrafe <= 0) return;

	GetEntPropVector(client, Prop_Data, "m_vecVelocity", disableStrafe_vel);
	disableStrafe_vel[0] = 0.0;
	disableStrafe_vel[1] = 0.0;

	if(Disable_Strafe[client] > 0){
		GetClientAbsOrigin(client, disableStrafe_vec);

		disableStrafe_vec2[0] = Disable_Strafe_DisableKeys_OriginalPos[client][0];
		disableStrafe_vec2[1] = Disable_Strafe_DisableKeys_OriginalPos[client][1];
		disableStrafe_vec2[2] = disableStrafe_vec[2];

		if(GetVectorDistance(disableStrafe_vec, Disable_Strafe_DisableKeys_OriginalPos[client]) > 5){
			Disable_Strafe_DisableKeys_OriginalPos[client][0] = 0.0;
			Disable_Strafe_DisableKeys_OriginalPos[client][1] = 0.0;
			Disable_Strafe_DisableKeys_OriginalPos[client][2] = 0.0;
		}
		if(Disable_Strafe_DisableKeys_OriginalPos[client][0] != 0.0){
			TeleportEntity(client, disableStrafe_vec2, NULL_VECTOR, disableStrafe_vel);
		}else{
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, disableStrafe_vel);
		}
	}
	
}
