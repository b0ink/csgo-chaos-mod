#pragma semicolon 1

public void Chaos_VampireHeal(EffectData effect){
	effect.Title = "Vampires";
	effect.Duration = 30;
}

bool g_bVampireRound = false;
public Action Chaos_VampireHeal_Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype){
	if(g_bVampireRound){
		if(IsValidClient(victim) && IsValidClient(inflictor)){
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
		PrintHintText(i, "By shooting your enemies, you can steal their health!");
		SDKHook(i, SDKHook_OnTakeDamage, Chaos_VampireHeal_Hook_OnTakeDamage);
	}
	g_bVampireRound = true;
}

public void Chaos_VampireHeal_RESET(int ResetType){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_OnTakeDamage, Chaos_VampireHeal_Hook_OnTakeDamage);
	}
	g_bVampireRound = false;
}