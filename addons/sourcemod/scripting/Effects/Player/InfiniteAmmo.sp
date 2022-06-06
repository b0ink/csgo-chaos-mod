//event weaponfire
bool g_InfiniteAmmo = false;
public void Chaos_InfiniteAmmo_INIT(){
	HookEvent("weapon_fire", Chaos_InfiniteAmmo_Event_OnWeaponFire);
}

public void Chaos_InfiniteAmmo_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	//todo doesnt work with glock burst fire for some reason
	if(g_InfiniteAmmo){
		int Slot1 = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
		int Slot2 = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
		if(IsValidEntity(Slot1)){
			if(GetEntProp(Slot1, Prop_Data, "m_iState") == 2){
				SetEntProp(Slot1, Prop_Data, "m_iClip1", GetEntProp(Slot1, Prop_Data, "m_iClip1")+1);
				return;
			}
		}
		if(IsValidEntity(Slot2)){
			if(GetEntProp(Slot2, Prop_Data, "m_iState") == 2){
				SetEntProp(Slot2, Prop_Data, "m_iClip1", GetEntProp(Slot2, Prop_Data, "m_iClip1") + 1);
				return;
			}
		}	
	}
}


public void Chaos_InfiniteAmmo_START(){
	g_InfiniteAmmo = true;
}

public Action Chaos_InfiniteAmmo_RESET(bool EndChaos){
		g_InfiniteAmmo = false;
}

public Action Chaos_InfiniteAmmo_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_InfiniteAmmo_HasNoDuration(){
	return false;
}

public bool _Conditions(){
	return true;
}