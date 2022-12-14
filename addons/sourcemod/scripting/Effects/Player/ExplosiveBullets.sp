bool g_bExplosiveBullets = false;

SETUP(effect_data effect){
	effect.Title = "Explosive Bullets";
	effect.Duration = 30;
}

public void Chaos_ExplosiveBullets_OnMapStart(){
	PrecacheEffect("ParticleEffect");
	PrecacheParticleEffect(DISTORTION);
	PrecacheParticleEffect(FLASH);
	PrecacheParticleEffect(SMOKE);
	PrecacheParticleEffect(DIRT);
	PrecacheSound(EXPLOSION_HE);
}

INIT(){
	HookEvent("bullet_impact", 		Chaos_ExplosiveBullets_Event_BulletImpact);
	AddTempEntHook("Shotgun Shot", 	Chaos_ExplosiveBullets_Hook_BulletShot);
}


START(){
	g_bExplosiveBullets = true;
}

RESET(bool HasTimerEnded){
	g_bExplosiveBullets = false;
}

public Action Chaos_ExplosiveBullets_Event_BulletImpact(Event event, const char[] name, bool dontBroadcast){
	if (!g_bExplosiveBullets) return;
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	float pos[3];
	pos[0] = event.GetFloat("x");
	pos[1] = event.GetFloat("y");
	pos[2] = event.GetFloat("z");
	
	int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	
	CS_CreateExplosion(client, weapon, 10.0, 350.0, pos);
}

public Action Chaos_ExplosiveBullets_Hook_BulletShot(const char[] te_name, const int[] Players, int numClients, float delay){
	if (!g_bExplosiveBullets) return;
		
	int client = TE_ReadNum("m_iPlayer") + 1;
	
		
	float pos[3], angles[3];
	TE_ReadVector("m_vecOrigin", pos);
	angles[0] = TE_ReadFloat("m_vecAngles[0]");
	angles[1] = TE_ReadFloat("m_vecAngles[1]");
	angles[2] = 0.0;
    
	float endpos[3];
	Handle trace = TR_TraceRayFilterEx(pos, angles, MASK_SHOT, RayType_Infinite, TR_DontHitSelf, client);
	if (TR_DidHit(trace)){
		TR_GetEndPosition(endpos, trace);
	}
	delete trace;
	//Play the explosion sound
	EmitAmbientSound(EXPLOSION_HE, endpos, SOUND_FROM_WORLD, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.5, SNDPITCH_HIGH);
	return;
}

public bool TR_DontHitSelf(int target, int mask, int client){
	return target != client;
}

void CS_CreateExplosion(int attacker, int weapon, float damage, float radius, float pos[3]){
	//Create temp entity particle explosion effects
	TE_DispatchEffect(DISTORTION, pos);
	TE_DispatchEffect(FLASH, pos);
	TE_DispatchEffect(SMOKE, pos);
	TE_DispatchEffect(DIRT, pos);
	
	//Hurt the players in the area of explosion
	float victim_pos[3];
	LoopAlivePlayers(victim){
		GetClientAbsOrigin(victim, victim_pos);
		float distance = GetVectorDistance(pos, victim_pos);
		if(distance <= radius){
			//Calculate damage based of distance
			float result = Sine(((radius - distance) / radius) * (3.14159 / 2)) * damage;
			SDKHooks_TakeDamage(victim, attacker, attacker, result, DMG_BLAST, weapon, NULL_VECTOR, pos);
		}
	}
}

void TE_DispatchEffect(const char[] particle, float pos[3]){
	TE_Start("EffectDispatch");
	TE_WriteFloatArray("m_vOrigin.x", pos, 3);
	TE_WriteFloatArray("m_vStart.x", pos, 3);
	TE_WriteNum("m_nHitBox", GetParticleEffectIndex(particle));
	TE_WriteNum("m_iEffectName", GetEffectIndex("ParticleEffect"));
	// TE_WriteNum("m_flRadius", 250);
	TE_SendToAll();
}

void PrecacheParticleEffect(const char[] sEffectName){
	static int table = INVALID_STRING_TABLE;
	
	if (table == INVALID_STRING_TABLE) table = FindStringTable("ParticleEffectNames");
		
	bool save = LockStringTables(false);
	AddToStringTable(table, sEffectName);
	LockStringTables(save);
}

int GetParticleEffectIndex(const char[] sEffectName){
	static int table = INVALID_STRING_TABLE;
	if (table == INVALID_STRING_TABLE) table = FindStringTable("ParticleEffectNames");

	int iIndex = FindStringIndex(table, sEffectName);
	if (iIndex != INVALID_STRING_INDEX) return iIndex;

	return 0;
}

void PrecacheEffect(const char[] sEffectName){
	static int table = INVALID_STRING_TABLE;
	
	if (table == INVALID_STRING_TABLE) table = FindStringTable("EffectDispatch");
		
	bool save = LockStringTables(false);
	AddToStringTable(table, sEffectName);
	LockStringTables(save);
}

int GetEffectIndex(const char[] sEffectName){
	static int table = INVALID_STRING_TABLE;

	if (table == INVALID_STRING_TABLE) table = FindStringTable("EffectDispatch");

	int iIndex = FindStringIndex(table, sEffectName);
	if (iIndex != INVALID_STRING_INDEX) return iIndex;

	return 0;
}