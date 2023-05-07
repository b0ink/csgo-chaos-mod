#pragma semicolon 1

public void Chaos_SpawnFlashbangs(EffectData effect){
	effect.Title = "Flashbangs";
	effect.HasNoDuration = true;
}

public void Chaos_SpawnFlashbangs_START(){
	ShuffleMapSpawns();
	float vec[3];
	LoopAllMapSpawns(vec, i){
		if(GetRandomInt(0,100) <= 25){
			if(IsCoopStrike() && DistanceToClosestPlayer(vec) > MAX_COOP_SPAWNDIST) continue;
			if(DistanceToClosestPlayer(vec) > 25){
				int flash = CreateEntityByName("flashbang_projectile");
				TeleportEntity(flash, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(flash);
			}
		}	
	}
}

public bool Chaos_SpawnFlashbangs_Conditions(bool EffectRunRandomly){
	if(!ValidMapPoints()) return false;
	return true;
}