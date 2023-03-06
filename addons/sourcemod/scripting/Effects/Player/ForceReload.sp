#pragma semicolon 1

bool g_bForce_Reload[MAXPLAYERS+1];
public void Chaos_ForceReload(EffectData effect){
	effect.Title = "Force Reload";
	effect.HasNoDuration = true;
}


public void Chaos_ForceReload_START(){
	int iTempWeapon = -1;
	LoopAlivePlayers(i){
		if (GetEntPropEnt(i, Prop_Send, "m_hActiveWeapon") == GetPlayerWeaponSlot(i, CS_SLOT_PRIMARY)){
			if ((iTempWeapon = GetPlayerWeaponSlot(i, CS_SLOT_PRIMARY)) != -1) SetClip(iTempWeapon, 0, -1);
		}else if (GetEntPropEnt(i, Prop_Send, "m_hActiveWeapon") == GetPlayerWeaponSlot(i, CS_SLOT_SECONDARY)){
			if ((iTempWeapon = GetPlayerWeaponSlot(i, CS_SLOT_SECONDARY)) != -1) SetClip(iTempWeapon, 0, -1);
		}
		g_bForce_Reload[i] = true;
	}
}

public void Chaos_ForceReload_RESET(int ResetType){
	//* Automatically resets when reload is activated
	LoopAllClients(i){
		g_bForce_Reload[i] = false;
	}
}

public void Chaos_ForceReload_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if (g_bForce_Reload[client]) {
		buttons |= IN_RELOAD;
		g_bForce_Reload[client] = false;
	}
}