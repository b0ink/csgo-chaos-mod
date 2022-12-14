#define EFFECTNAME TaserParty

bool TaserParty = false;

SETUP(effect_data effect){
	effect.Title = "Taser Party";
	effect.Duration = 30;
	effect.AddFlag("dropweapon"); // prevent drop weapon effects from running
}

INIT(){
	HookEvent("weapon_fire", Chaos_TaserParty_Event_OnWeaponFire);
}

public void Chaos_TaserParty_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(TaserParty){
		char weapon[64];
		event.GetString("weapon", weapon, 64);
		if(StrEqual(weapon, "weapon_taser")){
			DoKnockback(client, -1000.0);
		}
	}
}

public Action Chaos_TaserParty_Hook_WeaponSwitch(int client, int weapon){
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(TaserParty){
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

START(){
	HookPreventWeaponDrop();
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_WeaponSwitch, Chaos_TaserParty_Hook_WeaponSwitch);
	}
	
	TaserParty = true;
	cvar("mp_taser_recharge_time", "0.5");
	cvar("sv_party_mode", "1");
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_taser");
		FakeClientCommand(i, "use weapon_taser");
	}
}

public void Chaos_TaserParty_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		HookPreventWeaponDrop(client);
		SDKHook(client, SDKHook_WeaponSwitch, Chaos_TaserParty_Hook_WeaponSwitch);
		GivePlayerItem(client, "weapon_taser");
		FakeClientCommand(client, "use weapon_taser");
	}
}

RESET(bool HasTimerEnded){
	UnhookPreventWeaponDrop();
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_WeaponSwitch, Chaos_TaserParty_Hook_WeaponSwitch);
	}

	ResetCvar("mp_taser_recharge_time", "-1", "0.5");
	ResetCvar("sv_party_mode", "0", "1");
	TaserParty = false;
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			if(!HasMenuOpen(i)){
				ClientCommand(i, "slot2;slot1");
			}
		}
	}
}