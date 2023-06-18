#pragma semicolon 1

public void Chaos_FlingPlayer(EffectData effect) {
	effect.Title = "Fling Players";
	effect.HasNoDuration = true;
}

public void Chaos_FlingPlayer_START() {
	float vec[3];
	LoopAlivePlayers(client) {
		SDKHook(client, SDKHook_OnTakeDamage, FlingPlayer_OnTakeDamage);
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vec);
		float x = (GetRandomInt(0, 100) < 50) ? GetRandomFloat(-700.0, -500.0) : GetRandomFloat(500.0, 700.0);
		float y = (GetRandomInt(0, 100) < 50) ? GetRandomFloat(-700.0, -500.0) : GetRandomFloat(500.0, 700.0);
		float z = GetRandomFloat(500.0, 700.0);
		vec[0] = vec[0] + x;
		vec[1] = vec[1] + y;
		vec[2] = vec[2] + z;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec);
	}
	CreateTimer(3.0, Timer_DisableFlingPlayerNoDamage);
}

public Action Timer_DisableFlingPlayerNoDamage(Handle timer) {
	LoopValidPlayers(client) {
		SDKUnhook(client, SDKHook_OnTakeDamage, FlingPlayer_OnTakeDamage);
	}
	return Plugin_Stop;
}

public Action FlingPlayer_OnTakeDamage(int client, int &attacker, int &inflictor, float &damage, int &damagetype) {
	if(damagetype & DMG_FALL) return Plugin_Handled;
	return Plugin_Continue;
}