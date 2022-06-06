public void Chaos_Binoculars_START(){
	int RandomFOV = GetRandomInt(20,50);
	SetPlayersFOV(RandomFOV);

	Add_Overlay("/Chaos/binoculars.vtf");
}

public Action Chaos_Binoculars_RESET(bool EndChaos){
	ResetPlayersFOV();
	Remove_Overlay("/Chaos/binoculars.vtf");
}

public Action Chaos_Binoculars_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_Binoculars_HasNoDuration(){
	return false;
}

public bool Chaos_Binoculars_Conditions(){
	return true;
}

