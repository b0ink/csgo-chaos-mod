public void Chaos_Soccerballs(effect_data effect){
	effect.Title = "Soccerballs";
	effect.Duration = 60;
}

public void Chaos_Soccerballs_OnMapStart(){
	PrecacheModel("models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl", true);
}

public void Chaos_Soccerballs_START(){
	cvar("sv_turbophysics", "100");

	char MapName[128];
	GetCurrentMap(MapName, sizeof(MapName));
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			if(DistanceToClosestPlayer(vec) > 50){
				int ent = CreateEntityByName("prop_physics_multiplayer");
				SetEntityModel(ent, "models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl");
				DispatchKeyValue(ent, "StartDisabled", "false");
				DispatchKeyValue(ent, "Solid", "6");
				DispatchKeyValue(ent, "spawnflags", "1026");
				
				TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(ent);
				AcceptEntityInput(ent, "TurnOn", ent, ent, 0);
				AcceptEntityInput(ent, "EnableCollision");
				SetEntProp(ent, Prop_Data, "m_CollisionGroup", 5);
				SetEntityMoveType(ent, MOVETYPE_VPHYSICS);
				DispatchKeyValue(ent, "targetname", "Soccerball");
			}
		}
	}
}

public void Chaos_Soccerballs_RESET(){
	char classname[64];
	char targetname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		if(StrEqual(classname, "prop_physics_multiplayer") && GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == -1){
			GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
			if(StrEqual(targetname, "Soccerball", false)){
				RemoveEntity(ent);
			}else{
				continue;
			}	
		}
	}
}

public bool Chaos_Soccerballs_Conditions(){
	if(!ValidMapPoints()) return false;
	return true;
}