#define EFFECTNAME ReversedStrafe

bool ReversedStrafe = false;
SETUP(effect_data effect){
	effect.Title = "Reversed Strafe";
	effect.Duration = 30;
}

START(){
	ReversedStrafe = true;
}

RESET(bool HasTimerEnded){
	ReversedStrafe = false;
}

public Action Chaos_ReversedStrafe_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(ReversedStrafe){
		fVel[1] = -fVel[1];
	}
}