#define EFFECTNAME Flying

bool g_bActiveNoclip = false;
SETUP(effect_data effect){
	effect.Title = "Flying";
	effect.Duration = 15;
}

START(){
	g_bActiveNoclip = true;
	SavePlayersLocations();
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_OnTakeDamage, Chaos_Flying_Hook_OnTakeDamage);
		SDKHook(i, SDKHook_OnTakeDamagePost, Chaos_Flying_Hook_OnTakeDamagePost);
		SetEntityMoveType(i, MOVETYPE_NOCLIP);
	}
	cvar("sv_noclipspeed", "2");
}

public void Chaos_Flying_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SDKHook(client, SDKHook_OnTakeDamage, Chaos_Flying_Hook_OnTakeDamage);
		SDKHook(client, SDKHook_OnTakeDamagePost, Chaos_Flying_Hook_OnTakeDamagePost);
		CreateTimer(0.5, Timer_EnableFlying, client);
	}
}

public Action Timer_EnableFlying(Handle timer, int client){
	SetEntityMoveType(client, MOVETYPE_NOCLIP);
}

RESET(bool HasTimerEnded){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_OnTakeDamage, Chaos_Flying_Hook_OnTakeDamage);
		SDKUnhook(i, SDKHook_OnTakeDamagePost, Chaos_Flying_Hook_OnTakeDamagePost);
	}
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			SetEntityMoveType(i, MOVETYPE_WALK);
		}
		TeleportPlayersToClosestLocation();
	}
	ResetCvar("sv_noclipspeed", "5", "2");
	g_bActiveNoclip = false;	
}

public Action Chaos_Flying_Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) {
	if (IsValidClient(victim) && g_bActiveNoclip) SetEntityMoveType(victim, MOVETYPE_WALK);
}

public Action Chaos_Flying_Hook_OnTakeDamagePost(int victim, int attacker){
    if (IsValidClient(victim) && g_bActiveNoclip) SetEntityMoveType(victim, MOVETYPE_NOCLIP);
}	//ontake
