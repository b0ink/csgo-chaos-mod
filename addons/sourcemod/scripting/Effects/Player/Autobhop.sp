#pragma semicolon 1

int 	g_AutoBunnyhop = 0;

public void Chaos_Autobhop(EffectData effect){
	effect.Title = "Phoon";
	effect.Duration = 30;
	effect.AddAlias("Funky");
	effect.AddAlias("Bunnyhop");
	effect.AddAlias("Autohop");
}

public void Chaos_Autobhop_OnMapStart(){
	AddFileToDownloadsTable("sound/ChaosMod/phoon.mp3");
	PrecacheSound("ChaosMod/phoon.mp3", true);
}

public void Chaos_Autobhop_START(){
	g_AutoBunnyhop++;
	cvar("sv_airaccelerate", "1999");
	PrintHintTextToAll("Hold space!");
	LoopValidPlayers(i){
		EmitSoundToClient(i, "ChaosMod/phoon.mp3", _, _, SNDLEVEL_RAIDSIREN, _, 0.3);
	}
}

public void Chaos_Autobhop_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED) ResetCvar("sv_airaccelerate", "12", "1999");
	if(g_AutoBunnyhop > 0) g_AutoBunnyhop--;
}

float funky_Velocity[3];
public void Chaos_Autobhop_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if(g_AutoBunnyhop > 0){
		if(ValidAndAlive(client) && GetEntityFlags(client) & FL_ONGROUND && buttons & IN_JUMP){
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", funky_Velocity);
			// funky_Velocity[2] = 282.0;
			funky_Velocity[2] = 300.0;
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, funky_Velocity);
		}
	}
}