public void Chaos_InfiniteGrenades(effect_data effect){
	effect.title = "Infinite Grenades";
	effect.duration = 30;
}

public void Chaos_InfiniteGrenades_START(){
	cvar("sv_infinite_ammo", "2");
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_hegrenade");
		GivePlayerItem(i, "weapon_molotov");
		GivePlayerItem(i, "weapon_smokegrenade");
		GivePlayerItem(i, "weapon_flashbang");
	}
}

public Action Chaos_InfiniteGrenades_RESET(bool HasTimerEnded){
	ResetCvar("sv_infinite_ammo", "0", "2");
}