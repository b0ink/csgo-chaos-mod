#define EFFECTNAME Autobhop

int 	g_AutoBunnyhop = 0;

SETUP(effect_data effect){
	effect.Title = "Are you feeling funky?";
	effect.Duration = 30;
	effect.AddAlias("Funky");
	effect.AddAlias("Bunnyhop");
	effect.AddAlias("Autohop");
}

START(){
	g_AutoBunnyhop++;
	cvar("sv_airaccelerate", "1999");

}

RESET(bool HasTimerEnded){
	ResetCvar("sv_airaccelerate", "12", "1999");
	if(g_AutoBunnyhop > 0) g_AutoBunnyhop--;
}

float funky_Velocity[3];
public Action Chaos_Autobhop_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_AutoBunnyhop > 0){
		if(ValidAndAlive(client) && GetEntityFlags(client) & FL_ONGROUND && buttons & IN_JUMP){
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", funky_Velocity);
			// funky_Velocity[2] = 282.0;
			funky_Velocity[2] = 300.0;
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, funky_Velocity);
		}
	}
}