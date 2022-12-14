SETUP(effect_data effect){
	effect.Title = "Pigeon Hole";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_Binoculars");
}

bool pigeonholeMaterials = true;

public void Chaos_PigeonHole_OnMapStart(){
	char pathname[PLATFORM_MAX_PATH];
	// Precache and download pg_1 - pg_7 both .vtf and .vmt
	for(int i = 1; i <= 7; i++){
		Format(pathname, sizeof(pathname), "Chaos/PigeonHole/pg_%i.vmt", i);
		PrecacheDecal(pathname, true);
		Format(pathname, sizeof(pathname), "Chaos/PigeonHole/pg_%i.vtf", i);
		PrecacheDecal(pathname, true);
		Format(pathname, sizeof(pathname), "materials/Chaos/PigeonHole/pg_%i.vtf", i);
		if(!FileExists(pathname)) pigeonholeMaterials = false;
		AddFileToDownloadsTable(pathname);
		Format(pathname, sizeof(pathname), "materials/Chaos/PigeonHole/pg_%i.vmt", i);
		if(!FileExists(pathname)) pigeonholeMaterials = false;
		AddFileToDownloadsTable(pathname);
	}
}

char lastPigeonHole[PLATFORM_MAX_PATH];
int lastPigeonHoleIndex = -1;
Handle PigeonHoleSpawnTimer;
START(){
	Timer_SpawnNewPigeonHole(null);
	PigeonHoleSpawnTimer = CreateTimer(5.0, Timer_SpawnNewPigeonHole, _, TIMER_REPEAT);
}

public Action Timer_SpawnNewPigeonHole(Handle timer){
	if(lastPigeonHole[0] != '\0'){
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

RESET(bool HasTimerEnded){
	StopTimer(PigeonHoleSpawnTimer);
	if(lastPigeonHole[0] != '\0'){
		Remove_Overlay(lastPigeonHole);
	}
}

CONDITIONS(){
	if(!CanRunOverlayEffect()) return false;
	return pigeonholeMaterials;
}