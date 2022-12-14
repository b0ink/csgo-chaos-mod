bool SneakyBeaky = false;

SETUP(effect_data effect){
	effect.Title = "Sneaky Beaky";
	effect.Duration = 30;
	effect.AddFlag("movement");
}

START(){
	SneakyBeaky = true;
}

RESET(bool HasTimerEnded){
	SneakyBeaky = false;
}

public Action Chaos_SneakyBeaky_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(SneakyBeaky){
		if (IsPlayerAlive(client)){
			if (buttons & IN_FORWARD ){
				fVel[0] = 120.0;
			}else if (buttons & IN_BACK){
				fVel[0] = -120.0;
			}else if (buttons & IN_MOVERIGHT){
				fVel[1] = 120.0;
			}else if(buttons & IN_MOVELEFT){
				fVel[1] = -120.0;
			}
			if(buttons & IN_FORWARD && (buttons & IN_MOVERIGHT)){
				fVel[0] = 80.0;
				fVel[1] = 80.0;
			}else if(buttons & IN_FORWARD && (buttons & IN_MOVELEFT)){
				fVel[0] = 80.0;
				fVel[1] = -80.0;
			}else if(buttons & IN_BACK && (buttons & IN_MOVERIGHT)){
				fVel[0] = -80.0;
				fVel[1] = 80.0;
			}else if(buttons & IN_BACK && (buttons & IN_MOVELEFT)){
				fVel[0] = -80.0;
				fVel[1] = -80.0;
			}
		}
	}
}

CONDITIONS(){
	return true;
}