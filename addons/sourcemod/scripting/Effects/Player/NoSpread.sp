public void Chaos_NoRecoil_START(){
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0");
}

public Action Chaos_NoRecoil_RESET(bool EndChaos){
	ResetCvar("weapon_accuracy_nospread", "0", "1");
	ResetCvar("weapon_recoil_scale", "2", "0");
}

public Action Chaos_NoRecoil_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_NoRecoil_HasNoDuration(){
	return false;
}

public bool Chaos_NoRecoil_Conditions(){
	return true;
}


// weapon_accuracy_nospread "1";
// weapon_debug_spread_gap "1";
// weapon_recoil_cooldown "0";
// weapon_recoil_decay1_exp "99999";
// weapon_recoil_decay2_exp "99999";
// weapon_recoil_decay2_lin "99999";
// weapon_recoil_scale "0";
// weapon_recoil_suppression_shots "500";