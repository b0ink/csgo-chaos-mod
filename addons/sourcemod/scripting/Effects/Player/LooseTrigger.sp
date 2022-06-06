bool g_bLoose_Trigger = false;
bool ShouldAttack[MAXPLAYERS+1];

public void Chaos_LooseTrigger_START(){
	g_bLoose_Trigger = true;
}

public Action Chaos_LooseTrigger_RESET(bool EndChaos){
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

/*
	- Take all effects from the config
		-> when parsing config create structs for them
	- when using ADDEFFECT function, pass in the struct
		-> add names, description, etc. to the struct

	-> can replace the Chaos_Effects stringmap

	->description done through config
	-> name as well?
 */

public bool Chaos_LooseTrigger_Conditions(){

	return true;
}