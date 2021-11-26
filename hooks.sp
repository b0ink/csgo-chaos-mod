public Action Event_WeaponSwitch(int client, int weapon){
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(g_TaserRound){
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
	if(g_KnifeFight){
		if(StrContains(WeaponName, "knife") == -1 &&
			StrContains(WeaponName, "c4") == -1){
				FakeClientCommand(client, "use weapon_knife");
				return Plugin_Handled;
		}else{
			return Plugin_Continue;
		}
	}
	if(g_DecoyDodgeball){
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

//DISABLE WEAPON DROP DURING RANDOM WEAPON EVENT
public Action Event_WeaponDrop(int client,int weapon){
	// PrintToChatAll("trying preventing drop.");
	// if(g_RandomWeaponRound){
	if(weapon != -1){ //it happens
		if(!g_PlayersCanDropWeapon){
			// PrintToChatAll("preventing drop.");
			char WeaponName[32];
			GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
			if(StrContains(WeaponName, "c4") == -1){ //allow c4 drops
				// PrintToChatAll("prevented drop.");
				return Plugin_Handled; 
			}
		}
	}
	return Plugin_Continue;
} 


/*
	name = "NoScope", 
	author = "Bara", 
	description = "", 
	version = NOSCOPE_VERSION, 
	url = "www.bara.in"
*/
public Action OnPreThink(int client){
	int iWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	SetNoScope(iWeapon);
	return Plugin_Continue;
}
int m_flNextSecondaryAttack = -1;
public void NOSCOPE_INIT(){
	m_flNextSecondaryAttack = FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
}

stock void SetNoScope(int weapon){
	if (IsValidEdict(weapon) && g_NoscopeOnly){
		char classname[MAX_NAME_LENGTH];
		GetEdictClassname(weapon, classname, sizeof(classname));
		
		if (StrEqual(classname[7], "ssg08") || StrEqual(classname[7], "aug") || StrEqual(classname[7], "sg550") || StrEqual(classname[7], "sg552") || StrEqual(classname[7], "sg556") || StrEqual(classname[7], "awp") || StrEqual(classname[7], "scar20") || StrEqual(classname[7], "g3sg1"))
			SetEntDataFloat(weapon, m_flNextSecondaryAttack, GetGameTime() + 2.0);
	}
}

//allow players to take damage during noclip
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) {
	if(g_VampireRound){
		if(IsValidClient(victim) && IsValidClient(inflictor)){
			//todo; fix this its not working
			if(GetClientTeam(victim) != GetClientTeam(inflictor)){ //ensure opposite teams
				int health = GetEntProp(inflictor, Prop_Send, "m_iHealth");
				health = health + RoundFloat(damage);
				if(health > 100) health = 100;
				SetEntityHealth(inflictor, health);
			}
		}
	}

	if (IsValidClient(victim) && g_ActiveNoclip) SetEntityMoveType(victim, MOVETYPE_WALK);

	return Plugin_Continue;
}
public Action OnTakeDamagePost(int victim, int attacker){
    if (IsValidClient(victim) && g_ActiveNoclip) SetEntityMoveType(victim, MOVETYPE_NOCLIP);
}
