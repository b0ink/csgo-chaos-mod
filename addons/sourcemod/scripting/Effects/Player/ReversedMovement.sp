bool g_ReversedMovement = false;

public void Chaos_ReversedMovement_START(){
	g_ReversedMovement = true;
}

public Action Chaos_ReversedMovement_RESET(bool EndChaos){
	g_ReversedMovement = false;
}

//use this method to only do reversed strafes / swap A /D or W / S Keys
public Action Chaos_ReversedMovement_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_ReversedMovement){
		fVel[1] = -fVel[1];
		fVel[0] = -fVel[0];
	}
}


// public void Chaos_ReversedMovement_ADDEFFECT(){
// 	effect new_effect;

// 	new_effect.SET_NAME("Reversed Movement");
// 	new_effect.SET_CONFIG_NAME("Chaos_ReversedMovement");

// 	new_effect.SET_START_FUNCTION("Chaos_ReversedMovement_START");
// 	new_effect.SET_RESET_FUNCTION("Chaos_ReversedMovement_RESET");
// 	new_effect.SET_DEFAULT_DURATION(10);

// 	Add_Effect(new_effect);
// }