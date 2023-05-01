public void Chaos_SpawnEnemyWave(EffectData effect){
	effect.Title = "Spawn Enemy Wave";
	effect.HasNoDuration = true;
	effect.AddAlias("coop");
	effect.AddAlias("strike");
}

public void Chaos_SpawnEnemyWave_START(){
	ServerCommand("script \"ScriptCoopMissionSpawnNextWave(10);\"");
}

public bool Chaos_SpawnEnemyWave_Conditions(){
	if(GetAliveTCount() >= 10){
		return false;
	}
	return IsCoopStrike();
}