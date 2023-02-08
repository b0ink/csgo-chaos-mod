#pragma semicolon 1

public void Chaos_OneWeaponOnly(effect_data effect){
	effect.Title = "One Weapon Only";
	effect.Duration = 30;
	effect.HasNoDuration = false;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_EffectName");
}

public void Chaos_OneWeaponOnly_START(){
	//TODO:; might have to handle weapon pickups?.. (players can still buy)
	char randomWeapon[64];
	int randomIndex = GetURandomInt() % sizeof(g_sWeapons);

	randomWeapon = g_sWeapons[randomIndex];
	LoopAlivePlayers(i){
		StripPlayer(i);
		GivePlayerItem(i, randomWeapon);		
	}
	for(int i = 0; i < sizeof(randomWeapon); i++) randomWeapon[i] = CharToUpper(randomWeapon[i]);

	char chaosMsg[128];
	FormatEx(chaosMsg, sizeof(chaosMsg), "Give %s's", randomWeapon[7]); //strip weapon_ from name;
	// chaosMsg[0] = CharToUpper(chaosMsg[0]);
	AnnounceChaos(chaosMsg,  GetChaosTime("Chaos_OneWeaponOnly", 25.0));

}

public void Chaos_OneWeaponOnly_RESET(int ResetType){

}