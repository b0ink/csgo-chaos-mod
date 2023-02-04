#pragma semicolon 1

public void Chaos_SmokeStrat(effect_data effect){
	effect.Title = "Smoke Strat";
	effect.HasNoDuration = true;
}

public void Chaos_SmokeStrat_START(){
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			CreateParticle("explosion_smokegrenade_fallback", vec);
		}
	}
}

public bool Chaos_SmokeStrat_Conditions(bool EffectRunRandomly){
	if(!ValidMapPoints()) return false;
	return true;
}