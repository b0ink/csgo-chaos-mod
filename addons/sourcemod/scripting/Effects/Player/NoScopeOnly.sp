//TODO: if a player is scoping in during this effect, they cant scope back out unless switching weapon

//hook
bool g_bNoscopeOnly = false;
int m_flNextSecondaryAttack = -1;
public void Chaos_NoScopeOnly_INIT(){
	m_flNextSecondaryAttack = FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
}


stock void SetNoScope(int weapon){
	if (IsValidEdict(weapon) && g_bNoscopeOnly){
		char classname[MAX_NAME_LENGTH];
		GetEdictClassname(weapon, classname, sizeof(classname));
		
		if (StrEqual(classname[7], "ssg08") || StrEqual(classname[7], "aug") || StrEqual(classname[7], "sg550") || StrEqual(classname[7], "sg552") || StrEqual(classname[7], "sg556") || StrEqual(classname[7], "awp") || StrEqual(classname[7], "scar20") || StrEqual(classname[7], "g3sg1"))
			SetEntDataFloat(weapon, m_flNextSecondaryAttack, GetGameTime() + 2.0);
	}
}

public Action Chaos_NoScopeOnly_Hook_OnPreThink(int client){
	int iWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	SetNoScope(iWeapon);
	return Plugin_Continue;
}

public void Chaos_NoScopeOnly_START(){
	g_bNoscopeOnly = true;
}

public Action Chaos_NoScopeOnly_RESET(bool EndChaos){
	g_bNoscopeOnly = false;
}

public Action Chaos_NoScopeOnly_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_NoScopeOnly_HasNoDuration(){
	return false;
}

public bool Chaos_NoScopeOnly_Conditions(){
	return true;
}