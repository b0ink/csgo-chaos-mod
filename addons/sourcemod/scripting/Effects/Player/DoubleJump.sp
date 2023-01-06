/*
Original by:
	* Contact:
	* Paegus: paegus@gmail.com
	* SourceMod: http://www.sourcemod.net
	* Hidden:Source: http://www.hidden-source.com
	* NcB_Sav: http://forums.alliedmods.net/showthread.php?t=99228
*/

float g_flBoost = 300.0;
int g_fLastButtons[MAXPLAYERS+1];
int g_fLastFlags[MAXPLAYERS+1];
int g_iJumps[MAXPLAYERS+1];
int g_iJumpMax = 1;
	


bool g_bDoubleJump = false;
public void Chaos_DoubleJump(effect_data effect){
	effect.Title = "Double Jump";
	effect.Duration = 30;
}


public void Chaos_DoubleJump_START(){
	g_bDoubleJump = true;
}

public void Chaos_DoubleJump_RESET(bool EndChaos){
	g_bDoubleJump = false;
}


public bool Chaos_DoubleJump_Conditions(){
	return true;
}

public void Chaos_DoubleJump_OnGameFrame(){
	if (g_bDoubleJump) {
		for (int i = 1; i <= MaxClients; i++) {
			if ( IsClientInGame(i) && IsPlayerAlive(i)) {
				DoubleJump_DoubleJump(i);
			}
		}
	}
}

stock void DoubleJump_OriginalJump(int client) {
	g_iJumps[client]++;
}

stock void DoubleJump_Landed(int client) {
	g_iJumps[client] = 0;
}

stock void DoubleJump_DoubleJump(int client) {
	int fCurFlags	= GetEntityFlags(client);
	int	fCurButtons	= GetClientButtons(client);
	
	if (g_fLastFlags[client] & FL_ONGROUND) {
		if (!(fCurFlags & FL_ONGROUND) && !(g_fLastButtons[client] & IN_JUMP) && fCurButtons & IN_JUMP) {
			DoubleJump_OriginalJump(client);
		}
	} else if (fCurFlags & FL_ONGROUND) {
		DoubleJump_Landed(client);
	} else if (!(g_fLastButtons[client] & IN_JUMP) && fCurButtons & IN_JUMP) {
		DoubleJump_ReJump(client);
	}
	
	g_fLastFlags[client]	= fCurFlags;
	g_fLastButtons[client]	= fCurButtons;
}


stock void DoubleJump_ReJump(int client) {
	if ( 1 <= g_iJumps[client] <= g_iJumpMax) {
		g_iJumps[client]++;
		float vVel[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
		vVel[2] = g_flBoost;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
	}
}

