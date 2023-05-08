#pragma semicolon 1

ArrayList SnowEnt;
public void Chaos_Snow(EffectData effect){
	effect.Title = "Snow";
	effect.Duration = 45;
	effect.AddFlag("fog");
	effect.AddAlias("Visual");
	SnowEnt = new ArrayList();
}

public void Chaos_Snow_START(){
	SnowEnt.Push(EntIndexToEntRef(SPAWN_WEATHER(SNOWFALL, "Snow")));
	SnowEnt.Push(EntIndexToEntRef(SPAWN_WEATHER(SNOWFALL, "Snow")));
	SnowEnt.Push(EntIndexToEntRef(SPAWN_WEATHER(SNOWFALL, "Snow")));
	MinimalFog();
}

public void Chaos_Snow_RESET(int ResetType){
	RemoveEntitiesInArray(SnowEnt);
	MinimalFog(true);
}

public bool Chaos_Snow_Conditions(bool EffectRunRandomly){
	if(StrEqual(g_sCurrentMapName, "de_dust2", false) && EffectRunRandomly){
		return false; //doesnt work on dust2
	}
	return true;
}
