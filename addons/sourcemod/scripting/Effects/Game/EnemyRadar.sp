public void Chaos_EnemyRadar_START(){
	cvar("mp_radar_showall", "1");
}

public Action Chaos_EnemyRadar_RESET(bool EndChaos){
	ResetCvar("mp_radar_showall", "0", "1");
}

public bool Chaos_EnemyRadar_HasNoDuration(){
	return false;
}

public bool Chaos_EnemyRadar_Conditions(){
	return true;
}