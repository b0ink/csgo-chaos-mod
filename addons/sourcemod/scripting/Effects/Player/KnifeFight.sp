public void Chaos_KnifeFight(effect_data effect){
	effect.Title = "Knife Fight";
	effect.Duration = 30;
}



//TODO: Re-apply effect when player respawns

public void Chaos_KnifeFight_START(){
	HookBlockAllGuns();

	LoopAlivePlayers(i){
		FakeClientCommand(i, "use weapon_knife");
	}
}

public Action Chaos_KnifeFight_RESET(bool HasTimerEnded){

	UnhookBlockAllGuns();

	if(HasTimerEnded){ 
		LoopAlivePlayers(i){
			if(!HasMenuOpen(i)){
				ClientCommand(i, "slot1");
			}
		}
	}
}


public Action Chaos_KnifeFight_Hook_WeaponSwitch(int client, int weapon){
	return BlockAllGuns(client, weapon);	
}