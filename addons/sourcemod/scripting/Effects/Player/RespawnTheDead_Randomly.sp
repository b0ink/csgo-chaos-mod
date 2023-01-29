#pragma semicolon 1

public void Chaos_RespawnTheDead_Randomly(effect_data effect){
	effect.Title = "Resurrect dead players in random locations";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
	effect.AddFlag("respawn");
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
	if(g_iChaosRoundTime <= 30) return false;
	return true;
}