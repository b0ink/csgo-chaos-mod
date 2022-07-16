public void Chaos_NightVision_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GivePlayerItem(i, "item_nvgs");
			FakeClientCommand(i, "nightvision");
		}
	}
}

public Action Chaos_NightVision_RESET(bool HasTimerEnded){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			SetEntProp(i, Prop_Send, "m_bNightVisionOn", 0);
		}
	}
}

public Action Chaos_NightVision_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_NightVision_HasNoDuration(){
	return false;
}

public bool Chaos_NightVision_Conditions(){
	return true;
}