#pragma semicolon 1

public void Chaos_CrabPeople(EffectData effect){
	effect.Title = "Crab People";
	effect.Duration = 30;
}

public void Chaos_CrabPeople_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	buttons |= IN_DUCK;
}