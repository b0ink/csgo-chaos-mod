bool g_bForceCrouch = false;
public void Chaos_CrabPeople(effect_data effect){
	effect.title = "Crab People";
	effect.duration = 30;
}
public void Chaos_CrabPeople_START(){
	g_bForceCrouch = true;
}

public Action Chaos_CrabPeople_RESET(bool HasTimerEnded){
	g_bForceCrouch = false;
}

public Action Chaos_CrabPeople_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_bForceCrouch) buttons |= IN_DUCK;
}