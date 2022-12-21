#define EFFECTNAME HighMouseSens


bool HighMouseSens = false;
SETUP(effect_data effect){
	effect.Title = "High Mouse Sens";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_LockPlayersAim");
}

START(){
	HighMouseSens = true;
}

RESET(bool HasTimerEnded){
	HighMouseSens = false;
}

public Action Chaos_HighMouseSens_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if(HighMouseSens){
		if(mouse[0] != 0 || mouse[1] != 0){
			float newAngles[3];
			newAngles = fAngles;
			newAngles[0] += (mouse[1] / 1.5);
			newAngles[1] -= (mouse[0] * 1.5);
			TeleportEntity(client, NULL_VECTOR, newAngles, NULL_VECTOR);
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}