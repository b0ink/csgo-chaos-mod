public void Chaos_ExtendedGrenades_START(){
	cvar("ammo_grenade_limit_total", "7");
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

public void Chaos_ExtendedGrenades_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		ResetCvar("ammo_grenade_limit_total", "4", "7");
	}
}


public bool Chaos_ExtendedGrenades_HasNoDuration(){
	return true;
}

public bool Chaos_ExtendedGrenades_Conditions(){
	return true;
}
