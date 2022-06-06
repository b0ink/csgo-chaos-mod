bool g_bActiveNoclip = false;


public void Chaos_Flying_START(){
	g_bActiveNoclip = true;
	SavePlayersLocations();
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityMoveType(i, MOVETYPE_NOCLIP);
	cvar("sv_noclipspeed", "2");
}

public Action Chaos_Flying_RESET(bool EndChaos){
	if(EndChaos){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) SetEntityMoveType(i, MOVETYPE_WALK);
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


public bool Chaos_Flying_HasNoDuration(){
	return false;
}

public bool Chaos_Flying_Conditions(){
	return true;
}