#define EFFECTNAME RespawnTheDead

SETUP(effect_data effect){
	effect.Title = "Resurrect Dead Players";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
	effect.AddFlag("respawn");
}

START(){
	LoopValidPlayers(i){
		if(!IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
		}
	}
}

CONDITIONS(){
	if(g_iChaosRoundTime <= 30) return false;
	return true;
}