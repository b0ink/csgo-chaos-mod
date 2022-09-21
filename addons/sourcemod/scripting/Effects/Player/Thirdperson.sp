public void Chaos_Thirdperson(effect_data effect){
	effect.title = "Thirdperson";
	effect.duration = 30;
}

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