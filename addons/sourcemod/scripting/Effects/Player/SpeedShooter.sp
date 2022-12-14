bool SpeedShooter = false;

//TODO:, if someone has speed once this ends, they still have speed
// > try saving their old speed but itll still be fucky
SETUP(effect_data effect){
	effect.Title = "Speed Shooter";
	effect.Duration = 30;
	effect.AddFlag("movement");
}

START(){
	SpeedShooter = true;
}

RESET(bool HasTimerEnded){
	SpeedShooter = false;
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
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