#pragma semicolon 1

/*
	https://forums.alliedmods.net/showthread.php?t=269846
*/

bool ThrowingKnives = false;
bool ThrowingKnivesHeadshot[MAXPLAYERS+1];
Handle ThrownKnives; // Store thrown knives

#define DMG_HEADSHOT		(1 << 30)

public void Chaos_ThrowingKnives(effect_data effect){
	effect.Title = "Throwing Knives";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_Boxing");
}


public void Chaos_ThrowingKnives_INIT(){
	HookEvent("weapon_fire", ThrowingKnives_Event_WeaponFire);
	ThrownKnives = CreateArray();
}


public void Chaos_ThrowingKnives_OnPlayerSpawn(int client){
	HookBlockAllGuns(client);
	SDKUnhook(client, SDKHook_OnTakeDamage, ThrowingKnives_OnTakeDamage);
	SDKHook(client, SDKHook_OnTakeDamage, ThrowingKnives_OnTakeDamage);
}


public void Chaos_ThrowingKnives_START(){
	ThrowingKnives = true;
	HookBlockAllGuns();
	LoopAlivePlayers(i){
		FakeClientCommand(i, "use weapon_knife");
		SDKUnhook(i, SDKHook_OnTakeDamage, ThrowingKnives_OnTakeDamage);
		SDKHook(i, SDKHook_OnTakeDamage, ThrowingKnives_OnTakeDamage);
	}
}


public void Chaos_ThrowingKnives_RESET(int ResetType){
	UnhookBlockAllGuns(ResetType);
	LoopAlivePlayers(i){
		SDKUnhook(i, SDKHook_OnTakeDamage, ThrowingKnives_OnTakeDamage);
	}
	ThrowingKnives = false;
}


public void ThrowingKnives_Event_WeaponFire(Event event, const char[] name, bool dontBroadcast){
	if(!ThrowingKnives) return;
	int client = GetClientOfUserId(event.GetInt("userid"));

	char weapon[64];
	event.GetString("weapon", weapon, 64);
	
	if(StrContains(weapon, "knife", false) == -1){
		return;
	}
	
	CreateThrowingKnife(client);
}


