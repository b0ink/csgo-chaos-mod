#define EFFECTNAME ReducedDamage

bool ReducedDamage = false;

SETUP(effect_data effect){
	effect.Title = "Half Shot Damage"; 
	effect.Duration = 30;
	effect.AddAlias("HalfDamage");
	effect.AddAlias("ReduceDamage");
	effect.IncompatibleWith("Chaos_VampireHeal");
}

START(){
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_OnTakeDamage, Chaos_ReducedDamage_Hook_OnTakeDamage);
	}
	ReducedDamage = true;
}

RESET(bool HasTimerEnded){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_OnTakeDamage, Chaos_ReducedDamage_Hook_OnTakeDamage);
	}
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


CONDITIONS(){
	return true;
}
