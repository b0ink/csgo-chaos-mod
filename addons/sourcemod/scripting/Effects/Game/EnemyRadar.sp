public void Chaos_EnemyRadar_START(){
	cvar("mp_radar_showall", "1");
}

public Action Chaos_EnemyRadar_RESET(bool HasTimerEnded){
	ResetCvar("mp_radar_showall", "0", "1");
}