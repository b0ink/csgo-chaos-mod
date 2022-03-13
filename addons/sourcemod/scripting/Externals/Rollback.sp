bool g_bRewind_logging_enabled = true;
bool g_Rewinding = false;
int g_RewindTime = 0;

#define g_RollbackFrames 640 //64tick by 10 seconds; 128tick servers will replay in 5 seconds

float g_RollbackPositions[MAXPLAYERS+1][g_RollbackFrames][3];
float g_RollbackAngles[MAXPLAYERS+1][g_RollbackFrames][3];

public void Rollback_Log(){
	if(g_bRewind_logging_enabled){
		for(int client = 0; client <= MaxClients; client++){
			if(ValidAndAlive(client)){
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
				g_RollbackPositions[client][0] = location;
				g_RollbackAngles[client][0] = angles;
			}
		}
	}else if(g_Rewinding){
		if(g_RewindTime <= (g_RollbackFrames - 1)){
			for(int i = 0; i <= MaxClients; i++){
				if(ValidAndAlive(i)){
					float loc[3];
					float angles[3];
					loc = g_RollbackPositions[i][g_RewindTime];
					angles =  g_RollbackAngles[i][g_RewindTime];
					
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
		}else{
			g_bRewind_logging_enabled = true;
			g_Rewinding = false;
			Chaos_RewindTenSeconds(true);
		}
	}
}


Handle g_Chaos_Rewind_Timer = INVALID_HANDLE;
void Chaos_RewindTenSeconds(bool EndChaos = false){
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
	if(NotDecidingChaos("Chaos_RewindTenSeconds")) return;
	Log("[Chaos] Running: Chaos_RewindTenSeconds");
	g_bRewind_logging_enabled = false;
	g_Rewinding = true;
	g_RewindTime = 0;
	AnnounceChaos("Rewind 10 seconds", -1.0);
}