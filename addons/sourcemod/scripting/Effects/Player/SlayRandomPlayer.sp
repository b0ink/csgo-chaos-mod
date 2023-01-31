#pragma semicolon 1

//TODO: change to a slap player down to 50hp
public void Chaos_SlayRandomPlayer(effect_data effect){
	effect.Title = "Slay Random Player On Each Team";
	effect.Duration = 30;
	effect.HasNoDuration = true;
}

public void Chaos_SlayRandomPlayer_START(){
	int aliveCT = GetAliveCTCount();
	int aliveT = GetAliveTCount();
	int RandomTSlay = GetRandomInt(1, aliveT);
	int RandomCTSlay = GetRandomInt(1, aliveCT);

	if(aliveT > 1){
		aliveT = 0;
		LoopAlivePlayers(i){
			if(GetClientTeam(i) == CS_TEAM_T){
				aliveT++;
				if(aliveT == RandomTSlay){
					ForcePlayerSuicide(i);
				}
			}	
		}
	}
	if(aliveCT > 1){
		aliveCT = 0;
		LoopAlivePlayers(i){
			if(GetClientTeam(i) == CS_TEAM_CT){
				aliveCT++;
				if(aliveCT == RandomCTSlay){
					if(aliveCT){
						ForcePlayerSuicide(i);
					}
				}
			}	
		}
	}
}

public bool Chaos_SlayRandomPlayer_Conditions(bool EffectRunRandomly){
	if(GetAliveCTCount() <= 4) return false;
	if(GetAliveTCount() <= 4) return false;
	if(GetRoundTime() < 25 && EffectRunRandomly) return false;
	return true;
}