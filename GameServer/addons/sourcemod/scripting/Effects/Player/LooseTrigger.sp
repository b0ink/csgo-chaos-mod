#define EFFECTNAME LooseTrigger

bool g_bLoose_Trigger = false;
bool ShouldAttack[MAXPLAYERS+1];

SETUP(effect_data effect){
	effect.Title = "Loose Trigger";
	effect.Duration = 10;
	effect.OverrideDuration = true; //TODO: add a min-max duration property, server owner should be able to reduce this to 5seconds instead of 10sec lock
}
START(){
	g_bLoose_Trigger = true;
}

RESET(bool HasTimerEnded){
	g_bLoose_Trigger = false;
}

public Action Chaos_LooseTrigger_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if (g_bLoose_Trigger) {
		ShouldAttack[client] = !ShouldAttack[client];
		if(ShouldAttack[client]){
			buttons &= ~IN_ATTACK;
		}else{
			buttons |= IN_ATTACK;
		}
	}
}