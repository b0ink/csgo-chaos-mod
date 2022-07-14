public void Chaos_TeleportFewMetres_START(){
	SavePlayersLocations();
	TeleportPlayersToClosestLocation(-1, 350); //250 units of minimum teleport distance
}

// public Action Chaos_TeleportFewMetres_RESET(bool EndChaos){

// }

// public Action Chaos_TeleportFewMetres_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_TeleportFewMetres_HasNoDuration(){
	return true;
}

public bool Chaos_TeleportFewMetres_Conditions(){
	return true;
}