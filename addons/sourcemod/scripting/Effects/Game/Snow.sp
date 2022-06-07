public void Chaos_Snow_INIT(){
	
}

public void Chaos_Snow_START(){
	SPAWN_WEATHER(SNOWFALL);
	SPAWN_WEATHER(SNOWFALL);
	SPAWN_WEATHER(SNOWFALL);
	//todo add little fog
}


public Action Chaos_Snow_RESET(bool EndChaos){

}


public bool Chaos_Snow_Conditions(){
	return true;
}
