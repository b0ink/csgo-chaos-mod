#pragma semicolon 1

bool OilDrums = false;
bool OilDrumModelFound = true;

public void Chaos_OilDrums(effect_data effect){
	effect.Title = "Exploding Oil Drums";
	effect.Duration = 45;
}

public void Chaos_OilDrums_OnMapStart(){
	if(!FileExists("models/props_c17/oildrum001_explosive.mdl")){
		OilDrumModelFound = false;
	}else{
		PrecacheModel("models/props_c17/oildrum001_explosive.mdl");
	}

	AddFileToDownloadsTable("materials/models/props_c17/oil_drum001a_normal.vtf");
	AddFileToDownloadsTable("materials/models/props_c17/oil_drum001h.vmt");
	AddFileToDownloadsTable("materials/models/props_c17/oil_drum001h.vtf");

	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.dx80.vtx");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.dx90.vtx");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.mdl");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.phy");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.sw.vtx");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.vvd");	
}


/* Used in Chaos_Armageddon() */
void EnableOilDrums(){
	OilDrums = true;
}

void DisableOilDrums(){
	OilDrums = false;
}

public void Chaos_OilDrums_START(){
	OilDrums = true;
	CreateTimer(0.0, Timer_SpawnDrums, 15);
	CreateTimer(3.0, Timer_SpawnDrums, 15, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_SpawnDrums(Handle timer, int amount){
	if(!OilDrums) return Plugin_Stop;
	ShuffleMapSpawns();
	float pos[3];
	LoopAllMapSpawns(pos, index){
		SpawnOilDrum(true, pos);
		if(index > amount){
			break;
		}
	}
	return Plugin_Continue;
}

public void Chaos_OilDrums_RESET(){
	OilDrums = false;
}

void SpawnOilDrum(bool explosive, float pos[3]) {
	int ent = CreateEntityByName("prop_physics_multiplayer");

	pos[2] += 300;

	float angles[3];
	angles[0] = GetRandomFloat(0.0, 360.0);
	angles[1] = GetRandomFloat(0.0, 360.0);
	angles[2] = GetRandomFloat(0.0, 360.0);
	TeleportEntity(ent, pos, angles, NULL_VECTOR);

	if (explosive) {
		DispatchKeyValue(ent, "model", "models/props_c17/oildrum001_explosive.mdl");
		DispatchKeyValue(ent, "Damagetype", "1");
		DispatchKeyValue(ent, "minhealthdmg", "0");
		DispatchKeyValue(ent, "ExplodeDamage", "0");
		DispatchKeyValue(ent, "dmg", "5");
		DispatchKeyValue(ent, "physdamagescale", "0.001");
	}

	DispatchSpawn(ent);

	IgniteEntity(ent, 10.0);
}

public bool Chaos_OilDrums_Conditions(bool EffectRunRandomly){
	return OilDrumModelFound;
}