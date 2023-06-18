#pragma semicolon 1

bool ExplodeOnDeath = false;

public void Chaos_ExplodeOnDeath(EffectData effect) {
	effect.Title = "Explode on Death";
	effect.Duration = 30;

	HookEvent("player_death", ExplodeOnDeath_PlayerDeath, EventHookMode_Pre);
}

public void Chaos_ExplodeOnDeath_START() {
	ExplodeOnDeath = true;
}

public void Chaos_ExplodeOnDeath_RESET() {
	ExplodeOnDeath = false;
}

public void ExplodeOnDeath_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {
	if(!ExplodeOnDeath) return;

	int	  victim = GetClientOfUserId(event.GetInt("userid"));

	float pos[3];
	GetClientEyePosition(victim, pos);
	pos[2] -= 25.0;

	DataPack pack = new DataPack();
	pack.WriteCell(victim);
	pack.WriteFloatArray(pos, 3);

	RequestFrame(ExplodePlayer, pack);
}

public void ExplodePlayer(DataPack pack) {
	pack.Reset();

	int	  client = pack.ReadCell();
	float pos[3];
	pack.ReadFloatArray(pos, 3);

	EmitAmbientSound("weapons/hegrenade/explode5.wav", pos, SOUND_FROM_WORLD, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.75, SNDPITCH_NORMAL);
	CS_CreateExplosion(client, 0, 50.0, 200.0, pos);

	delete pack;
}