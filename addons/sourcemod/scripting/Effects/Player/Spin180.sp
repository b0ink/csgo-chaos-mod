public void Chaos_Spin180_START(){
	float angs[3];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientEyeAngles(i, angs);
			angs[1] = angs[1] + 180;
			TeleportEntity(i, NULL_VECTOR, angs, NULL_VECTOR);
		}
	}
}

// public Action Chaos_Spin180_RESET(bool HasTimerEnded){

// }

// public Action Chaos_Spin180_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

// }


public bool Chaos_Spin180_HasNoDuration(){
	return true;
}

public bool Chaos_Spin180_Conditions(){
	return true;
}