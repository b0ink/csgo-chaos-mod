public void Chaos_DisableForwardBack_START(){
	g_bNoForwardBack++;
}

public Action Chaos_DisableForwardBack_RESET(bool EndChaos){
	if(g_bNoForwardBack > 0) g_bNoForwardBack--;
}

public Action Chaos_DisableForwardBack_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_DisableForwardBack_HasNoDuration(){
	return false;
}

public bool Chaos_DisableForwardBack_Conditions(){
	return true;
}