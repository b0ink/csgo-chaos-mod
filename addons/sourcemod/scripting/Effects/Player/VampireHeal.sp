public void Chaos_VampireHeal(effect_data effect){
	effect.title = "Vampires";
	effect.duration = 30;
}

bool g_bVampireRound = false;
public Action Chaos_VampireHeal_Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype){
	if(g_bVampireRound){
		if(IsValidClient(victim) && IsValidClient(inflictor)){
			//TODO:; fix this its not working
			if(GetClientTeam(victim) != GetClientTeam(inflictor)){ //ensure opposite teams
				int health = GetEntProp(inflictor, Prop_Send, "m_iHealth");
				health = health + RoundFloat(damage);
				if(health > 100) health = 100;
				SetEntityHealth(inflictor, health);
			}
		}
	}
}

public void Chaos_VampireHeal_START(){
	g_bVampireRound = true;
}

public Action Chaos_VampireHeal_RESET(bool HasTimerEnded){
	g_bVampireRound = false;
}