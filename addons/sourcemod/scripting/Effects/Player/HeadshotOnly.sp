public void Chaos_HeadshotOnly_START(){
	cvar("mp_damage_headshot_only", "1");
	//todo through SM
}

public Action Chaos_HeadshotOnly_RESET(bool EndChaos){
	ResetCvar("mp_damage_headshot_only", "0", "1");
}


public bool Chaos_HeadshotOnly_HasNoDuration(){
	return false;
}

public bool Chaos_HeadshotOnly_Conditions(){
	return true;
}