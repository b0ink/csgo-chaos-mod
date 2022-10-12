public void Chaos_KnifeFight(effect_data effect){
	effect.title = "Knife Fight";
	effect.duration = 30;
}



public void Chaos_KnifeFight_START(){
	HookBlockAllGuns();

	// g_bKnifeFight++;
	LoopAlivePlayers(i){
		FakeClientCommand(i, "use weapon_knife");
	}
}

public Action Chaos_KnifeFight_RESET(bool HasTimerEnded){

	UnhookBlockAllGuns();

	// if(g_bKnifeFight > 0) g_bKnifeFight--;
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