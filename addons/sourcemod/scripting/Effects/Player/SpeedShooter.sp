bool SpeedShooter = false;

//TODO: Create a stringmap of speeds, gravity, etc. take the latest added one, once the effect ends find te id and remove it from there
//? perhaps a timer that checks every second what the speed should be?


//TODO:, if someone has speed once this ends, they still have speed
// > try saving their old speed but itll still be fucky

public void Chaos_SpeedShooter_START(){
	SpeedShooter = true;
}

public Action Chaos_SpeedShooter_RESET(bool EndChaos){
	SpeedShooter = false;
	if(EndChaos){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			}
		}
	}
}

public Action Chaos_SpeedShooter_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(SpeedShooter && buttons & IN_ATTACK){
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 5.0);
	}else if(SpeedShooter){
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
}


public bool Chaos_SpeedShooter_HasNoDuration(){
	return false;
}

public bool Chaos_SpeedShooter_Conditions(){
	return true;
}