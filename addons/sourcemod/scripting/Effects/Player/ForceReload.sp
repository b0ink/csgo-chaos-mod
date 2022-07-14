bool g_bForce_Reload[MAXPLAYERS+1];

public void Chaos_ForceReload_START(){

	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			int iTempWeapon = -1;
			if (GetEntPropEnt(i, Prop_Send, "m_hActiveWeapon") == GetPlayerWeaponSlot(i, CS_SLOT_PRIMARY)){
				if ((iTempWeapon = GetPlayerWeaponSlot(i, CS_SLOT_PRIMARY)) != -1) SetClip(iTempWeapon, 0, -1);
			}else if (GetEntPropEnt(i, Prop_Send, "m_hActiveWeapon") == GetPlayerWeaponSlot(i, CS_SLOT_SECONDARY)){
				if ((iTempWeapon = GetPlayerWeaponSlot(i, CS_SLOT_SECONDARY)) != -1) SetClip(iTempWeapon, 0, -1);
			}
			g_bForce_Reload[i] = true;
		}
	}

}

public Action Chaos_ForceReload_RESET(bool EndChaos){
	for(int i = 0; i <= MaxClients; i++) g_bForce_Reload[i] = false;
}

public Action Chaos_ForceReload_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if (g_bForce_Reload[client]) {
		buttons |= IN_RELOAD;
		g_bForce_Reload[client] = false;
	}
}


public bool Chaos_ForceReload_HasNoDuration(){
	return false;
}

public bool Chaos_ForceReload_Conditions(){
	return true;
}