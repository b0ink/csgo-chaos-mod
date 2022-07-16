public void Chaos_Snow_INIT(){
	
}

public void Chaos_Snow_START(){
	SPAWN_WEATHER(SNOWFALL, "Snow");
	SPAWN_WEATHER(SNOWFALL, "Snow");
	SPAWN_WEATHER(SNOWFALL, "Snow");
	MinimalFog();
}

public Action Chaos_Snow_RESET(bool HasTimerEnded){
	char classname[64];
	char targetname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
		if(StrEqual(targetname, "Snow")){
			RemoveEntity(ent);
		}
	}
	Fog_OFF();
}

public bool Chaos_Snow_HasNoDuration(){
	return false;
}

public bool Chaos_Snow_Conditions(){
	if(StrEqual(mapName, "de_dust2", false)){
		return false; //doesnt work on dust2
	}
	return true;
}
