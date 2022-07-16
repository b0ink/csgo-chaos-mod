public void Chaos_Snow_INIT(){
	
}

public void Chaos_Snow_START(){
	SPAWN_WEATHER(SNOWFALL);
	SPAWN_WEATHER(SNOWFALL);
	SPAWN_WEATHER(SNOWFALL);
	MinimalFog();
}

public Action Chaos_Snow_RESET(bool HasTimerEnded){

}

public bool Chaos_Snow_HasNoDuration(){
	return true;
}

public bool Chaos_Snow_Conditions(){
	if(StrEqual(mapName, "de_dust2", false)){
		return false; //doesnt work on dust2
	}
	return true;
}
