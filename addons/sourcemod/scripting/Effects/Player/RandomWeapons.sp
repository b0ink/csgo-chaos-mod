Handle RandomWeapons_Timer_Repeat = INVALID_HANDLE;
float RandomWeapons_Interval = 5.0; //5+ recommended for bomb plants

SETUP(effect_data effect){
	effect.Title = "Random Weapons";
	effect.Duration = 30;
}

START(){
	Timer_GiveRandomWeapon();
	RandomWeapons_Timer_Repeat = CreateTimer(RandomWeapons_Interval, Timer_GiveRandomWeapon, _, TIMER_REPEAT);
}

RESET(bool HasTimerEnded){
	StopTimer(RandomWeapons_Timer_Repeat);
}

Action Timer_GiveRandomWeapon(Handle timer = null){
	LoopAlivePlayers(i){
		int randomWeaponIndex = GetURandomInt() % sizeof(g_sWeapons);	
		GiveAndSwitchWeapon(i, g_sWeapons[randomWeaponIndex]);
	}
}
