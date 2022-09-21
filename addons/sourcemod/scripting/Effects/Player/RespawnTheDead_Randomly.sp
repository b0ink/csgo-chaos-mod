public void Chaos_RespawnTheDead_Randomly(effect_data effect){
	effect.title = "Resurrect dead players in random locations";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
}
public void Chaos_RespawnTheDead_Randomly_START(){
	LoopValidPlayers(i){
		if(!IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
			DoRandomTeleport(i);
		}
	}
}

public bool Chaos_RespawnTheDead_Randomly_Conditions(){
	if(g_iChaos_Round_Time <= 30) return false;
	return true;
}