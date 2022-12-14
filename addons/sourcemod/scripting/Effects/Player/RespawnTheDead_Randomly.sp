#define EFFECTNAME RespawnTheDead_Randomly

SETUP(effect_data effect){
	effect.Title = "Resurrect dead players in random locations";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
	effect.AddFlag("respawn");
}
START(){
	LoopValidPlayers(i){
		if(!IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			DoRandomTeleport(i);
		}
	}
}

CONDITIONS(){
	if(g_iChaosRoundTime <= 30) return false;
	return true;
}