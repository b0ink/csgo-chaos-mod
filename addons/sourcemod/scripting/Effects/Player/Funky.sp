public bool Chaos_Autobhop(effect_data effect){
	// effect.NoDuration = true;

}


public void Chaos_Autobhop_START(){
	g_AutoBunnyhop++;
	cvar("sv_airaccelerate", "1999");

}

public Action Chaos_Autobhop_RESET(bool HasTimerEnded){
	ResetCvar("sv_airaccelerate", "12", "1999");
	if(g_AutoBunnyhop > 0) g_AutoBunnyhop--;
}

float funky_Velocity[3];
public Action Chaos_Autobhop_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_AutoBunnyhop > 0){
		if(ValidAndAlive(client) && GetEntityFlags(client) & FL_ONGROUND && buttons & IN_JUMP){
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", funky_Velocity);
			funky_Velocity[2] = 282.0;
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, funky_Velocity);
		}
	}
}


public bool Chaos_Autobhop_HasNoDuration(){
	return false;
}

public bool Chaos_Autobhop_Conditions(){
	return true;
}