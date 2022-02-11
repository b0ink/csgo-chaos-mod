//Teleport: by Spazman0

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
		LogError("[CHAOS] Could not teleport player");
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
	pos[2]+=40.0;
}

public bool TraceEntityFilterPlayer(int entity, int contentsMask){
	return entity > MaxClients || !entity;
} 