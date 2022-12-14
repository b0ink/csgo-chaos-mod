SETUP(effect_data effect){
	effect.Title = "Thirdperson";
	effect.Duration = 30;
}

START(){
	cvar("sv_allow_thirdperson", "1");
	LoopAlivePlayers(i){
		ClientCommand(i, "thirdperson");
	}
}

RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		ClientCommand(i, "firstperson");
	}
	ResetCvar("sv_allow_thirdperson", "0", "1");
}

public void Chaos_Thirdperson_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		ClientCommand(client, "thirdperson");
	}
}