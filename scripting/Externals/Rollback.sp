bool g_bRewind_logging_enabled = true;
float g_RollbackPositions[MAXPLAYERS+1][10][3];
float g_RollbackAngles[MAXPLAYERS+1][10][3];

public Action Rollback_Log(Handle Timer){
	if(g_bRewind_logging_enabled){
		for(int client = 0; client <= MaxClients; client++){
			if(ValidAndAlive(client)){
				// PrintToChatAll("saving log for %N", client);
				int count = 9;
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
	}
}

Handle g_Chaos_Rewind_Timer = INVALID_HANDLE;
void Chaos_RewindTenSeconds(){
	if(CountingCheckDecideChaos()) return;
	if(g_bClearChaos){
		g_bRewind_logging_enabled = true;
		StopTimer(g_Chaos_Rewind_Timer);
	}
	if(DecidingChaos("Chaos_RewindTenSeconds")) return;
	Log("[Chaos] Running: Chaos_RewindTenSeconds");
	g_bRewind_logging_enabled = false;
	AnnounceChaos("Rewind 10 seconds");
	int time = 0;
	g_Chaos_Rewind_Timer = CreateTimer(0.1, Rewind_Timer, time);
}

public Action Rewind_Timer(Handle timer, int time){
	if(time <= 9){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				float loc[3];
				float angles[3];
				loc = g_RollbackPositions[i][time];
				angles =  g_RollbackAngles[i][time];
				// PrintToConsole(i, "TIME: %i setpos %f %f %f; setangs %f %f %f;", time, g_RollbackPositions[i][time][0], g_RollbackPositions[i][time][1], g_RollbackPositions[i][time][2], g_RollbackAngles[i][time][0], g_RollbackAngles[i][time][1],g_RollbackAngles[i][time][2]);
				TeleportEntity(i, loc, angles, NULL_VECTOR);
			}
		}
	}

	if(time <  9){
		time++;
		StopTimer(g_Chaos_Rewind_Timer);
		g_Chaos_Rewind_Timer = CreateTimer(0.3, Rewind_Timer, time);
	}else{
		TeleportPlayersToClosestLocation(); //fail safe todo: this is still bugged (the rewind part not this <<--)
		g_bRewind_logging_enabled = true;
		StopTimer(g_Chaos_Rewind_Timer);
	}
}


// g_RollbackPositions[client][count] = g_RollbackPositions[client][count - 1];
				// g_RollbackAngles[client][count] = g_RollbackAngles[client][count - 1];
