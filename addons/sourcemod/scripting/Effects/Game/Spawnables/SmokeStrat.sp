public void Chaos_SmokeStrat_START(){
	for(int i = 0; i < GetArraySize(g_MapCoordinates); i++){
		if(GetRandomInt(0,100) <= 25){
			float vec[3];
			GetArrayArray(g_MapCoordinates, i, vec);
			CreateParticle("explosion_smokegrenade_fallback", vec);
		}
	}
}

public Action Chaos_SmokeStrat_RESET(bool EndChaos){

}

public bool Chaos_SmokeStrat_HasNoDuration(){
	return false;
}

public bool Chaos_SmokeStrat_Conditions(){
	return true;
}