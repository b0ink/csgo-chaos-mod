#pragma semicolon 1

ArrayList soccerballs;
public void Chaos_Soccerballs(EffectData effect){
	effect.Title = "Soccerballs";
	effect.Duration = 60;

	soccerballs = new ArrayList();
}

public void Chaos_Soccerballs_OnMapStart(){
	PrecacheModel("models/props/de_dust/hr_dust/dust_soccerball/dust_soccer_ball001.mdl", true);
}

public void Chaos_Soccerballs_START(){
	cvar("sv_turbophysics", "100");

	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			if(IsCoopStrike() && DistanceToClosestPlayer(vec) > MAX_COOP_SPAWNDIST) continue;
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
				soccerballs.Push(EntIndexToEntRef(ent));
			}
		}
	}
}

public void Chaos_Soccerballs_RESET(){
	RemoveEntitiesInArray(soccerballs);
}

public bool Chaos_Soccerballs_Conditions(bool EffectRunRandomly){
	if(!ValidMapPoints()) return false;
	return true;
}