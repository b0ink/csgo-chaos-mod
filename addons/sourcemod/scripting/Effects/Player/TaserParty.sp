//hook
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
	g_bTaserRound = true;
	cvar("mp_taser_recharge_time", "0.5");
	cvar("sv_party_mode", "1");
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GivePlayerItem(i, "weapon_taser");
			FakeClientCommand(i, "use weapon_taser");
		}
	}
}

public Action Chaos_TaserParty_RESET(bool EndChaos){
	ResetCvar("mp_taser_recharge_time", "-1", "0.5");
	ResetCvar("sv_party_mode", "0", "1");
	g_bTaserRound = false;
	if(EndChaos){
		for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i) && !HasMenuOpen(i)) ClientCommand(i, "slot2;slot1");
	}
}

// public Action Chaos_TaserParty_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_TaserParty_HasNoDuration(){
	return false;
}

public bool Chaos_TaserParty_Conditions(){
	return true;
}