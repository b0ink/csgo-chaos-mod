#pragma semicolon 1

public void Chaos_DecoyDodgeball(EffectData effect){
	effect.Title = "Decoy Dodgeball";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_Thunderstorm");
	effect.IncompatibleWith("Chaos_Boxing");
	effect.IncompatibleWith("Chaos_OHKO");
	effect.IncompatibleWith("Chaos_HealthRegen");
	effect.IncompatibleWith("Chaos_Give100HP");
	effect.IncompatibleWith("Chaos_HealAllPlayers");
	effect.IncompatibleWith("Chaos_IgniteAllPlayers");
} 

//hook
//tood; buggy if you still have other nades?
bool g_bDecoyDodgeball = false;
Handle g_DecoyDodgeball_CheckDecoyTimer = INVALID_HANDLE;
public Action Chaos_DecoyDodgeball_Hook_WeaponSwitch(int client, int weapon){
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(g_bDecoyDodgeball){
		if(StrContains(WeaponName, "decoy") == -1 &&
			StrContains(WeaponName, "c4") == -1
			&& StrContains(WeaponName, "flashbang") == -1
			){
			// RequestFrame(SwitchToDecoy, client);
			return Plugin_Handled;
		}else{
			return Plugin_Continue;
		}
	}
	return Plugin_Continue;
}

// public void SwitchToDecoy(int client){
// 	return;
// 	if(ValidAndAlive(client)){
// 		if(!PlayerHasWeapon(client, "weapon_decoy")){
// 			GivePlayerItem(client, "weapon_decoy");
// 		}
// 		FakeClientCommand(client, "use weapon_decoy");
// 	}
// }


public void Chaos_DecoyDodgeball_OnEntityCreated(int ent, const char[] classname){
	if (g_bDecoyDodgeball) {
		if (StrContains(classname, "decoy_projectile") != -1) {
			SDKHook(ent, SDKHook_SpawnPost, HookOnDecoySpawn);
		}
	}
}


public void HookOnDecoySpawn(int iGrenade) {
	int client = GetEntPropEnt(iGrenade, Prop_Send, "m_hOwnerEntity");
	if (ValidAndAlive(client)) {
		int nadeslot = GetPlayerWeaponSlot(client, 3);
		if (nadeslot > 0) {
			RemovePlayerItem(client, nadeslot);
			RemoveEntity(nadeslot);
		}
		GivePlayerItem(client, "weapon_decoy");
		FakeClientCommand(client, "use weapon_decoy");
	}
}


public void Chaos_DecoyDodgeball_START(){
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_WeaponSwitch, Chaos_DecoyDodgeball_Hook_WeaponSwitch);
	}

	g_bDecoyDodgeball = true;
	LoopAlivePlayers(i){
		SetDecoyDodgeball(i);
	}
	g_DecoyDodgeball_CheckDecoyTimer = CreateTimer(5.0, Timer_CheckDecoys, _, TIMER_REPEAT);
}

void SetDecoyDodgeball(int client){
		StripPlayer(
			.client=client,
			.knife=true,
			.keepBomb=true,
			.stripGrenadesOnly=true
		);
		GivePlayerItem(client, "weapon_decoy");
		FakeClientCommand(client, "use weapon_decoy");
		SetEntityHealth(client, 1);	
}


public void Chaos_DecoyDodgeball_OnPlayerSpawn(int client){
	SDKHook(client, SDKHook_WeaponSwitch, Chaos_DecoyDodgeball_Hook_WeaponSwitch);
	SetDecoyDodgeball(client);
}

public void Chaos_DecoyDodgeball_RESET(int ResetType){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_WeaponSwitch, Chaos_DecoyDodgeball_Hook_WeaponSwitch);
	}
	
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			SetEntityHealth(i, 100);
			if(!HasMenuOpen(i)){
				SwitchToPrimaryWeapon(i);
			}
		}
	}
	g_bDecoyDodgeball = false;
	StopTimer(g_DecoyDodgeball_CheckDecoyTimer);
	delete g_DecoyDodgeball_CheckDecoyTimer;
}

Action Timer_CheckDecoys(Handle timer){
	if(g_bDecoyDodgeball){
		LoopAlivePlayers(i){
			if(!PlayerHasWeapon(i, "weapon_decoy")){
				GivePlayerItem(i, "weapon_decoy");
			}
			FakeClientCommand(i, "use weapon_decoy");

		}
	}
	return Plugin_Continue;
}
