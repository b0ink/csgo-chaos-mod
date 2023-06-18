#pragma semicolon 1

ArrayList explodingChickensEnt;

char	  beepSfx[] = "weapons/c4/c4_beep1.wav";

public void Chaos_ExplodingChickens(EffectData effect) {
	effect.Title = "Exploding Chickens";
	effect.Duration = 10;

	explodingChickensEnt = new ArrayList();
}

public void Chaos_ExplodingChickens_OnMapStart() {
	PrecacheSound(beepSfx, true);
}

public Action SpawnChickens(Handle timer) {
	ShuffleMapSpawns();

	float pos[3];
	bool alternate = false;
	LoopAllMapSpawns(pos, index) {
		if(index > 30) break;
		if(DistanceToClosestPlayer(pos) < 100 && DistanceToClosestPlayer(pos) > 1000) continue;
		// SpawnExplodingChicken(pos);
		CreateTimer(alternate ? GetRandomFloat(0.0, 1.5) : 0.0, Timer_DelayExplodingChicken, index);
		alternate = !alternate;
	}
	return Plugin_Stop;
}

public Action Timer_DelayExplodingChicken(Handle timer, int posIndex) {
	float pos[3];
	GetArrayArray(g_MapCoordinates, posIndex, pos);
	SpawnExplodingChicken(pos);

	return Plugin_Stop;
}

public void Chaos_ExplodingChickens_START() {
	SpawnChickens(null);
}

public void Chaos_ExplodingChickens_RESET() {
	RemoveEntitiesInArray(explodingChickensEnt);
}

void SpawnExplodingChicken(float pos[3]) {
	int chicken = CreateEntityByName("chicken");
	if(chicken == -1) return;

	TeleportEntity(chicken, pos);
	DispatchSpawn(chicken);
	explodingChickensEnt.Push(EntIndexToEntRef(chicken));

	DataPack pack = new DataPack();
	pack.WriteCell(EntIndexToEntRef(chicken));
	pack.WriteCell(0);
	CreateTimer(0.5, Timer_ExplodeChicken, pack);
}

public Action Timer_ExplodeChicken(Handle timer, DataPack pack) {
	pack.Reset();
	int chicken = EntRefToEntIndex(pack.ReadCell());
	int time = pack.ReadCell();
	delete pack;

	if(chicken <= 0 || !IsValidEntity(chicken)) return Plugin_Stop;

	float pos[3];
	GetEntPropVector(chicken, Prop_Data, "m_vecOrigin", pos);

	if(time < 10) {
		DataPack newPack = new DataPack();
		newPack.WriteCell(EntIndexToEntRef(chicken));
		newPack.WriteCell(time + 1);
		if(time % 2 == 0 || time == 9 || time == 7) {
			SetEntityRenderColor(chicken, 255, 0, 0, 255);
			EmitAmbientSound(beepSfx, pos, SOUND_FROM_WORLD, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.2, time > 6 ? SNDPITCH_HIGH : SNDPITCH_NORMAL);
		} else {
			SetEntityRenderColor(chicken, 255, 255, 255, 255);
		}
		CreateTimer(0.5, Timer_ExplodeChicken, newPack);
		return Plugin_Stop;
	}


	EmitAmbientSound("weapons/hegrenade/explode5.wav", pos, SOUND_FROM_WORLD, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.5, SNDPITCH_HIGH);
	CS_CreateExplosion(0, 0, 50.0, 200.0, pos);
	SDKHooks_TakeDamage(chicken, 0, 0, 100.0, DMG_BLAST, 0, NULL_VECTOR, pos);
	return Plugin_Stop;
}

public void Chaos_ExplodingChickens_OnEntityDestroyed(int entity) {
	char classname[64];
	if(!GetEdictClassname(entity, classname, sizeof(classname))) return;
	if(!StrEqual(classname, "chicken")) return;
	
	DataPack newPack = new DataPack();
	newPack.WriteCell(EntIndexToEntRef(entity));
	newPack.WriteCell(100);
	Timer_ExplodeChicken(null, newPack);
}