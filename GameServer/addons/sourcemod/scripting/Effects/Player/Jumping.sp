#define EFFECTNAME Jumping

bool g_bJumping = false;
bool ForceJump[MAXPLAYERS+1];
SETUP(effect_data effect){
	effect.Title = "Jump Jump!";
	effect.Duration = 30;
}

START(){
	g_bJumping = true;
}

RESET(bool HasTimerEnded){
	g_bJumping = false;
}

public Action Chaos_Jumping_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_bJumping){
		ForceJump[client] = !ForceJump[client];
		if(ForceJump[client]){
			buttons |= IN_JUMP;
		}else{
			buttons &= ~IN_JUMP;
		}
	}
}

// once upon a time...

// public Action Timer_ForceJump(Handle timer){
// 	if(g_bJumping){
// 		for(int i = 0; i <= MaxClients; i++){
// 			if(ValidAndAlive(i)){
// 				float vec[3];
// 				GetEntPropVector(i, Prop_Data, "m_vecVelocity", vec);
// 				if(vec[2] == 0.0) { //ensure player isnt mid jump or falling down
// 					vec[0] = 0.0;
// 					vec[1] = 0.0;
// 					vec[2] = 300.0;
// 					SetEntPropVector(i, Prop_Data, "m_vecBaseVelocity", vec);
// 				}
// 			}
// 		}
// 	}else{
// 		StopTimer(g_Jumping_Timer_Repeat);
// 	}
// }
