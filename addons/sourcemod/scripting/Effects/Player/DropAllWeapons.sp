public void Chaos_DropAllWeapons(effect_data effect){
	effect.Title = "Drop All Weapons";
	effect.HasNoDuration = true;
	effect.AddFlag("dropweapon");
	effect.IncompatibleWith("Chaos_KnifeFight");
}

public void Chaos_DropAllWeapons_START(){
	LoopAlivePlayers(i){
		int weaponIndex;

		// drop all nades
		while((weaponIndex = GetPlayerWeaponSlot(i, CS_SLOT_GRENADE)) != -1){
				CS_DropWeapon(i, weaponIndex, true, true);
		}

		// drop weapons
		for (int x = 0; x <= 6; x++){
			if(x == CS_SLOT_KNIFE) continue;
			if ((weaponIndex = GetPlayerWeaponSlot(i, x)) != -1){
				CS_DropWeapon(i, weaponIndex, true, true);
			}
		} 
	}
}

public void Chaos_DropAllWeapons_RESET(bool HasTimerEnded){

}
