//hook
//tood; buggy if you still have other nades?
bool g_bDecoyDodgeball = false;
Handle g_DecoyDodgeball_CheckDecoyTimer = INVALID_HANDLE;
public Action Chaos_DecoyDodgeball_Hook_WeaponSwitch(int client, int weapon){
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(g_bDecoyDodgeball){
		if(StrContains(WeaponName, "decoy") == -1 &&
			StrContains(WeaponName, "c4") == -1 &&
			StrContains(WeaponName, "flashbang") == -1){
			//this works without forcing the weapon
			// FakeClientCommand(client, "use weapon_decoy");
			return Plugin_Handled;
		}else{
			return Plugin_Continue;
		}
	}
	return Plugin_Continue;
}



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
	}
}


public void Chaos_DecoyDodgeball_START(){
	g_bDecoyDodgeball = true;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			StripPlayer(i, true, true, true); //strip grenades only
			GivePlayerItem(i, "weapon_decoy");
			FakeClientCommand(i, "use weapon_decoy");
			SetEntityHealth(i, 1);
		}
	}
	g_DecoyDodgeball_CheckDecoyTimer = CreateTimer(5.0, Timer_CheckDecoys, _, TIMER_REPEAT);

}

public Action Chaos_DecoyDodgeball_RESET(bool HasTimerEnded){
	if(g_bDecoyDodgeball && HasTimerEnded){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				StripPlayer(i, true, true, true); //strip grenades only
				SetEntityHealth(i, 100);
				if(!HasMenuOpen(i)){
					ClientCommand(i, "slot2");
					ClientCommand(i, "slot1");
				}
				// FakeClientCommand(i, "use weapon_knife");
			}
		}
	}
	g_bDecoyDodgeball = false;
	StopTimer(g_DecoyDodgeball_CheckDecoyTimer);
	delete g_DecoyDodgeball_CheckDecoyTimer;
}

public Action Chaos_DecoyDodgeball_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_DecoyDodgeball_HasNoDuration(){
	return false;
}

public bool Chaos_DecoyDodgeball_Conditions(){
	return true;
}




Action Timer_CheckDecoys(Handle timer){
	if(g_bDecoyDodgeball){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				bool hasDecoy = false;
				int wepID = -1;
				for(int slot = 0; slot < 7; slot++){
					if((wepID = GetPlayerWeaponSlot(i, slot)) != -1){
						char ClientWeaponName[64];
						GetWeaponClassname(wepID, ClientWeaponName, 64);
						if(IsValidEntity(wepID)){
							if(StrContains(ClientWeaponName, "weapon_decoy") != -1){
								hasDecoy = true;
							}
						} 
					}
				}
				if(!hasDecoy){
					GivePlayerItem(i, "weapon_decoy");
				}
			}
		}
	}
}
