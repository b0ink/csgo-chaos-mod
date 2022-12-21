#define EFFECTNAME CrabPeople

bool g_bForceCrouch = false;
SETUP(effect_data effect){
	effect.Title = "Crab People";
	effect.Duration = 30;
}
START(){
	g_bForceCrouch = true;
}

RESET(bool HasTimerEnded){
	g_bForceCrouch = false;
}

public Action Chaos_CrabPeople_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_bForceCrouch) buttons |= IN_DUCK;
}