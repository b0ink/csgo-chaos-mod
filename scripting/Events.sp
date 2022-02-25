//todo: move all effects into their own .sp files inside of /scripting/Externals, modularise it a bit more

public Action Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	g_bCanSpawnChickens = false;
	g_bBombPlanted = true;
	C4Chicken();
	return Plugin_Continue;
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
	if (ValidAndAlive(client)) {
		int nadeslot = GetPlayerWeaponSlot(client, 3);
		if (nadeslot > 0) {
			RemovePlayerItem(client, nadeslot);
			RemoveEntity(nadeslot);
		}
		GivePlayerItem(client, "weapon_decoy");
	}
}



public Action OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

	if(g_bSimon_Active) SimonSays(client, buttons, iImpulse, fVel, fAngles, iWeapon, iSubType,  iCmdNum, iTickCount, iSeed);

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

	//todo create overwride for these convars to be used for eg. funky

	/*
		use old method of setting the clients movement to 0
		but add a half second buffer?
	 */

	g_blockMovement[client] = 0;

	if(g_bNoStrafe){
		if(buttons & IN_MOVELEFT){
			if(g_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, g_DisableKeys_OriginalPos[client]);
			}
			g_blockMovement[client]++;
		}else if(buttons & IN_MOVERIGHT){
			if(g_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, g_DisableKeys_OriginalPos[client]);
			}
			g_blockMovement[client]++;
		}
	}

	if(g_bNoForwardBack){
		if(buttons & IN_FORWARD){
			if(g_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, g_DisableKeys_OriginalPos[client]);
			}
			g_blockMovement[client]++;
		}else if(buttons & IN_BACK){
			if(g_DisableKeys_OriginalPos[client][0] == 0.0){
				GetClientAbsOrigin(client, g_DisableKeys_OriginalPos[client]);
			}
			g_blockMovement[client]++;
		}
	}

	if(g_blockMovement[client] == 0){ //not pressing any movement keys
		g_DisableKeys_OriginalPos[client][0] = 0.0;
		g_DisableKeys_OriginalPos[client][1] = 0.0;
		g_DisableKeys_OriginalPos[client][2] = 0.0;
	}

	return Plugin_Continue;
}


public Action Timer_GiveRandomWeapon_OneShotOneGun(Handle timer, int client){
	GiveAndSwitchWeapon(client, g_sWeapons[GetRandomInt(0, sizeof(g_sWeapons) - 1)]);
}

public void Event_OnWeaponFirePost(Event hEvent, const char[] szName, bool g_bbDontBroadcast){
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
		//todo; if player is further thatn x units away from the closest marked location, tp them back?
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
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(IsValidClient(client)) GetClientAbsOrigin(client, g_PlayerDeathLocations[client]);
	return Plugin_Continue;
}


public Action Event_RoundStart(Event event, char[] name, bool dontBroadcast){
	Log("---ROUND STARTED---");

	g_bC4Chicken = false;
	g_bCanSpawnEffect = true;
	g_bRewind_logging_enabled = true;
	g_bKnifeFight = 0;

	ResetHud();
	
	ResetChaos();

	g_iChaos_Round_Count = 0;
	
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			g_OriginalSpawnVec[i] = vec;
		}
	}

	CreateTimer(5.0, Timer_CreateHostage);
	
	SetRandomSeed(GetTime());
	
	if(!g_bChaos_Enabled) return Plugin_Continue;
	
	if (GameRules_GetProp("m_bWarmupPeriod") != 1){
		float freezeTime = float(FindConVar("mp_freezetime").IntValue);
		g_NewEffect_Timer = CreateTimer(freezeTime, ChooseEffect, _, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}

public Action Event_RoundEnd(Event event, char[] name, bool dontBroadcast){
	Log("--ROUND ENDED--");
	ResetChaos();
	g_bCanSpawnEffect = false;

	return Plugin_Continue;
}

void ResetChaos(){
	HUD_ROUNDEND();
	StopTimer(g_NewEffect_Timer);
	CreateTimer(0.1, ResetRoundChaos);
}

public void OnGameFrame(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			if(g_bLockPlayersAim_Active) TeleportEntity(i, NULL_VECTOR, g_LockPlayersAim_Angles[i], NULL_VECTOR);
		}
	}

	Rollback_Log();
	
}


public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast){
	if (!g_cvChaosEnabled.BoolValue) return Plugin_Continue;
	return Plugin_Handled;
}