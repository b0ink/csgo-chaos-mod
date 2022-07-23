public void Chaos_SpawnFlashbangs(effect_data effect){
	effect.HasNoDuration = true;
}

float flashbang_vec[3];
public void Chaos_SpawnFlashbangs_START(){
	LoopMapPoints(i)
	{
		if(GetRandomInt(0,100) <= 25){
			GetArrayArray(g_MapCoordinates, i, flashbang_vec, sizeof(flashbang_vec));
			if(DistanceToClosestPlayer(flashbang_vec) > 25){
				int flash = CreateEntityByName("flashbang_projectile");
				TeleportEntity(flash, flashbang_vec, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(flash);
			}
		}	
	}
}

public bool Chaos_SpawnFlashbangs_Conditions(){
	if(!ValidMapPoints()) return false;
	return true;
}