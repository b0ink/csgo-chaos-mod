#define EFFECTNAME TeleportOnKill

bool TeleportOnKill = false;
SETUP(effect_data effect){
	effect.Title = "Teleport On Kill";
	effect.Duration = 30;
}

INIT(){
	HookEvent("player_death", Chaos_TeleportOnKill_Event_PlayerDeath, EventHookMode_Pre);
}

START(){
	TeleportOnKill = true;
}


RESET(bool HasTimerEnded){
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