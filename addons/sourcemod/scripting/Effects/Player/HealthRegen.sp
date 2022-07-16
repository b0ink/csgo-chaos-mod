bool g_HealthRegen = false;
public void Chaos_HealthRegen_START(){
	g_HealthRegen = true;
	CreateTimer(1.0, Timer_GiveHealthRegen);
}

public Action Chaos_HealthRegen_RESET(bool HasTimerEnded){
	g_HealthRegen = false;
}

public bool Chaos_HealthRegen_HasNoDuration(){
	return false;
}

public bool Chaos_HealthRegen_Conditions(){
	return true;
}


public Action Timer_GiveHealthRegen(Handle timer){
	if(g_HealthRegen){
		int currenthealth = -1;
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				currenthealth = GetClientHealth(i);
				SetEntityHealth(i, currenthealth + 10);
			}
		}
		CreateTimer(1.0, Timer_GiveHealthRegen);
	}
}

