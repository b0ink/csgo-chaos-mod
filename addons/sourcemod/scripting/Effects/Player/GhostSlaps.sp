#define EFFECTNAME GhostSlaps

Handle Chaos_RandomSlap_Timer = INVALID_HANDLE;
float g_Chaos_RandomSlap_Interval = 7.0;

SETUP(effect_data effect){
	effect.Title = "Ghost Slaps";
	effect.Duration = 30;
}

START(){
	Chaos_RandomSlap_Timer = CreateTimer(g_Chaos_RandomSlap_Interval, Timer_RandomSlap, _,TIMER_REPEAT);
	LoopValidPlayers(client){
		SDKHook(client,SDKHook_OnTakeDamage, GhostSlaps_OnTakeDamage);
	}
}

RESET(bool HasTimerEnded){
	StopTimer(Chaos_RandomSlap_Timer);
	if(HasTimerEnded){
		LoopValidPlayers(client){
			SDKUnhook(client,SDKHook_OnTakeDamage, GhostSlaps_OnTakeDamage);
		}
	}
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


public Action GhostSlaps_OnTakeDamage(int client, int &attacker, int &inflictor, float &damage, int &damagetype) {
	if(Chaos_RandomSlap_Timer == INVALID_HANDLE) return Plugin_Continue;
	if (damagetype & DMG_FALL) return Plugin_Handled;
	return Plugin_Continue;
}