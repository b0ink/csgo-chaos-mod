#pragma semicolon 1

public void Chaos_ExtendedGrenades(effect_data effect){
	effect.Title = "Extended Grenades";
	effect.HasNoDuration = true;
}

public void Chaos_ExtendedGrenades_START(){
	cvar("ammo_grenade_limit_total", "8");
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_hegrenade");
		GivePlayerItem(i, "weapon_molotov");
		GivePlayerItem(i, "weapon_flashbang");
		GivePlayerItem(i, "weapon_flashbang");
		GivePlayerItem(i, "weapon_smokegrenade");
		GivePlayerItem(i, "weapon_snowball");
		GivePlayerItem(i, "weapon_snowball");
		GivePlayerItem(i, "weapon_snowball");
		GivePlayerItem(i, "weapon_decoy");
		GivePlayerItem(i, "weapon_tagrenade");
	}
}

public void Chaos_ExtendedGrenades_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		ResetCvar("ammo_grenade_limit_total", "4", "8");
	}
}