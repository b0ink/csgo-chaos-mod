#pragma semicolon 1

public void Chaos_SneakyBeaky(EffectData effect){
	effect.Title = "Sneaky Beaky";
	effect.Duration = 30;
	effect.AddFlag("movement");
}

public void Chaos_SneakyBeaky_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if (IsPlayerAlive(client)){
		if (buttons & IN_FORWARD ){
			vel[0] = 120.0;
		}else if (buttons & IN_BACK){
			vel[0] = -120.0;
		}else if (buttons & IN_MOVERIGHT){
			vel[1] = 120.0;
		}else if(buttons & IN_MOVELEFT){
			vel[1] = -120.0;
		}
		if(buttons & IN_FORWARD && (buttons & IN_MOVERIGHT)){
			vel[0] = 80.0;
			vel[1] = 80.0;
		}else if(buttons & IN_FORWARD && (buttons & IN_MOVELEFT)){
			vel[0] = 80.0;
			vel[1] = -80.0;
		}else if(buttons & IN_BACK && (buttons & IN_MOVERIGHT)){
			vel[0] = -80.0;
			vel[1] = 80.0;
		}else if(buttons & IN_BACK && (buttons & IN_MOVELEFT)){
			vel[0] = -80.0;
			vel[1] = -80.0;
		}
	}
}