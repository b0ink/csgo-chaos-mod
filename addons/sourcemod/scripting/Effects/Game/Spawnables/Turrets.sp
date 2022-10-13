//Credit: https://forums.alliedmods.net/showthread.php?t=312548

public void Chaos_Turrets(effect_data effect){
	effect.title = "Turrets";
	effect.HasNoDuration = true;

	effect.AddAlias("Droneguns");
	effect.AddAlias("Drones");
}

int dronegun_collision;

public void Chaos_Turrets_INIT(){
	dronegun_collision = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
}

int dronegunEnt = 0;

public void Chaos_Turrets_OnMapStart(){
	dronegunEnt = 0;

	dronegunEnt = PrecacheModel("models/props_survival/dronegun/dronegun.mdl", true);
	if (dronegunEnt == 0) {
		PrintToServer("models/props_survival/dronegun/dronegun.mdl not precached !");
	}

	PrecacheModel("models/props_survival/dronegun/dronegun_gib1.mdl", true);
	PrecacheModel("models/props_survival/dronegun/dronegun_gib2.mdl", true);
	PrecacheModel("models/props_survival/dronegun/dronegun_gib3.mdl", true);
	PrecacheModel("models/props_survival/dronegun/dronegun_gib4.mdl", true);
	PrecacheModel("models/props_survival/dronegun/dronegun_gib5.mdl", true);
	PrecacheModel("models/props_survival/dronegun/dronegun_gib6.mdl", true);
	PrecacheModel("models/props_survival/dronegun/dronegun_gib7.mdl", true);
	PrecacheModel("models/props_survival/dronegun/dronegun_gib8.mdl", true);

	PrecacheSound("sound/survival/turret_death_01.wav", true);
	PrecacheSound("sound/survival/turret_idle_01.wav", true);

	PrecacheSound("sound/survival/turret_takesdamage_01.wav", true);
	PrecacheSound("sound/survival/turret_takesdamage_02.wav", true);
	PrecacheSound("sound/survival/turret_takesdamage_03.wav", true);

	PrecacheSound("sound/survival/turret_lostplayer_01.wav", true);
	PrecacheSound("sound/survival/turret_lostplayer_02.wav", true);
	PrecacheSound("sound/survival/turret_lostplayer_03.wav", true);

	PrecacheSound("sound/survival/turret_sawplayer_01.wav", true);
}

public void Chaos_Turrets_START(){
	ShuffleMapSpawns();

	float vec[3];
	LoopAllMapSpawns(vec, index){
		if(DistanceToClosestPlayer(vec) < 200) continue;

		int dronegun = CreateEntityByName("dronegun");
		if(!IsValidEntity(dronegun)) break;
		SetEntData(dronegun, dronegun_collision, 2, 4, true); // no Collision
		TeleportEntity(dronegun, vec, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(dronegun);


		if(index > 50) break; // spawn 50
	}
}

public bool Chaos_Turrets_Conditions(){
	if(dronegunEnt == 0) return false;
	return true;
}
