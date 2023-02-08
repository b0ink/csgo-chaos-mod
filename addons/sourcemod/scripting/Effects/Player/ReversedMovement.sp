#pragma semicolon 1

bool g_ReversedMovement = false;

public void Chaos_ReversedMovement(effect_data effect){
	effect.Title = "Reversed Movement";
	effect.Duration = 30;
}

public void Chaos_ReversedMovement_START(){
	g_ReversedMovement = true;
}

public void Chaos_ReversedMovement_RESET(int ResetType){
	g_ReversedMovement = false;
}

public void Chaos_ReversedMovement_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_ReversedMovement){
		fVel[1] = -fVel[1];
		fVel[0] = -fVel[0];
	}
}