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


public bool Chaos_InfiniteGrenades_HasNoDuration(){
	return false;
}

public bool Chaos_InfiniteGrenades_Conditions(){
	return true;
}