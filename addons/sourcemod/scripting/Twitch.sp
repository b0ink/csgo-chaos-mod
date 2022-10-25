ArrayList Twitch_Votes;
bool alternateIndex = false;
bool EnableRandomEffectOption = true;

#define LoopAllVotes(%1,%2) for(int %2 = 0; %2 < 999; %2++)\
									if(%2 < Twitch_Votes.Length)\
									if(Twitch_Votes.GetArray(%2, %1, sizeof(%1)))

/*
	bool EnsureValidEffect - Checks to see if the effect can be run (not disabled at time)
*/
enum struct vote_data{
	int votes;
	char name[128];
	char FunctionName[128];
}

void TWITCH_INIT(){
	Twitch_Votes = new ArrayList(sizeof(vote_data));
	HookEvent("round_start", 	Twitch_RoundStart);
	HookEvent("round_end", 		Twitch_RoundEnd);
}

public Action Twitch_RoundStart(Event event, char[] name, bool dontBroadcast){
	CreateTimer(0.1, Timer_DelayTwitchPool);
}

public Action Twitch_RoundEnd(Event event, char[] name, bool dontBroadcast){
	//* Remove current items from the histor/cooldown, as we can assume those effects have not been run.
	vote_data effect;
	LoopAllVotes(effect, i){
		int index = FindStringInArray(EffectsHistory, effect.FunctionName);
		if(index != -1){
			RemoveFromArray(EffectsHistory, i);
		}
	}

	Twitch_Votes.Clear();
}

public Action Timer_DelayTwitchPool(Handle timer){
	Twitch_PoolNewVotingEffects(); //*start votes at the start of the round
}

public Action Command_GetVotes(int client, int args){
	if(GetPlayerCount() == 0){
		g_cvChaosTwitchEnabled.SetInt(0);
	}



	ReplyToCommand(client, "%s", GetChaosTitle(g_sLastPlayedEffect));

	if(g_cvChaosTwitchEnabled.BoolValue){
		ReplyToCommand(client, "twitch-enabled");
	}else{
		ReplyToCommand(client, "twitch-disabled");
	}
	// ReplyToCommand(client, "warmup: %i", GameRules_GetProp("m_bWarmupPeriod"));
	int hideEffects = 0;
	if(GameRules_GetProp("m_bWarmupPeriod") == 1 || !g_bCanSpawnEffect){
		hideEffects = 1;
	}
	ReplyToCommand(client, "hideEffects: %i", hideEffects);

	int index = 1;
	if(alternateIndex){
		index = 5;
	}

	vote_data effect;
	for(int i = 0; i < Twitch_Votes.Length; i++){
		Twitch_Votes.GetArray(i, effect, sizeof(effect));
		ReplyToCommand(client, "%i--%s--%i", index, effect.name, effect.votes);
		index++;
	}

	return Plugin_Handled;
}


public Action Command_SaveVote(int client, int args){
	char sVote[2];
	GetCmdArg(1, sVote, sizeof(sVote));

	int vote = StringToInt(sVote);
	if(vote != 0){
		vote_data effect;
		vote = vote - 1; //offset array index
		Twitch_Votes.GetArray(vote, effect, sizeof(effect));
		effect.votes = effect.votes + 1;
		Twitch_Votes.SetArray(vote, effect);
		ReplyToCommand(client, "success");
	}else{
		ReplyToCommand(client, "fail vote was: %i original string was %s", vote, sVote);
	}

	return Plugin_Handled;
}


bool IsEffectInVoteList(char[] effectName){
	vote_data effect;
	LoopAllVotes(effect, index){
		if(StrEqual(effect.name, effectName, false)){
			return true;
		}
	}
	return false;
}

void Twitch_PoolNewVotingEffects(){
	ArrayList Temp_ChaosEffects = ChaosEffects.Clone();

	Temp_ChaosEffects.Sort(Sort_Random, Sort_String);

	alternateIndex = !alternateIndex;
	Twitch_Votes.Clear();
	effect_data effect;

	for(int i = 0; i < Temp_ChaosEffects.Length; i++){
		Temp_ChaosEffects.GetArray(i, effect, sizeof(effect));
		if(i < Temp_ChaosEffects.Length - 4){
			if(GetRandomInt(0,100) < 50){
				continue; // bit more randomisation
			}
		}

		if(
			effect.Enabled &&
			effect.CanRunEffect() &&
			(!Effect_Recently_Played(effect.FunctionName)) &&
			effect.Timer == INVALID_HANDLE &&
			effect.IsCompatible() &&
			!IsEffectInVoteList(effect.FunctionName) &&
			!effect.IsMetaEffect
		){
			// PushArrayString(VotingEffects, effect.Title);
			vote_data vote;
			vote.name = effect.Title;
			vote.votes = 0;
			vote.FunctionName = effect.FunctionName;
			Twitch_Votes.PushArray(vote);
			PushArrayString(EffectsHistory, effect.FunctionName);

			float average = float((PossibleChaosEffects.Length / 4) * 3); //idk
			if(GetArraySize(EffectsHistory) > average) RemoveFromArray(EffectsHistory, 0);
		}else{
			// PrintToChatAll("cant run %s", effect.FunctionName);
		}
		if(EnableRandomEffectOption){
			if(Twitch_Votes.Length >= 3) break;
		}else{
			if(Twitch_Votes.Length >= 4) break;
		}
	}

	delete Temp_ChaosEffects;

	if(EnableRandomEffectOption){
		vote_data randomVote;
		randomVote.name = "Random Effect";
		randomVote.votes = 0;
		randomVote.FunctionName = "RANDOMEFFECT";
		Twitch_Votes.PushArray(randomVote);

	}

}


bool GetHighestVotedEffect(effect_data effectReturn, bool EnsureValidEffect = false){
	Twitch_Votes.Sort(Sort_Descending, Sort_Integer);

	bool ranEffects = false;
	vote_data vote;
	effect_data effect;
	
	LoopAllVotes(vote, index){
		GetEffectData(vote.FunctionName, effect);
		if(index == 0 && StrEqual(vote.FunctionName, "RANDOMEFFECT", false)){
			break;
		}
		if(
			(effect.Enabled &&
			effect.CanRunEffect() &&
			// (!Effect_Recently_Played(effect.FunctionName)) &&
			effect.Timer == INVALID_HANDLE &&
			effect.IsCompatible())
			|| EnsureValidEffect
		){
			effectReturn = effect;
			ranEffects = true;
			break;
		}
	}
	if(!ranEffects){
		// PrintToChatAll("couldnt find effect");
	}
	return ranEffects;
}