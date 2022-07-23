public void Chaos_RespawnTheDead(effect_data effect){
	effect.HasNoDuration = true;
}

public void Chaos_RespawnTheDead_START(){
	LoopValidPlayers(i){
		if(!IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
		}
	}
}

public bool Chaos_RespawnTheDead_Conditions(){
	if(g_iChaos_Round_Time <= 30) return false;
	return true;
}