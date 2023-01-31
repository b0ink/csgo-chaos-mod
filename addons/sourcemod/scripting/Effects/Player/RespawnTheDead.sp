#pragma semicolon 1

public void Chaos_RespawnTheDead(effect_data effect){
	effect.Title = "Resurrect Dead Players";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
	effect.AddFlag("respawn");
}

public void Chaos_RespawnTheDead_START(){
	LoopValidPlayers(i){
		if(!IsPlayerAlive(i)){
			CS_RespawnPlayer(i);
		}
	}
}

public bool Chaos_RespawnTheDead_Conditions(bool EffectRunRandomly){
	if(GetRoundTime() <= 30 && EffectRunRandomly) return false;
	return true;
}