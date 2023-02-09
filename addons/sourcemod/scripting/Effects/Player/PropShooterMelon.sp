#pragma semicolon 1

/*
	https://github.com/Rachnus/Propshooter-Sourcemod-CS-GO-/
*/

bool PropShooterMelon = false;
char WatermelonModel[] = "models/props_junk/watermelon01.mdl";

public void Chaos_PropShooterMelon(EffectData effect){
	effect.Title = "Melon Guns";
	effect.Duration = 30;
}

public void Chaos_PropShooterMelon_INIT(){
	HookEvent("weapon_fire", PropShooterMelon_Event_WeaponFire);
}

public void Chaos_PropShooterMelon_OnMapStart(){
	PrecacheModel(WatermelonModel, true);
}

public void Chaos_PropShooterMelon_START(){
	PropShooterMelon = true;
}

public void Chaos_PropShooterMelon_RESET(){
	PropShooterMelon = false;
}


public Action PropShooterMelon_Event_WeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(PropShooterMelon){
		ShootProp(client, WatermelonModel);
	}
	return Plugin_Continue;
}

void ShootProp(int client, char[] propModel){
	if(propModel[0] == '\0') return;
	
	float propStart[3];
	float propAngle[3];
	float propVecs[3];
	
	GetClientEyePosition(client, propStart);
	GetClientEyeAngles(client, propAngle);
	GetAngleVectors(propAngle, propVecs, NULL_VECTOR, NULL_VECTOR);
	
	
	ScaleVector(propVecs, 9999999.0);
	
	int prop = CreateEntityByName("prop_physics_multiplayer");
	if(prop == -1) return;
	DispatchKeyValue(prop, "model", propModel);
	DispatchKeyValueFloat(prop, "physdamagescale", 50.0);
	DispatchKeyValueFloat(prop, "Damagetype", 1.0);
	DispatchKeyValueFloat(prop, "nodamageforces", 0.0);

	// SetEntityRenderMode(prop, RENDER_TRANSCOLOR);
	// SetEntityRenderColor(prop, rgba[client][0], rgba[client][1], rgba[client][2], rgba[client][3]);
	

	// DispatchKeyValue(prop, "targetname", steamID);
	SetEntPropEnt(prop, Prop_Send, "m_hOwnerEntity", client);
	
	DispatchKeyValueVector(prop, "origin", propStart);
	DispatchSpawn(prop);
	// propCounter[client]++;
	
	SetEntProp(prop, Prop_Data, "m_takedamage", 1);
	SetEntPropFloat(prop, Prop_Data, "m_flModelScale", 0.5);


	TeleportEntity(prop, propStart, NULL_VECTOR,  propVecs);
	
	SDKHookEx(prop, SDKHook_Touch, MelonHit);
	CreateTimer(2.0, Destroy_Prop, EntIndexToEntRef(prop));
}

public Action MelonHit(int melon, int other){
	if(ValidAndAlive(other)){
		SlapPlayer(other, 15, false);
	}

	return Plugin_Continue;
}

public Action Destroy_Prop(Handle timer, int entity){
	int prop = EntRefToEntIndex(entity);
		
	if(IsValidEntity(prop)){
		RemoveEntity(prop);
	}
	SDKUnhook(prop, SDKHook_Touch, MelonHit);


	return Plugin_Stop;
}