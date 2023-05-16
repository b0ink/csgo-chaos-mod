#pragma semicolon 1

bool TaserParty = false;

public void Chaos_TaserParty(EffectData effect){
	effect.Title = "Taser Party";
	effect.Duration = 30;
	effect.AddFlag("dropweapon"); // prevent drop weapon effects from running
	effect.IncompatibleWith("Chaos_KnifeFight");
	effect.IncompatibleWith("Chaos_AlienModelKnife");
	effect.IncompatibleWith("Chaos_Boxing");
	effect.BlockInCoopStrike = true;
	
	HookEvent("weapon_fire", Chaos_TaserParty_Event_OnWeaponFire);
}

public void Chaos_TaserParty_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(TaserParty && !IsCoopStrike()){
		char weapon[64];
		event.GetString("weapon", weapon, 64);
		if(StrEqual(weapon, "weapon_taser")){
			DoKnockback(client, -1000.0);
		}
	}
}

public Action Chaos_TaserParty_Hook_WeaponSwitch(int client, int weapon){
	if(!IsValidClient(client)) return Plugin_Continue;
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(TaserParty){
		//if any other weapon than a taser or a knife, bring out taser
		if(	StrContains(WeaponName, "taser") == -1 && 	
			StrContains(WeaponName, "fist") == -1  && 
			// StrContains(WeaponName, "knife") == -1 &&
			StrContains(WeaponName, "c4") == -1    
			// StrContains(WeaponName, "grenade") == -1)
		){
			RequestFrame(Chaos_TaserParty_SwitchToTaser, client);
			return Plugin_Continue;
		}else{
			return Plugin_Continue;
		}
	}
	return Plugin_Continue;
}

public void Chaos_TaserParty_SwitchToTaser(int client){
	if(!ValidAndAlive(client)) return;
	FakeClientCommand(client, "use weapon_taser");
}


public void Chaos_TaserParty_START(){
	HookPreventWeaponDrop();
	LoopAlivePlayers(i){
		SDKUnhook(i, SDKHook_WeaponSwitchPost, Chaos_TaserParty_Hook_WeaponSwitch);
		SDKHook(i, SDKHook_WeaponSwitchPost, Chaos_TaserParty_Hook_WeaponSwitch);
	}
	
	TaserParty = true;
	cvar("mp_taser_recharge_time", "0.5");
	cvar("sv_party_mode", "1");
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_taser");
		FakeClientCommand(i, "use weapon_taser");
	}
}

public void Chaos_TaserParty_OnPlayerSpawn(int client){
	HookPreventWeaponDrop(client);
	SDKUnhook(client, SDKHook_WeaponSwitchPost, Chaos_TaserParty_Hook_WeaponSwitch);
	SDKHook(client, SDKHook_WeaponSwitchPost, Chaos_TaserParty_Hook_WeaponSwitch);
	GivePlayerItem(client, "weapon_taser");
	FakeClientCommand(client, "use weapon_taser");
}

public void Chaos_TaserParty_RESET(int ResetType){
	UnhookPreventWeaponDrop();
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_WeaponSwitchPost, Chaos_TaserParty_Hook_WeaponSwitch);
	}

	ResetCvar("mp_taser_recharge_time", "-1", "0.5");
	ResetCvar("sv_party_mode", "0", "1");
	TaserParty = false;
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			if(!HasMenuOpen(i)){
				SwitchToPrimaryWeapon(i);
			}
		}
	}
}

public bool Chaos_TaserParty_Conditions(){
	if(GetBotCount() > 0) return false;
	return true;
}