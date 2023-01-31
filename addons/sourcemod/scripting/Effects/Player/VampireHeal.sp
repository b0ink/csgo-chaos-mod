#pragma semicolon 1

public void Chaos_VampireHeal(effect_data effect){
	effect.Title = "Vampires";
	effect.Duration = 30;
}

bool g_bVampireRound = false;
public Action Chaos_VampireHeal_Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype){
	if(g_bVampireRound){
		if(IsClientInGame(victim) && IsClientInGame(inflictor)){
			if(GetClientTeam(victim) != GetClientTeam(inflictor)){ //ensure opposite teams
				int health = GetEntProp(inflictor, Prop_Send, "m_iHealth");
				health = health + RoundFloat(damage);
				if(health > 100) health = 100;
				SetEntityHealth(inflictor, health);
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}

public void Chaos_VampireHeal_START(){
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_OnTakeDamage, Chaos_VampireHeal_Hook_OnTakeDamage);
	}
	g_bVampireRound = true;
}

public void Chaos_VampireHeal_RESET(bool HasTimerEnded){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_OnTakeDamage, Chaos_VampireHeal_Hook_OnTakeDamage);
	}
	g_bVampireRound = false;
}