bool g_bRapidFire = false;
float g_RapidFire_Rate = 0.7;

public void Chaos_RapidFire_START(){
	g_bRapidFire = true;
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0.5");
}

public Action Chaos_RapidFire_RESET(bool EndChaos){
	ResetCvar("weapon_accuracy_nospread", "0", "1");
	ResetCvar("weapon_recoil_scale", "2", "0.5");
	g_bRapidFire = false;
}

public Action Chaos_RapidFire_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_bRapidFire){
		if (buttons & IN_ATTACK){
			int ent = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if (IsValidEntity(ent)){
				float time;
				float ETime = GetGameTime();
				time = (GetEntPropFloat(ent, Prop_Send, "m_flNextPrimaryAttack") - ETime) * g_RapidFire_Rate + ETime;
				SetEntPropFloat(ent, Prop_Send, "m_flNextPrimaryAttack", time);
			}
		}
		else if (buttons & IN_ATTACK2){
			int ent = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if (IsValidEntity(ent)){
				float time;
				float ETime = GetGameTime();
				time = (GetEntPropFloat(ent, Prop_Send, "m_flNextSecondaryAttack") - ETime) * g_RapidFire_Rate + ETime;
				SetEntPropFloat(ent, Prop_Send, "m_flNextSecondaryAttack", time);
			}
		}
	}
}


public bool Chaos_RapidFire_HasNoDuration(){
	return false;
}

public bool Chaos_RapidFire_Conditions(){
	return true;
}