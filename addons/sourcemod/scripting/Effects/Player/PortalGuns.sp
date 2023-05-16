#pragma semicolon 1


//weappon fire

bool g_bPortalGuns = false;
int g_beamsprite;
int g_halosprite;
float g_PortalTeleports[MAXPLAYERS + 1][3];

char BuzzSfx[] = "buttons/button18.wav";
char PortalBlipSfx[] = "buttons/blip1.wav";

public void Chaos_PortalGuns(EffectData effect){
	effect.Title = "Portal Guns";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_KnifeFight");
	effect.IncompatibleWith("Chaos_AlienKnifeFight");
	effect.IncompatibleWith("Chaos_Boxing");
	effect.IncompatibleWith("Chaos_DecoyDodgeball");

	HookEvent("weapon_fire", 		Chaos_PortalGuns_Event_OnWeaponFire); //, EventHookMode_Post);
}

public void Chaos_PortalGuns_OnMapStart(){
	g_beamsprite = PrecacheModel("materials/sprites/laserbeam.vmt");
	g_halosprite = PrecacheModel("materials/sprites/halo.vmt");
	PrecacheSound(BuzzSfx);
	PrecacheSound(PortalBlipSfx);
}

public void Chaos_PortalGuns_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){

	if(g_bPortalGuns ){
		//TODO: if player is further than the closest spawn point by x units, tp them back?
		char szWeaponName[32];
		event.GetString("weapon", szWeaponName, sizeof(szWeaponName));
		int client = GetClientOfUserId(event.GetInt("userid"));

		/* Dont teleport player out of skybox */
		if(IsLookingAtSkybox(client)){
			EmitSoundToClient(client, BuzzSfx, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
			return;
		}
		
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
				EmitSoundToClient(client, PortalBlipSfx, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
			}
		}
	}
}

public void Chaos_PortalGuns_START(){
	g_bPortalGuns = true;
	LoopAllClients(i){
		g_PortalTeleports[i] = view_as<float>({0.0, 0.0, 0.0});
		if(ValidAndAlive(i)){
			GetClientAbsOrigin(i, g_PortalTeleports[i]);
		}
	}
	SavePlayersLocations();
}

public void Chaos_PortalGuns_RESET(int ResetType){
	g_bPortalGuns = false;
	if(ResetType & RESET_EXPIRED){
		if(IsCoopStrike()){
			float backup[3];
			LoopAlivePlayers(i){
				if(GetClientTeam(i) != CS_TEAM_CT) continue;
				if(g_PortalTeleports[i][0] != 0.0 && g_PortalTeleports[i][1] != 0.0 &&  g_PortalTeleports[i][2] != 0.0){
					backup = g_PortalTeleports[i];
					TeleportEntity(i, g_PortalTeleports[i]);
				}else{
					TeleportEntity(i, backup);
				}
			}
		}else{
			TeleportPlayersToClosestLocation();
		}
	}

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
	partpos[2] -= 64.0;
	LerpToPoint(target, partpos, pos, 0.075, false);
	// TeleportEntity(target, pos, NULL_VECTOR, NULL_VECTOR);

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


/*
	https://forums.alliedmods.net/showpost.php?p=2678142&postcount=12
*/

bool IsLookingAtSkybox(int client){
	float eyeAng[3], eyePos[3], fwdVec[3];
	
	GetClientEyeAngles(client, eyeAng);
	GetClientEyePosition(client, eyePos);
	
	GetAngleVectors(eyeAng, fwdVec, NULL_VECTOR, NULL_VECTOR);
	GetVectorAngles(fwdVec, fwdVec);

	TR_TraceRayFilter(eyePos, fwdVec, MASK_SOLID, RayType_Infinite, TraceDontHitSelf, client);
	if (TR_DidHit()){
		char surface[64];
		TR_GetSurfaceName(null, surface, sizeof(surface));
		if(StrContains(surface, "skybox", false) != -1){
			return true;
		}
	}
	return false;
}


bool TraceDontHitSelf(int entity, any data){
    return entity == data;
}