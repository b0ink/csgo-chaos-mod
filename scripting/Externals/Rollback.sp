bool g_bRewind_logging_enabled = true;
bool g_Rewinding = false;
int g_RewindTime = 0;
#define g_RollbackFrames 640 //64tick by 10 seconds; 128tick servers will replay in 5 seconds

float g_RollbackPositions[MAXPLAYERS+1][g_RollbackFrames][3];
float g_RollbackAngles[MAXPLAYERS+1][g_RollbackFrames][3];
// public Action Rollback_Log(Handle Timer){
public void Rollback_Log(){
	if(g_bRewind_logging_enabled){
		for(int client = 0; client <= MaxClients; client++){
			if(ValidAndAlive(client)){
				// PrintToChatAll("saving log for %N", client);
				int count = g_RollbackFrames - 1;
				while(count >= 1){
					g_RollbackPositions[client][count] = g_RollbackPositions[client][count - 1];
					g_RollbackAngles[client][count] = g_RollbackAngles[client][count - 1];
					count--;
				}
				float location[3];
				GetClientAbsOrigin(client, location);
				float angles[3];
				GetClientEyeAngles(client, angles);
				// PrintToConsole(client, "LOGGING: setpos %f %f %f; setang %f %f %f",
				// 	location[0],location[1],location[2],
				// 	angles[0], angles[1], angles[2]);
				g_RollbackPositions[client][0] = location;
				g_RollbackAngles[client][0] = angles;
				// PrintToConsole(client, "CONFIRM:setpos %f %f %f; setangs %f %f %f;", g_RollbackPositions[client][0][0], g_RollbackPositions[client][0][1], g_RollbackPositions[client][0][2], g_RollbackAngles[client][0][0], g_RollbackAngles[client][0][1],g_RollbackAngles[client][0][2]);

				// PrintToChatAll("saving for: %N loc: %f %f %f, angles: %f %f %f", client, 
				// 	location[0],location[1],location[2],
				// 	angles[0], angles[1], angles[2]);
			}
		}
	}else if(g_Rewinding){
		// PrintToChatAll("time: %i", g_RewindTime);
		if(g_RewindTime <= (g_RollbackFrames - 1)){
			for(int i = 0; i <= MaxClients; i++){
				if(ValidAndAlive(i)){
					float loc[3];
					float angles[3];
					loc = g_RollbackPositions[i][g_RewindTime];
					angles =  g_RollbackAngles[i][g_RewindTime];
					// PrintToConsole(i, "TIME: %i setpos %f %f %f; setangs %f %f %f;", time, g_RollbackPositions[i][time][0], g_RollbackPositions[i][time][1], g_RollbackPositions[i][time][2], g_RollbackAngles[i][time][0], g_RollbackAngles[i][time][1],g_RollbackAngles[i][time][2]);
					
					if(loc[0] != 0.0 || loc[1] != 0.0 || loc[2] != 0.0){
						if(angles[0] != 0.0 || angles[1] != 0.0 || angles[2] != 0.0){
							SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 0.0);
							TeleportEntity(i, loc, angles, NULL_VECTOR);
						}
					}
				}
			}
		}

		if(g_RewindTime < (g_RollbackFrames - 1)){
			g_RewindTime++;
			// g_Chaos_Rewind_Timer = INVALID_HANDLE;
			// g_Chaos_Rewind_Timer = CreateTimer(0.3, Rewind_Timer, time);
		}else{
			TeleportPlayersToClosestLocation(); //fail safe todo: this is still bugged (the rewind part not this <<--)
			g_bRewind_logging_enabled = true;
			g_Rewinding = false;
			Chaos_RewindTenSeconds(true);
		}
	}
}


Handle g_Chaos_Rewind_Timer = INVALID_HANDLE;
void Chaos_RewindTenSeconds(bool EndChaos = false){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos || EndChaos){
		g_bRewind_logging_enabled = true;
		g_Rewinding = true;
		StopTimer(g_Chaos_Rewind_Timer);
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				SetEntPropFloat(i, Prop_Send, "m_flLaggedMovementValue", 1.0);
			}
		}
	}
	if(DecidingChaos("Chaos_RewindTenSeconds")) return;
	Log("[Chaos] Running: Chaos_RewindTenSeconds");
	g_bRewind_logging_enabled = false;
	g_Rewinding = true;
	g_RewindTime = 0;
	AnnounceChaos("Rewind 10 seconds", -1.0);
	// int time = 0;
	// g_Chaos_Rewind_Timer = CreateTimer(0.1, Rewind_Timer, time);
}

// public Action Rewind_Timer(Handle timer, int time){
	
// }


// g_RollbackPositions[client][count] = g_RollbackPositions[client][count - 1];
				// g_RollbackAngles[client][count] = g_RollbackAngles[client][count - 1];
