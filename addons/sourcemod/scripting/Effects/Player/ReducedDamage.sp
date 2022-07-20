bool ReducedDamage = false;

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
			}
		}
	}
}


public bool Chaos_ReducedDamage_Conditions(){
	return true;
}
