
/*
	Runs on the OnMapStart function. Use this to precache any models or textures.
*/
bool IceSkate = false;
bool ForceJumpSkate[MAXPLAYERS+1];

/* This is used when the effect is fired */
public void Chaos_IceSkate_START(){
	cvar("sv_airaccelerate", "2000");
	IceSkate = true;
}

public Action Chaos_IceSkate_RESET(bool HasTimerEnded){
	ResetCvar("sv_airaccelerate", "12", "2000");
	IceSkate = false;
}

//TODO:: add to Chaos_Jumping
public Action Chaos_IceSkate_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(IceSkate){
		ForceJumpSkate[client] = !ForceJumpSkate[client];
		if(ForceJumpSkate[client]){
			buttons |= IN_JUMP;
		}else{
			buttons &= ~IN_JUMP;
		}
	}
}


public Action Chaos_IceSkate_OnGameFrame(){
		if(!IceSkate) return;

		// trace down, see if there's 8 distance or less to ground
		float fPosition[3];
		float fGroundPosition[3];
		float fSpeed[3];

		LoopAlivePlayers(i){
			GetClientAbsOrigin(i, fPosition);
			TR_TraceRayFilter(fPosition, view_as<float>({90.0, 0.0, 0.0}), MASK_PLAYERSOLID, RayType_Infinite, TRFilter_NoPlayers, i);


			if(TR_DidHit() && TR_GetEndPosition(fGroundPosition) && GetVectorDistance(fPosition, fGroundPosition) <= 25.0)
			{
				GetEntPropVector(i, Prop_Data, "m_vecAbsVelocity", fSpeed);
				// fSpeed[2] = 8.0 * GetEntityGravity(i) * GetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue"); //! * (sv_gravity.FloatValue / 800);
				fSpeed[2] = 25.0 * GetEntityGravity(i) * GetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue"); //! * (sv_gravity.FloatValue / 800);
				TeleportEntity(i, NULL_VECTOR, NULL_VECTOR, fSpeed);
			}
		}
}


public bool TRFilter_NoPlayers(int entity, int mask, any data)
{
	//return (entity != view_as<int>(data) || (entity < 1 || entity > MaxClients));
	return !(1 <= entity <= MaxClients);
}


public bool Chaos_IceSkate_CustomAnnouncement(){
	return false;
}

public bool Chaos_IceSkate_Conditions(){
	return true;
}
