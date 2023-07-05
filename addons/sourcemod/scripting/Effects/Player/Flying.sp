#pragma semicolon 1

bool g_bActiveNoclip = false;
public void Chaos_Flying(EffectData effect){
	effect.Title = "Flying";
	effect.Duration = 10;
	effect.BlockInCoopStrike = true;
}

public void Chaos_Flying_START(){
	g_bActiveNoclip = true;
	SavePlayersLocations();
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_OnTakeDamage, Chaos_Flying_Hook_OnTakeDamage);
		SDKHook(i, SDKHook_OnTakeDamagePost, Chaos_Flying_Hook_OnTakeDamagePost);
		SetEntityMoveType(i, MOVETYPE_NOCLIP);
	}
	cvar("sv_noclipspeed", "2");
}

public void Chaos_Flying_OnPlayerSpawn(int client){
	SDKHook(client, SDKHook_OnTakeDamage, Chaos_Flying_Hook_OnTakeDamage);
	SDKHook(client, SDKHook_OnTakeDamagePost, Chaos_Flying_Hook_OnTakeDamagePost);
	CreateTimer(0.5, Timer_EnableFlying, client);
}

Action Timer_EnableFlying(Handle timer, int client){
	SetEntityMoveType(client, MOVETYPE_NOCLIP);
	return Plugin_Continue;
}

public void Chaos_Flying_RESET(int ResetType){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_OnTakeDamage, Chaos_Flying_Hook_OnTakeDamage);
		SDKUnhook(i, SDKHook_OnTakeDamagePost, Chaos_Flying_Hook_OnTakeDamagePost);
	}
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			SetEntityMoveType(i, MOVETYPE_WALK);
		}
		TeleportPlayersToClosestLocation();
		ResetCvar("sv_noclipspeed", "5", "2");
	}
	g_bActiveNoclip = false;	
}

public Action Chaos_Flying_Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) {
	if (IsValidClient(victim) && g_bActiveNoclip) SetEntityMoveType(victim, MOVETYPE_WALK);
	return Plugin_Continue;
}

public Action Chaos_Flying_Hook_OnTakeDamagePost(int victim, int attacker){
	if (IsValidClient(victim) && g_bActiveNoclip) SetEntityMoveType(victim, MOVETYPE_NOCLIP);
	return Plugin_Continue;
}
