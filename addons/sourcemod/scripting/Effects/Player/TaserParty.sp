public void Chaos_TaserParty(effect_data effect){
	effect.Title = "Taser Party";
	effect.Duration = 30;
}

public Action Chaos_TaserParty_Hook_WeaponSwitch(int client, int weapon){
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(g_bTaserRound){
		//if any other weapon than a taser or a knife, bring out taser
		if(	StrContains(WeaponName, "taser") == -1 && 
			StrContains(WeaponName, "knife") == -1 &&
			StrContains(WeaponName, "c4") == -1    &&
			StrContains(WeaponName, "grenade") == -1){
				FakeClientCommand(client, "use weapon_taser");
				return Plugin_Handled;
		}else{
			return Plugin_Continue;
		}
	}
	return Plugin_Continue;
}

public void Chaos_TaserParty_START(){
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_WeaponSwitch, Chaos_TaserParty_Hook_WeaponSwitch);
	}
	
	g_bTaserRound = true;
	cvar("mp_taser_recharge_time", "0.5");
	cvar("sv_party_mode", "1");
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_taser");
		FakeClientCommand(i, "use weapon_taser");
	}
}

public void Chaos_TaserParty_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SDKHook(client, SDKHook_WeaponSwitch, Chaos_TaserParty_Hook_WeaponSwitch);
		GivePlayerItem(client, "weapon_taser");
		FakeClientCommand(client, "use weapon_taser");
	}
}

public Action Chaos_TaserParty_RESET(bool HasTimerEnded){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_WeaponSwitch, Chaos_TaserParty_Hook_WeaponSwitch);
	}

	ResetCvar("mp_taser_recharge_time", "-1", "0.5");
	ResetCvar("sv_party_mode", "0", "1");
	g_bTaserRound = false;
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			if(!HasMenuOpen(i)){
				ClientCommand(i, "slot2;slot1");
			}
		}
	}
}