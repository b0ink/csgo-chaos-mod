#define EFFECTNAME Shields

SETUP(effect_data effect){
	effect.Title = "Shields";
	effect.HasNoDuration = true;
}

START(){
	char playerWeapon[62];
	LoopAlivePlayers(i){
		GetClientWeapon(i, playerWeapon, sizeof(playerWeapon));
		int entity = CreateEntityByName("weapon_shield");
		if (entity > 0) {
			EquipPlayerWeapon(i, entity);
			SetEntPropEnt(i, Prop_Data, "m_hActiveWeapon" , entity);
			if(StrContains(playerWeapon, "knife", false) != -1){
				FakeClientCommand(i, "use weapon_knife");
				InstantSwitch(i, -1);
			}else{
				FakeClientCommand(i, "use %s", playerWeapon);
				InstantSwitch(i, -1);
			}
		}		
	}
}