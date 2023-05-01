#pragma semicolon 1

public void Chaos_RespawnTheDead(EffectData effect){
	effect.Title = "Resurrect Dead Players";
	effect.AddAlias("Respawn");
	effect.HasNoDuration = true;
	effect.AddFlag("respawn");
	// effect.BlockInCoopStrike = true;
}

public void Chaos_RespawnTheDead_START(){
	if(IsCoopStrike()){
		// natively respawn co-op players
		ServerCommand("script \"ScriptCoopMissionRespawnDeadPlayers()\"");
	}else{
		LoopValidPlayers(i){
			if(!IsPlayerAlive(i)){
				CS_RespawnPlayer(i);
			}
		}
	}
}

public bool Chaos_RespawnTheDead_Conditions(bool EffectRunRandomly){
	if(GetRoundTime() <= 30 && EffectRunRandomly) return false;
	return true;
}