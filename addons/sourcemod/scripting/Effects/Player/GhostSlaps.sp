Handle Chaos_RandomSlap_Timer = INVALID_HANDLE;
float g_Chaos_RandomSlap_Interval = 7.0;

public void Chaos_GhostSlaps_START(){
	g_NoFallDamage++;
	Chaos_RandomSlap_Timer = CreateTimer(g_Chaos_RandomSlap_Interval, Timer_RandomSlap, _,TIMER_REPEAT);
}

public Action Chaos_GhostSlaps_RESET(bool HasTimerEnded){
		StopTimer(Chaos_RandomSlap_Timer);
		// cvar("sv_falldamage_scale", "1");
		if(g_NoFallDamage > 0) g_NoFallDamage--; //TODO:
}

// public Action Chaos_GhostSlaps_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_GhostSlaps_HasNoDuration(){
	return false;
}

public bool Chaos_GhostSlaps_Conditions(){
	return true;
}


float g_maxRange = 750.0;
float g_minRange = -750.0;
Action Timer_RandomSlap(Handle timer){
	//play sound? or do ghost slaps make no noise at all? { o.o }
	float vec[3];
	LoopAlivePlayers(client){
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vec);
		float x = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(-100.0, -1.0);
		float y = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(0.0, 50.0);
		float z = GetRandomFloat(g_minRange,g_maxRange) * GetRandomFloat(20.0, 50.0);
		vec[0] = vec[0]+x;
		vec[1] = vec[1]+y;
		vec[2] = vec[2]+z;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec); 
		CPrintToChat(client, "What was that?");
	}
}

