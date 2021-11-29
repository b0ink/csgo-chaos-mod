//Teleport: by Spazman0

// #include <sdktools_trace>
// float g_pos[3];

float g_PortalTeleports[MAXPLAYERS + 1][3];
public void SetTeleportEndPoint(int client)
{
	float vAngles[3];
	float vOrigin[3];
	float vBuffer[3];
	float vStart[3];
	float Distance;
	
	GetClientEyePosition(client,vOrigin);
	GetClientEyeAngles(client, vAngles);
	
    //get endpoint for teleport
	Handle trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer);
    	
	if(TR_DidHit(trace))
	{   	 
   	 	TR_GetEndPosition(vStart, trace);
		GetVectorDistance(vOrigin, vStart, false);
		Distance = -35.0;
   	 	GetAngleVectors(vAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		g_PortalTeleports[client][0] = vStart[0] + (vBuffer[0]*Distance);
		g_PortalTeleports[client][1] = vStart[1] + (vBuffer[1]*Distance);
		g_PortalTeleports[client][2] = vStart[2] + (vBuffer[2]*Distance);
	}
	else
	{
		LogError("[CHAOS] Could not teleport player");
		CloseHandle(trace);
		return;
	}
	
	CloseHandle(trace);
	return;
}

public void PerformTeleport(int target, float pos[3])
{
	float partpos[3];
	
	GetClientEyePosition(target, partpos);
	partpos[2]-=20.0;	
	
	// TeleportEffects(partpos);
	
	TeleportEntity(target, pos, NULL_VECTOR, NULL_VECTOR);
	pos[2]+=40.0;
	
	// TeleportEffects(pos);
	
}

// void TeleportEffects(float pos[3])
// {
// 	if(g_GameType == GAME_TF2)
// 	{
// 		ShowParticle(pos, "pyro_blast", 1.0);
// 		ShowParticle(pos, "pyro_blast_lines", 1.0);
// 		ShowParticle(pos, "pyro_blast_warp", 1.0);
// 		ShowParticle(pos, "pyro_blast_flash", 1.0);
// 		ShowParticle(pos, "burninggibs", 0.5);
// 	}
// }

// void ShowParticle(float possie[3], char[] particlename, float time)
// {
//     int particle = CreateEntityByName("info_particle_system");
//     if (IsValidEdict(particle))
//     {
//         TeleportEntity(particle, possie, NULL_VECTOR, NULL_VECTOR);
//         DispatchKeyValue(particle, "effect_name", particlename);
//         ActivateEntity(particle);
//         AcceptEntityInput(particle, "start");
//         CreateTimer(time, DeleteParticles, particle);
//     }
//     else
//     {
//         LogError("[CHAOS] ShowParticle: could not create info_particle_system");
//     }    
// }


public bool TraceEntityFilterPlayer(int entity, int contentsMask)
{
	return entity > MaxClients || !entity;
} 