bool g_HealthRegen = false;
SETUP(effect_data effect){
	effect.Title = "Health Regen";
	effect.Duration = 30;
}

START(){
	g_HealthRegen = true;
	CreateTimer(1.0, Timer_GiveHealthRegen);
}

RESET(bool HasTimerEnded){
	g_HealthRegen = false;
}

public Action Timer_GiveHealthRegen(Handle timer){
	if(g_HealthRegen){
		int currenthealth = -1;
		LoopAlivePlayers(i){
			currenthealth = GetClientHealth(i);
			SetEntityHealth(i, currenthealth + 10);
		}
		CreateTimer(1.0, Timer_GiveHealthRegen);
	}
}

