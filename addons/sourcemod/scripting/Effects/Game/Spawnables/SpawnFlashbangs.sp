#define EFFECTNAME SpawnFlashbangs

SETUP(effect_data effect){
	effect.Title = "Flashbangs";
	effect.HasNoDuration = true;
}

START(){
	ShuffleMapSpawns();
	float vec[3];
	LoopAllMapSpawns(vec, i){
		if(GetRandomInt(0,100) <= 25){
			if(DistanceToClosestPlayer(vec) > 25){
				int flash = CreateEntityByName("flashbang_projectile");
				TeleportEntity(flash, vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(flash);
			}
		}	
	}
}

CONDITIONS(){
	if(!ValidMapPoints()) return false;
	return true;
}