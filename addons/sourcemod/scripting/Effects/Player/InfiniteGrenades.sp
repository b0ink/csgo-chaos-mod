#pragma semicolon 1

public void Chaos_InfiniteGrenades(EffectData effect){
	effect.Title = "Infinite Grenades";
	effect.Duration = 30;
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

public void Chaos_InfiniteGrenades_RESET(int ResetType){
	ResetCvar("sv_infinite_ammo", "0", "2");
}