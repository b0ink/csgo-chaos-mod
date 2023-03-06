#pragma semicolon 1

public void Chaos_DisableForwardBack(EffectData effect){
	effect.Title = "Disable W / S Keys";
	effect.Duration = 30;
}

public void Chaos_DisableForwardBack_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if(fVel[0] != 0.0){
		fVel[0] = 0.0;
	}
}