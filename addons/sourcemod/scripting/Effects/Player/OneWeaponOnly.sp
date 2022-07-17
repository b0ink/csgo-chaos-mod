public void Chaos_OneWeaponOnly_START(){
	//TODO:; might have to handle weapon pickups?.. (players can still buy)
	g_bPlayersCanDropWeapon = false;
	char randomWeapon[64];
	int randomIndex = GetRandomInt(0, sizeof(g_sWeapons)-1);
	randomWeapon = g_sWeapons[randomIndex];
	LoopAlivePlayers(i){
		StripPlayer(i);
		GivePlayerItem(i, randomWeapon);		
	}
	for(int i = 0; i < sizeof(randomWeapon); i++) randomWeapon[i] = CharToUpper(randomWeapon[i]);

	char chaosMsg[128];
	FormatEx(chaosMsg, sizeof(chaosMsg), "%s's Only", randomWeapon[7]); //strip weapon_ from name;
	// chaosMsg[0] = CharToUpper(chaosMsg[0]);
	AnnounceChaos(chaosMsg,  GetChaosTime("Chaos_OneWeaponOnly", 25.0));
	//TODO: translation;

}

public Action Chaos_OneWeaponOnly_RESET(bool HasTimerEnded){
	g_bPlayersCanDropWeapon = true;
}

// public Action Chaos_OneWeaponOnly_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_OneWeaponOnly_HasNoDuration(){
	return false;
}


public bool Chaos_OneWeaponOnly_CustomAnnouncement(){
	return true;
}

public bool Chaos_OneWeaponOnly_Conditions(){
	return true;
}