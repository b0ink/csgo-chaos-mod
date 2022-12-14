SETUP(effect_data effect){
	effect.Title = "Snow";
	effect.Duration = 45;
	effect.AddFlag("fog");
}
INIT(){
	
}

START(){
	SPAWN_WEATHER(SNOWFALL, "Snow");
	SPAWN_WEATHER(SNOWFALL, "Snow");
	SPAWN_WEATHER(SNOWFALL, "Snow");
	MinimalFog();
}

RESET(bool HasTimerEnded){
	char classname[64];
	char targetname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
		if(StrEqual(targetname, "Snow")){
			RemoveEntity(ent);
		}
	}
	MinimalFog(true);
	// Fog_OFF();
}

CONDITIONS(){
	if(StrEqual(mapName, "de_dust2", false)){
		return false; //doesnt work on dust2
	}
	return true;
}
