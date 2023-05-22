#pragma semicolon 1

public void Chaos_Shields(EffectData effect){
	effect.Title = "Shields";
	effect.HasNoDuration = true;
}

public void Chaos_Shields_START(){
	char playerWeapon[62];
	LoopAlivePlayers(i){
		GetClientWeapon(i, playerWeapon, sizeof(playerWeapon));
		int entity = CreateEntityByName("weapon_shield");
		// DispatchKeyValue(entity, "CanBePickedUp", "1");
		SDKHook(entity, SDKHook_Touch, OnShieldTouch);
		if (entity > 0) {
			EquipPlayerWeapon(i, entity);
			SetEntPropEnt(i, Prop_Data, "m_hActiveWeapon" , entity);
			if(StrContains(playerWeapon, "knife", false) != -1){
				SwitchToKnife(i);
				InstantSwitch(i, -1);
			}else{
				FakeClientCommand(i, "use %s", playerWeapon);
				InstantSwitch(i, -1);
			}
		}		
	}
}

public Action OnShieldTouch(int entity, int other){
	if(IsValidEntity(entity)){
		if(ValidAndAlive(other)){
			PrintToChatAll("%i %i", entity, other);
			if(PlayerHasWeapon(other, "weapon_shield") == -1){
				EquipPlayerWeapon(other, entity);
			}
		}
	}
	return Plugin_Handled;
}
