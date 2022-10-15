Handle RandomWeapons_Timer_Repeat = INVALID_HANDLE;
float RandomWeapons_Interval = 5.0; //5+ recommended for bomb plants

public void Chaos_RandomWeapons(effect_data effect){
	effect.title = "Random Weapons";
	effect.duration = 30;
}

public void Chaos_RandomWeapons_START(){
	Timer_GiveRandomWeapon();
	RandomWeapons_Timer_Repeat = CreateTimer(RandomWeapons_Interval, Timer_GiveRandomWeapon, _, TIMER_REPEAT);
}

public Action Chaos_RandomWeapons_RESET(bool HasTimerEnded){
	StopTimer(RandomWeapons_Timer_Repeat);
}

Action Timer_GiveRandomWeapon(Handle timer = null){
	LoopAlivePlayers(i){
		int randomWeaponIndex = GetRandomInt(0,sizeof(g_sWeapons)-1);	
		GiveAndSwitchWeapon(i, g_sWeapons[randomWeaponIndex]);
	}
}
