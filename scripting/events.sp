
Handle g_BombTimer = INVALID_HANDLE;
public Action Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	g_bCanSpawnChickens = false;
	g_bBombPlanted = true;
	C4Chicken();
	g_BombTimer = CreateTimer(40.5, Timer_ResizeChickens); //todo get c4 timer value
	return Plugin_Continue;
}
public void ResetTimerRemoveChickens(){
	StopTimer(g_BombTimer);

}
public Action Timer_ResizeChickens(Handle timer){
	
	g_BombTimer = INVALID_HANDLE;

}


//DECOY DOGEBALL
public void OnEntityCreated(int ent, const char[] classname){
	if (g_bDecoyDodgeball) {
		if (StrContains(classname, "decoy_projectile") != -1) {
			SDKHook(ent, SDKHook_SpawnPost, HookOnDecoySpawn);
		}
	}
}


public void HookOnDecoySpawn(int iGrenade) {
	int client = GetEntPropEnt(iGrenade, Prop_Send, "m_hOwnerEntity");
	if (IsClientInGame(client) && IsPlayerAlive(client) && !IsFakeClient(client)) {
		int nadeslot = GetPlayerWeaponSlot(client, 3);
		if (nadeslot > 0) {
			RemovePlayerItem(client, nadeslot);
			// RemoveEdict(nadeslot);
			RemoveEntity(nadeslot);
		}
		GivePlayerItem(client, "weapon_decoy");
	}
}


public Action OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed)
{
	if(g_bSimon_Active){
		SimonSays(client, buttons, iImpulse, fVel, fAngles, iWeapon, iSubType,  iCmdNum, iTickCount, iSeed);
	}
	//https://forums.alliedmods.net/showthread.php?t=175636 thankyou!
	/*
		public Plugin:myinfo =
		{
			name = "[TF2] ROFlMod",
			author = "FlaminSarge (orig by EHG)",
			description = "Change the Rate of Fire (ROF) for any client",
			version = PLUGIN_VERSION,
			url = ""
		}
	*/
	if(g_bRapidFire){
		if (buttons & IN_ATTACK){
			int ent = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if (IsValidEntity(ent)){
				float time;
				float ETime = GetGameTime();
				// float MAS = Multi[client];
				time = (GetEntPropFloat(ent, Prop_Send, "m_flNextPrimaryAttack") - ETime) * g_RapidFire_Rate + ETime;
				SetEntPropFloat(ent, Prop_Send, "m_flNextPrimaryAttack", time);
			}
		}
		else if (buttons & IN_ATTACK2){
			int ent = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if (IsValidEntity(ent)){
				float time;
				float ETime = GetGameTime();
				time = (GetEntPropFloat(ent, Prop_Send, "m_flNextSecondaryAttack") - ETime) * g_RapidFire_Rate + ETime;
				SetEntPropFloat(ent, Prop_Send, "m_flNextSecondaryAttack", time);
			}
		}
	}

	Aimbot_OnPlayerRunCmd(client, buttons,  iImpulse,  fVel, fAngles, iWeapon, iSubType, iCmdNum, iTickCount, iSeed);
	if(g_bForceCrouch) buttons |= IN_DUCK;


	if(g_bSpeedShooter == true && buttons & IN_ATTACK){
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 5.0);
	}else if(g_bSpeedShooter){
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
	}
	float vec[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", vec);
	vec[0] = 0.0;
	vec[1] = 0.0;
	if(g_bNoStrafe){
		if(buttons & IN_MOVELEFT){
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec);
		}
		if(buttons & IN_MOVERIGHT){
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec);
		}
	}
	if(g_bNoForwardBack){
		if(buttons & IN_FORWARD){
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec);
		}
		if(buttons & IN_BACK){
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec);
		}
	}


	return Plugin_Continue;
}

public Action Timer_GiveRandomWeapon_OneShotOneGun(Handle timer, int client){
	GiveAndSwitchWeapon(client, g_sWeapons[GetRandomInt(0, sizeof(g_sWeapons))]);
}

public void OnWeaponFirePost(Event hEvent, const char[] szName, bool g_bbDontBroadcast){



	char szWeaponName[32];
	hEvent.GetString("weapon", szWeaponName, sizeof(szWeaponName));
	int client = GetClientOfUserId(hEvent.GetInt("userid"));
	weaponJump(client, szWeaponName);


	if(g_bOneBulletOneGun){
		if( StrContains(szWeaponName, "weapon_knife") == -1){
			CreateTimer(0.1, Timer_GiveRandomWeapon_OneShotOneGun, client);
		}
	}

	//One bullet magazine handler
	if(g_bOneBulletMag){
		if(ValidAndAlive(client)){
			for (int j = 0; j < 2; j++){
				int iTempWeapon = -1;
				if ((iTempWeapon = GetPlayerWeaponSlot(client, j)) != -1) SetClip(iTempWeapon, 1, 1);
			}
		}
	}

	if(g_bPortalGuns){
		//todo; if player is further thatn x units away from the closest marked location, tp them back
		//todo; deal with stuck players

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
			}
		}
		
	}
}


public Action Event_BulletImpact(Event event, const char[] name, bool dontBroadcast){
	Explosive_Event_BulletImpact(event, name, dontBroadcast);
}

public Action Hook_BulletShot(const char[] te_name, const int[] Players, int numClients, float delay){
	Explosive_Hook_BulletShot(te_name, Players, numClients, delay);
}


public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	// if (event.GetBool("headshot"))
	// {
	//     return Plugin_Handled;
	// }
	int client = GetClientOfUserId(event.GetInt("userid"));
	// float vec[3];
	GetClientAbsOrigin(client, g_PlayerDeathLocations[client]);
	//  = vec;
	return Plugin_Continue;
}