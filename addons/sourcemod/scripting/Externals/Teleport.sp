//Teleport: by Spazman0

int g_beamsprite;
int g_halosprite;

void TELEPORT_INIT(){
	g_beamsprite = PrecacheModel("materials/sprites/laserbeam.vmt");
	g_halosprite = PrecacheModel("materials/sprites/halo.vmt");
}


float g_PortalTeleports[MAXPLAYERS + 1][3];
public void SetTeleportEndPoint(int client){
	float vAngles[3];
	float vOrigin[3];
	float vBuffer[3];
	float vStart[3];
	float Distance;
	
	GetClientEyePosition(client,vOrigin);
	GetClientEyeAngles(client, vAngles);
	
    //get endpoint for teleport
	Handle trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer);
    	
	if(TR_DidHit(trace)){
   	 	TR_GetEndPosition(vStart, trace);
		GetVectorDistance(vOrigin, vStart, false);
		Distance = -35.0;
   	 	GetAngleVectors(vAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		g_PortalTeleports[client][0] = vStart[0] + (vBuffer[0]*Distance);
		g_PortalTeleports[client][1] = vStart[1] + (vBuffer[1]*Distance);
		g_PortalTeleports[client][2] = vStart[2] + (vBuffer[2]*Distance);
		
      
	}else{
		Log("[CHAOS] Could not teleport player");
		CloseHandle(trace);
		return;
	}
	
	CloseHandle(trace);
	return;
}

public void PerformTeleport(int target, float pos[3]){
	float partpos[3];
	GetClientEyePosition(target, partpos);
	partpos[2]-=20.0;	
	TeleportEntity(target, pos, NULL_VECTOR, NULL_VECTOR);
	// pos[2]+=40.0;

	int redColor[4] = {255, 75, 75, 255};
	int blueColor[4] = {75, 75, 255, 255};
	int greyColor[4] = {128, 128, 128, 255};
	int team = GetClientTeam(target);

	TE_SetupBeamRingPoint(pos, 10.0, 50.0, g_beamsprite, g_halosprite, 0, 15, 0.5, 5.0, 0.0, greyColor, 10, 0);
	TE_SendToAll();
	
	if (team == 2){
		TE_SetupBeamRingPoint(pos, 10.0, 50.0, g_beamsprite, g_halosprite, 0, 10, 0.6, 10.0, 0.5, redColor, 10, 0);
	}else if (team == 3){
		TE_SetupBeamRingPoint(pos, 10.0, 50.0, g_beamsprite, g_halosprite, 0, 10, 0.6, 10.0, 0.5, blueColor, 10, 0);
	}
	TE_SendToAll();
}

public bool TraceEntityFilterPlayer(int entity, int contentsMask){
	return entity > MaxClients || !entity;
} 