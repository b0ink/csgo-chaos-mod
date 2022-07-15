//weappon fire

bool g_bPortalGuns = false;
int g_beamsprite;
int g_halosprite;
float g_PortalTeleports[MAXPLAYERS + 1][3];

public void Chaos_PortalGuns_INIT(){
	g_beamsprite = PrecacheModel("materials/sprites/laserbeam.vmt");
	g_halosprite = PrecacheModel("materials/sprites/halo.vmt");
}

public void Chaos_PortalGuns_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){

	if(g_bPortalGuns){
		//TODO: if player is further than the closest spawn point by x units, tp them back?
		char szWeaponName[32];
		event.GetString("weapon", szWeaponName, sizeof(szWeaponName));
		int client = GetClientOfUserId(event.GetInt("userid"));
	// thatn x units away from the closest marked location, tp them back?
		//ignore grenades
		int target = GetClientAimTarget(client);
		if( StrContains(szWeaponName, "grenade") == -1 && //smoke & he
			StrContains(szWeaponName, "incendiary") == -1 &&
			StrContains(szWeaponName, "flashbang") == -1 &&
			StrContains(szWeaponName, "knife") == -1 &&
			StrContains(szWeaponName, "molotov") == -1){
			//only teleport if not looking at a player
			if(!ValidAndAlive(target)){
				SetTeleportEndPoint(client);
				PerformTeleport(client, g_PortalTeleports[client]);
				EmitSoundToClient(client, SOUND_BLIP, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
			}
		}
	}
}

public void Chaos_PortalGuns_START(){
	g_bPortalGuns = true;
	SavePlayersLocations();
}

public void Chaos_PortalGuns_RESET(bool EndChaos){
	g_bPortalGuns = false;
	if(EndChaos){
		TeleportPlayersToClosestLocation();
	}

}


public bool Chaos_PortalGuns_HasNoDuration(){
	return false;
}

public bool Chaos_PortalGuns_Conditions(){
	return true;
}


//Teleport: by Spazman0

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
		// Distance = -35.0;
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
	// partpos[2]-=20.0;	
	pos[2]+=10.0;
	TeleportEntity(target, pos, NULL_VECTOR, NULL_VECTOR);

	int redColor[4] = {255, 75, 75, 255};
	int blueColor[4] = {75, 75, 255, 255};
	int greyColor[4] = {128, 128, 128, 255};
	int team = GetClientTeam(target);

	TE_SetupBeamRingPoint(pos, 10.0, 80.0, g_beamsprite, g_halosprite, 0, 15, 0.5, 5.0, 0.0, greyColor, 10, 0);
	TE_SendToAll();
	
	if (team == 2){
		TE_SetupBeamRingPoint(pos, 10.0, 80.0, g_beamsprite, g_halosprite, 0, 10, 0.6, 10.0, 0.5, redColor, 10, 0);
	}else if (team == 3){
		TE_SetupBeamRingPoint(pos, 10.0, 80.0, g_beamsprite, g_halosprite, 0, 10, 0.6, 10.0, 0.5, blueColor, 10, 0);
	}
	TE_SendToAll();
}

public bool TraceEntityFilterPlayer(int entity, int contentsMask){
	return entity > MaxClients || !entity;
} 