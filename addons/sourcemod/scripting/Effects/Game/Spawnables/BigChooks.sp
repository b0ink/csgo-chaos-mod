#pragma semicolon 1

public void Chaos_BigChooks(EffectData effect){
	effect.Title = "Big Chooks";
	effect.AddAlias("Chicken");
	effect.Duration = 60;
	effect.AddFlag("chicken");
}


public void Chaos_BigChooks_START(){
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		int chance = GetRandomInt(0,100);
		if(chance <= 25){ //too many chickens is a no no
			int ent = CreateEntityByName("chicken");
			if(ent != -1){
				float vec[3];
				GetArrayArray(g_MapCoordinates, i, vec);
				TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
				float randomSize = GetRandomFloat(2.0, 15.0);
				DispatchSpawn(ent);
				SetEntPropFloat(ent, Prop_Data, "m_flModelScale", randomSize);
				DispatchKeyValue(ent, "targetname", "BigChooks");
			}
		}
	
	}
}

public void Chaos_BigChooks_RESET(int ResetType){
	RemoveChickens(.chickenName="BigChooks");
}

public bool Chaos_BigChooks_Conditions(bool EffectRunRandomly){
	if(!ValidMapPoints()) return false;
	if(!CanSpawnChickens() && EffectRunRandomly) return false;
	return true;
}