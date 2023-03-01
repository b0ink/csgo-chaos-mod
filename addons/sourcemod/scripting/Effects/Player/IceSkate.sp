#pragma semicolon 1

public void Chaos_IceSkate(EffectData effect){
	effect.Title = "Ice Skating";
	effect.Duration = 15;
	effect.IncompatibleWith("Chaos_Autobhop");
	effect.IncompatibleWith("Chaos_InsaneAirSpeed");
}

//TODO: translations
public void Chaos_IceSkate_START(){
	cvar("sv_airaccelerate", "2000");
	CPrintToChatAll("%s Hold [Space] and strafe to Ice Skate!", g_Prefix);
	PrintHintTextToAll("Hold [Space] and strafe to Ice Skate!");
}

public void Chaos_IceSkate_RESET(int ResetType){
	ResetCvar("sv_airaccelerate", "12", "2000");
}


public void Chaos_IceSkate_OnGameFrame(){
	// trace down, see if there's 8 distance or less to ground
	float fPosition[3];
	float fGroundPosition[3];
	float fSpeed[3];

	LoopAlivePlayers(i){
		if(!(GetClientButtons(i) & IN_JUMP)) continue;
		GetClientAbsOrigin(i, fPosition);
		TR_TraceRayFilter(fPosition, view_as<float>({90.0, 0.0, 0.0}), MASK_PLAYERSOLID, RayType_Infinite, TRFilter_NoPlayers, i);

		// Hint to give info on why players cant jump.
		//TODO: allow players to spacebar jump, but holding for 0.2 seconds activates ice skating 
		PrintHintText(i, "You are now ice skating. Strafe left and right to gain speed!");

		if(TR_DidHit() && TR_GetEndPosition(fGroundPosition) && GetVectorDistance(fPosition, fGroundPosition) <= 25.0)
		{
			GetEntPropVector(i, Prop_Data, "m_vecAbsVelocity", fSpeed);
			// fSpeed[2] = 8.0 * GetEntityGravity(i) * GetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue"); //! * (sv_gravity.FloatValue / 800);
			fSpeed[2] = 15.0 * GetEntityGravity(i) * GetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue"); //! * (sv_gravity.FloatValue / 800);
			TeleportEntity(i, NULL_VECTOR, NULL_VECTOR, fSpeed);
		}
	}
}


public bool TRFilter_NoPlayers(int entity, int mask, any data){
	//return (entity != view_as<int>(data) || (entity < 1 || entity > MaxClients));
	return !(1 <= entity <= MaxClients);
}