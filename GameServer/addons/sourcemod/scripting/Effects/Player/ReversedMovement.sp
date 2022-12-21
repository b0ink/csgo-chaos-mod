#define EFFECTNAME ReversedMovement

bool g_ReversedMovement = false;

SETUP(effect_data effect){
	effect.Title = "Reversed Movement";
	effect.Duration = 30;
}

START(){
	g_ReversedMovement = true;
}

RESET(bool HasTimerEnded){
	g_ReversedMovement = false;
}

public Action Chaos_ReversedMovement_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_ReversedMovement){
		fVel[1] = -fVel[1];
		fVel[0] = -fVel[0];
	}
}