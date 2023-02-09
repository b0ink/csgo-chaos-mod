#pragma semicolon 1

public void Chaos_InfiniteAmmo(EffectData effect){
	effect.Title = "Infinite Ammo";
	effect.Duration = 30;
	effect.AddFlag("ammo");
}

bool g_InfiniteAmmo = false;
public void Chaos_InfiniteAmmo_INIT(){
	HookEvent("weapon_fire", 		Chaos_InfiniteAmmo_Event_OnWeaponFire);
}

public void Chaos_InfiniteAmmo_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(g_InfiniteAmmo){
		int Slot1 = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
		int Slot2 = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);

		for(int i = 1; i <= 2; i++){
			int slot = -1;
			if(i == 1) slot = Slot1;
			if(i == 2) slot = Slot2;

			if(IsValidEntity(slot)){
				if(GetEntProp(slot, Prop_Data, "m_iState") == 2){
					int burst = GetEntProp(slot, Prop_Send, "m_bBurstMode") * 2;
					SetEntProp(slot, Prop_Data, "m_iClip1", GetEntProp(slot, Prop_Data, "m_iClip1")+1+burst);
					break;
				}
			}
		}

	}
}


public void Chaos_InfiniteAmmo_START(){
	g_InfiniteAmmo = true;
}

public void Chaos_InfiniteAmmo_RESET(int ResetType){
	g_InfiniteAmmo = false;
}