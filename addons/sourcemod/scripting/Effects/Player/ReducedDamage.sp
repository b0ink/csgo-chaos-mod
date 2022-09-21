bool ReducedDamage = false;

public void Chaos_ReducedDamage(effect_data effect){
	effect.title = "Half Shot Damage"; 
	effect.duration = 30;
	effect.AddAlias("HalfDamage");
	effect.AddAlias("ReduceDamage");
	effect.IncompatibleWith("Chaos_VampireHeal");
}

public void Chaos_ReducedDamage_START(){
    ReducedDamage = true;
}

public Action Chaos_ReducedDamage_RESET(bool HasTimerEnded){
    ReducedDamage = false;
}

public Action Chaos_ReducedDamage_Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype){
	if(ReducedDamage){
		if(ValidAndAlive(victim) && ValidAndAlive(inflictor)){
			if(GetClientTeam(victim) != GetClientTeam(inflictor)){
				damage = damage / 2.0;
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}


public bool Chaos_ReducedDamage_Conditions(){
	return true;
}
