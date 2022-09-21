bool SneakyBeaky = false;

public void Chaos_SneakyBeaky(effect_data effect){
	effect.title = "Sneaky Beaky";
	effect.duration = 30;
}

public void Chaos_SneakyBeaky_START(){
	SneakyBeaky = true;
}

public Action Chaos_SneakyBeaky_RESET(bool HasTimerEnded){
	SneakyBeaky = false;
}

public Action Chaos_SneakyBeaky_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(SneakyBeaky){
		if (IsPlayerAlive(client)){
			if (buttons & IN_FORWARD ){
				fVel[0] = 130.0;
			}else if (buttons & IN_BACK){
				fVel[0] = -130.0;
			}else if (buttons & IN_MOVERIGHT){
				fVel[1] = 130.0;
			}else if(buttons & IN_MOVELEFT){
				fVel[1] = -130.0;
			}
		}
	}
}

public bool Chaos_SneakyBeaky_Conditions(){
	return true;
}