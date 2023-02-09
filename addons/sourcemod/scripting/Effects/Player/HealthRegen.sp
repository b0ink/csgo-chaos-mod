#pragma semicolon 1

bool g_HealthRegen = false;
public void Chaos_HealthRegen(EffectData effect){
	effect.Title = "Health Regen";
	effect.Duration = 30;
}

public void Chaos_HealthRegen_START(){
	g_HealthRegen = true;
	CreateTimer(1.0, Timer_GiveHealthRegen);
}

public void Chaos_HealthRegen_RESET(int ResetType){
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
	return Plugin_Continue;
}

