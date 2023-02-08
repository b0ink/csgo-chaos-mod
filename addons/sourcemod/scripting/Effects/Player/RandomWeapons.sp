#pragma semicolon 1

Handle RandomWeapons_Timer_Repeat = INVALID_HANDLE;
float RandomWeapons_Interval = 5.0; //5+ recommended for bomb plants

public void Chaos_RandomWeapons(effect_data effect){
	effect.Title = "Random Weapons";
	effect.Duration = 30;
}

public void Chaos_RandomWeapons_START(){
	Timer_GiveRandomWeapon();
	RandomWeapons_Timer_Repeat = CreateTimer(RandomWeapons_Interval, Timer_GiveRandomWeapon, _, TIMER_REPEAT);
}

public void Chaos_RandomWeapons_RESET(int ResetType){
	StopTimer(RandomWeapons_Timer_Repeat);
}

Action Timer_GiveRandomWeapon(Handle timer = null){
	LoopAlivePlayers(i){
		int randomWeaponIndex = GetURandomInt() % sizeof(g_sWeapons);	
		GiveAndSwitchWeapon(i, g_sWeapons[randomWeaponIndex]);
	}
	return Plugin_Continue;
}
