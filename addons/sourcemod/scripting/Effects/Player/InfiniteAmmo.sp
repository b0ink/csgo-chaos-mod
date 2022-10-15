//event weaponfire

public void Chaos_InfiniteAmmo(effect_data effect){
	effect.Title = "Infinite Ammo";
	effect.Duration = 30;
}

bool g_InfiniteAmmo = false;
public void Chaos_InfiniteAmmo_INIT(){
	HookEvent("weapon_fire", 		Chaos_InfiniteAmmo_Event_OnWeaponFire);
}

public void Chaos_InfiniteAmmo_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	//TODO: doesnt work with glock burst fire for some reason
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

public Action Chaos_InfiniteAmmo_RESET(bool HasTimerEnded){
		g_InfiniteAmmo = false;
}