void CreateThrowingKnife(int client){
	int slot_knife = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	int knife = CreateEntityByName("smokegrenade_projectile");
	int team =  GetClientTeam(client);

	if(knife == -1 || !DispatchSpawn(knife)){
		return;
	}

	// owner
	SetEntPropEnt(knife, Prop_Send, "m_hOwnerEntity", client);
	SetEntPropEnt(knife, Prop_Send, "m_hThrower", client);
	SetEntProp(knife, Prop_Send, "m_iTeamNum", team);

	
	// player knife model
	char model[PLATFORM_MAX_PATH];
	if(slot_knife != -1){
		GetEntPropString(slot_knife, Prop_Data, "m_ModelName", model, sizeof(model));
		if(ReplaceString(model, sizeof(model), "v_knife_", "w_knife_", true) != 1){
			model[0] = '\0';
		}else if(ReplaceString(model, sizeof(model), ".mdl", "_dropped.mdl", true) != 1){
			model[0] = '\0';
		}
	}

	if(!FileExists(model, true)){
		Format(model, sizeof(model), "%s", team == CS_TEAM_T ? "models/weapons/w_knife_default_t_dropped.mdl":"models/weapons/w_knife_default_ct_dropped.mdl");
	}

	// model and size
	SetEntProp(knife, Prop_Send, "m_nModelIndex", PrecacheModel(model));
	SetEntPropFloat(knife, Prop_Send, "m_flModelScale", 1.0);

	// knive elasticity
	SetEntPropFloat(knife, Prop_Send, "m_flElasticity", 0.2);
	// gravity
	SetEntPropFloat(knife, Prop_Data, "m_flGravity", 1.0);

	
	// Player origin and angle
	float origin[3];
	float angle[3];
	GetClientEyePosition(client, origin);
	GetClientEyeAngles(client, angle);

	// knive new spawn position and angle is same as player's
	float pos[3];
	GetAngleVectors(angle, pos, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(pos, 50.0);
	AddVectors(pos, origin, pos);

	// knive flying direction and speed/power
	float player_velocity[3];
	float velocity[3];

	GetEntPropVector(client, Prop_Data, "m_vecVelocity", player_velocity);
	GetAngleVectors(angle, velocity, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(velocity, 2250.0);
	AddVectors(velocity, player_velocity, velocity);

	// spin knive
	float spin[] = {4000.0, 0.0, 0.0};
	SetEntPropVector(knife, Prop_Data, "m_vecAngVelocity", spin);

	// Stop grenade detonate and Kill knive after 1 - 30 sec
	SetEntProp(knife, Prop_Data, "m_nNextThinkTick", -1);
	char buffer[25];
	Format(buffer, sizeof(buffer), "!self,Kill,,%0.1f,-1", 2.5); // knife life
	DispatchKeyValue(knife, "OnUser1", buffer);
	AcceptEntityInput(knife, "FireUser1");

	// trail effect
	int color[4] = {255, ...}; 

	TE_SetupBeamFollow(knife, PrecacheModel("effects/blueblacklargebeam.vmt"),	0, Float:0.5, Float:1.0, Float:0.1, 0, color);
	TE_SendToAll();

	// Throw knive!
	TeleportEntity(knife, pos, angle, velocity);
	SDKHookEx(knife, SDKHook_Touch, KnifeHit);

}


public Action KnifeHit(int knife, int other){
	if(!ValidAndAlive(other)){
		// knives collide
		if(FindValueInArray(ThrownKnives, EntIndexToEntRef(other)) != -1){
			SDKUnhook(knife, SDKHook_Touch, KnifeHit);
			float pos[3];
			float dir[3];
			GetEntPropVector(knife, Prop_Data, "m_vecOrigin", pos);
			TE_SetupArmorRicochet(pos, dir);
			TE_SendToAll(0.0);

			DispatchKeyValue(knife, "OnUser1", "!self,Kill,,1.0,-1");
			AcceptEntityInput(knife, "FireUser1");
		}
		return Plugin_Continue;
	}

	int victim = other;

	SetVariantString("csblood");
	AcceptEntityInput(knife, "DispatchEffect");
	AcceptEntityInput(knife, "Kill");

	int attacker = GetEntPropEnt(knife, Prop_Send, "m_hThrower");
	int inflictor = GetPlayerWeaponSlot(attacker, CS_SLOT_KNIFE);

	if(inflictor == -1){
		inflictor = attacker;
	}

	float victimeye[3];
	GetClientEyePosition(victim, victimeye);

	float damagePosition[3];
	float damageForce[3];

	GetEntPropVector(knife, Prop_Data, "m_vecOrigin", damagePosition);
	GetEntPropVector(knife, Prop_Data, "m_vecVelocity", damageForce);

	if(GetVectorLength(damageForce) == 0.0){ // knife movement stop{
		return Plugin_Continue;
	}

	// Headshot - shitty way check it, clienteyeposition almost player back...
	float distance = GetVectorDistance(damagePosition, victimeye);
	ThrowingKnivesHeadshot[attacker] = distance <= 20.0;

	// damage values and type
	float damage[2];
	damage[0] = 25.0;
	damage[1] = 65.0;

	int dmgtype = DMG_SLASH|DMG_NEVERGIB;

	if(ThrowingKnivesHeadshot[attacker]){
		dmgtype |= DMG_HEADSHOT;
	}

	// create damage
	SDKHooks_TakeDamage(victim, inflictor, attacker, ThrowingKnivesHeadshot[attacker] ? damage[1]:damage[0], dmgtype, knife, damageForce, damagePosition);

	// blood effect
	int color[] = {255, 0, 0, 255};
	float dir[3];

	TE_SetupBloodSprite(damagePosition, dir, color, 1, PrecacheDecal("sprites/blood.vmt"), PrecacheDecal("sprites/blood.vmt"));
	TE_SendToAll(0.0);

	// ragdoll effect
	int ragdoll = GetEntPropEnt(victim, Prop_Send, "m_hRagdoll");
	if(ragdoll != -1){
		ScaleVector(damageForce, 50.0);
		damageForce[2] = FloatAbs(damageForce[2]); // push up!
		SetEntPropVector(ragdoll, Prop_Send, "m_vecForce", damageForce);
		SetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollVelocity", damageForce);
	}


	return Plugin_Continue;
}


public Action ThrowingKnives_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3]){
	int dmgtype = DMG_SLASH|DMG_NEVERGIB;
	if(!ThrowingKnives) return Plugin_Continue;
	if(0 < inflictor <= MaxClients && inflictor == attacker && damagetype == dmgtype){
		ThrowingKnivesHeadshot[attacker] = false; // no headshot when slash
	}
	return Plugin_Continue;
}


public void ThrowingKnives_OnEntityDestroyed(int entity){
	if(!IsValidEdict(entity)){
		return;
	}

	int index = FindValueInArray(ThrownKnives, EntIndexToEntRef(entity));
	if(index != -1) RemoveFromArray(ThrownKnives, index);
}