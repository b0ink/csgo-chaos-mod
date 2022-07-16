public void Chaos_Thirdperson_START(){
	cvar("sv_allow_thirdperson", "1");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)) ClientCommand(i, "thirdperson");
	}
}

public Action Chaos_Thirdperson_RESET(bool HasTimerEnded){
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) ClientCommand(i, "firstperson");
	ResetCvar("sv_allow_thirdperson", "0", "1");
}


public bool Chaos_Thirdperson_HasNoDuration(){
	return false;
}

public bool Chaos_Thirdperson_Conditions(){
	return true;
}