public void Chaos_RevealEnemyLocation_START(){
	ConVar radar = FindConVar("mp_radar_showall");

	if(radar.IntValue == 0){
		cvar("mp_radar_showall", "1");
		CreateTimer(0.2, Timer_ResetRadar); //use already made timer;
	}
}

public Action Timer_ResetRadar(Handle timer){
	cvar("mp_radar_showall", "0");
}

public Action Chaos_RevealEnemyLocation_RESET(bool HasTimerEnded){

}


public bool Chaos_RevealEnemyLocation_HasNoDuration(){
	return true;
}

public bool Chaos_RevealEnemyLocation_Conditions(){
	return true;
}