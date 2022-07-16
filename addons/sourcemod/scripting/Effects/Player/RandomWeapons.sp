Handle RandomWeapons_Timer_Repeat = INVALID_HANDLE;
float RandomWeapons_Interval = 5.0; //5+ recommended for bomb plants

public void Chaos_RandomWeapons_START(){
	Timer_GiveRandomWeapon();
	RandomWeapons_Timer_Repeat = CreateTimer(RandomWeapons_Interval, Timer_GiveRandomWeapon, _, TIMER_REPEAT);
}

public Action Chaos_RandomWeapons_RESET(bool HasTimerEnded){
	g_bPlayersCanDropWeapon = true;
	StopTimer(RandomWeapons_Timer_Repeat);
}


public bool Chaos_RandomWeapons_HasNoDuration(){
	return false;
}

public bool Chaos_RandomWeapons_Conditions(){
	return true;
}

Action Timer_GiveRandomWeapon(Handle timer = null){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			int randomWeaponIndex = GetRandomInt(0,sizeof(g_sWeapons)-1);	
			GiveAndSwitchWeapon(i, g_sWeapons[randomWeaponIndex]);
		}
	}
}
