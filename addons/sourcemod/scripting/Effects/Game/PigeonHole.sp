public void Chaos_PigeonHole(effect_data effect){
	effect.title = "Pigeon Hole";
	effect.duration = 30;
	effect.IncompatibleWith("Chaos_Binoculars");
}

/*
	Runs on the OnMapStart function. Use this to precache any models or textures.
*/
public void Chaos_PigeonHole_OnMapStart(){
	PrecacheDecal("Chaos/PigeonHole/pg_1.vmt", true);
	PrecacheDecal("Chaos/PigeonHole/pg_1.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_1.vtf");
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_1.vmt");

	PrecacheDecal("Chaos/PigeonHole/pg_2.vmt", true);
	PrecacheDecal("Chaos/PigeonHole/pg_2.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_2.vtf");
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_2.vmt");

	PrecacheDecal("Chaos/PigeonHole/pg_3.vmt", true);
	PrecacheDecal("Chaos/PigeonHole/pg_3.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_3.vtf");
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_3.vmt");

	PrecacheDecal("Chaos/PigeonHole/pg_4.vmt", true);
	PrecacheDecal("Chaos/PigeonHole/pg_4.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_4.vtf");
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_4.vmt");

	PrecacheDecal("Chaos/PigeonHole/pg_5.vmt", true);
	PrecacheDecal("Chaos/PigeonHole/pg_5.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_5.vtf");
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_5.vmt");

	PrecacheDecal("Chaos/PigeonHole/pg_6.vmt", true);
	PrecacheDecal("Chaos/PigeonHole/pg_6.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_6.vtf");
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_6.vmt");

	PrecacheDecal("Chaos/PigeonHole/pg_7.vmt", true);
	PrecacheDecal("Chaos/PigeonHole/pg_7.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_7.vtf");
	AddFileToDownloadsTable("materials/Chaos/PigeonHole/pg_7.vmt");
}

char lastPigeonHole[PLATFORM_MAX_PATH];
int lastPigeonHoleIndex = -1;
Handle PigeonHoleSpawnTimer;
public void Chaos_PigeonHole_START(){
	Timer_SpawnNewPigeonHole(null);
	PigeonHoleSpawnTimer = CreateTimer(5.0, Timer_SpawnNewPigeonHole, _, TIMER_REPEAT);
}

public Action Timer_SpawnNewPigeonHole(Handle timer){
	if(lastPigeonHole[0]){
		Remove_Overlay(lastPigeonHole);
	}
	int randomPigeonHole = -1;
	do
	{
		randomPigeonHole = GetRandomInt(1, 7);
	}
	while(randomPigeonHole == lastPigeonHoleIndex);
	lastPigeonHoleIndex = randomPigeonHole;

	Format(lastPigeonHole, sizeof(lastPigeonHole), "/Chaos/PigeonHole/pg_%i.vtf", randomPigeonHole);
	Add_Overlay(lastPigeonHole);
}

public Action Chaos_PigeonHole_RESET(bool EndChaos){
	StopTimer(PigeonHoleSpawnTimer);
	if(lastPigeonHole[0]){
		Remove_Overlay(lastPigeonHole);
	}
}

public bool Chaos_PigeonHole_Conditions(){
	return true;
}