#pragma semicolon 1

public void Chaos_Thirdperson(effect_data effect){
	effect.Title = "Thirdperson";
	effect.Duration = 30;
}

public void Chaos_Thirdperson_START(){
	cvar("sv_allow_thirdperson", "1");
	LoopAlivePlayers(i){
		ClientCommand(i, "thirdperson");
	}
}

public void Chaos_Thirdperson_RESET(int ResetType){
	LoopAlivePlayers(i){
		ClientCommand(i, "firstperson");
	}
	ResetCvar("sv_allow_thirdperson", "0", "1");
}

public void Chaos_Thirdperson_OnPlayerSpawn(int client){
	ClientCommand(client, "thirdperson");
}