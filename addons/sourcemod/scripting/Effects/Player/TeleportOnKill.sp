bool TeleportOnKill = false;
public void Chaos_TeleportOnKill(effect_data effect){
	effect.Title = "Teleport On Kill";
	effect.Duration = 30;
}

public void Chaos_TeleportOnKill_INIT(){
	HookEvent("player_death", Chaos_TeleportOnKill_Event_PlayerDeath, EventHookMode_Pre);
}

public void Chaos_TeleportOnKill_START(){
	TeleportOnKill = true;
}


public void Chaos_TeleportOnKill_RESET(bool HasTimerEnded){
	TeleportOnKill = false;
}

public void Chaos_TeleportOnKill_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	int victim = GetClientOfUserId(event.GetInt("userid"));
	if(!TeleportOnKill || !IsValidClient(victim)) return;
	
	float location[3];
	GetClientAbsOrigin(victim, location);
	location[2] -= 64.0;
	
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if(ValidAndAlive(attacker)){
		TeleportEntity(attacker, location, NULL_VECTOR, NULL_VECTOR);
	}
}