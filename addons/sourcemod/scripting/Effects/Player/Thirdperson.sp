public void Chaos_Thirdperson_START(){
	cvar("sv_allow_thirdperson", "1");
	LoopAlivePlayers(i){
		ClientCommand(i, "thirdperson");
	}
}

public Action Chaos_Thirdperson_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		ClientCommand(i, "firstperson");
	}
	ResetCvar("sv_allow_thirdperson", "0", "1");
}