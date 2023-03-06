#pragma semicolon 1

public void Chaos_DisableStrafe(EffectData effect){
	effect.Title = "Disable A / D Keys";
	effect.Duration = 30;
}

public void Chaos_DisableStrafe_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if(fVel[1] != 0.0){
		fVel[1] = 0.0;
	}
}