#define EFFECTNAME InfiniteGrenades

SETUP(effect_data effect){
	effect.Title = "Infinite Grenades";
	effect.Duration = 30;
}

START(){
	cvar("sv_infinite_ammo", "2");
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_hegrenade");
		GivePlayerItem(i, "weapon_molotov");
		GivePlayerItem(i, "weapon_smokegrenade");
		GivePlayerItem(i, "weapon_flashbang");
	}
}

RESET(bool HasTimerEnded){
	ResetCvar("sv_infinite_ammo", "0", "2");
}