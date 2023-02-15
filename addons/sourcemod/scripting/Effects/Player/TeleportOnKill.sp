#pragma semicolon 1

bool TeleportOnKill = false;
public void Chaos_TeleportOnKill(EffectData effect){
	effect.Title = "Teleport On Kill";
	effect.Duration = 30;
}

public void Chaos_TeleportOnKill_INIT(){
	HookEvent("player_death", Chaos_TeleportOnKill_Event_PlayerDeath, EventHookMode_Pre);
}

public void Chaos_TeleportOnKill_START(){
	TeleportOnKill = true;
}

public void Chaos_TeleportOnKill_RESET(int ResetType){
	TeleportOnKill = false;
}


public void Chaos_TeleportOnKill_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	int victim = GetClientOfUserId(event.GetInt("userid"));
	if(!TeleportOnKill || !IsValidClient(victim)) return;
	
	float location[3];
	GetClientAbsOrigin(victim, location);
	if(GetClientButtons(victim) & IN_DUCK){
		location[2] -= 45.0;
	}else{
		location[2] -= 60.0;
	}
	
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if(ValidAndAlive(attacker)){
		float pos[3];
		GetClientAbsOrigin(attacker, pos);
		LerpToPoint(attacker, pos, location, 0.1, true);
	}
}