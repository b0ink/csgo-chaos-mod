ArrayList Twitch_Votes;
bool alternateIndex = false;
bool EnableRandomEffectOption = true;

bool AppIsActive = false; // if the app does not rcon the server during a full round, the connvar will be disabled automatically.

// #define DEBUG_TWITCH_VOTES true

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

void RegisterTwitchCommands(){
	RegAdminCmd("chaos_votes", 					Command_GetVotes, 		ADMFLAG_ROOT);
	RegAdminCmd("save_chaos_vote", 				Command_SaveVote, 		ADMFLAG_ROOT);
}

void TWITCH_INIT(){
	Twitch_Votes = new ArrayList(sizeof(vote_data));
	HookEvent("round_start", 	Twitch_RoundStart);
	HookEvent("round_end", 		Twitch_RoundEnd);
}

public Action Twitch_RoundStart(Event event, char[] name, bool dontBroadcast){
	CreateTimer(0.1, Timer_DelayTwitchPool);
	if(!AppIsActive){
		g_cvChaosTwitchEnabled.SetBool(false);
	}
	AppIsActive = false;

#if defined DEBUG_TWITCH_VOTES
	CreateTimer(2.5, Timer_FakeTwitchVotes, _, TIMER_REPEAT);
#endif
	return Plugin_Continue;
}

#if defined DEBUG_TWITCH_VOTES
public Action Timer_FakeTwitchVotes(Handle timer){
	// int rand = 4;
	int rand = GetRandomInt(1, 4);
	ServerCommand("save_chaos_vote %i", rand);
	ServerCommand("save_chaos_vote %i", rand);
	ServerCommand("save_chaos_vote %i", rand);
	ServerCommand("save_chaos_vote %i", rand);
	if(!g_bCanSpawnEffect){
		return Plugin_Stop;
	}
	return Plugin_Continue;
}
#endif

public Action Twitch_RoundEnd(Event event, char[] name, bool dontBroadcast){
	//* Remove current items from the histor/cooldown, as we can assume those effects have not been run.
	vote_data effect;
	LoopAllVotes(effect, i){
		int index = FindStringInArray(EffectsHistory, effect.FunctionName);
		if(index != -1){
			RemoveFromArray(EffectsHistory, index);
		}
	}

	Twitch_Votes.Clear();
	return Plugin_Continue;
}

public Action Timer_DelayTwitchPool(Handle timer){
	if(g_cvChaosTwitchEnabled.BoolValue){
		Twitch_PoolNewVotingEffects(); //*start votes at the start of the round
	}
	return Plugin_Continue;
}


public Action Command_GetVotes(int client, int args){
	AppIsActive = true;
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

	bool isBatch = false;
	char sTotalVotes[4];
	if(args == 2){
		isBatch = true;
		GetCmdArg(2, sTotalVotes, sizeof(sTotalVotes));
	}
	int totalvotes = StringToInt(sTotalVotes);

	int vote = StringToInt(sVote);
	if(vote != 0 && g_bCanSpawnEffect && Twitch_Votes.Length >= 4){
		vote_data effect;
		vote = vote - 1; //offset array index
		Twitch_Votes.GetArray(vote, effect, sizeof(effect));

		if(isBatch){
			effect.votes = totalvotes;
		}else{
			effect.votes = effect.votes + 1;
		}		
		Twitch_Votes.SetArray(vote, effect);
		// ReplyToCommand(client, "success");
	}else{
		// ReplyToCommand(client, "could not save vote");
		// ReplyToCommand(client, "fail vote was: %i original string was %s", vote, sVote);
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

bool proportionalVoting = true;

bool GetHighestVotedEffect(effect_data effectReturn, bool EnsureValidEffect = false){
	bool ranEffects = false;

	if(proportionalVoting){
		Twitch_Votes.Sort(Sort_Ascending, Sort_Integer);

		vote_data effect1;
		vote_data effect2;
		vote_data effect3;
		vote_data effect4;
		
		Twitch_Votes.GetArray(0, effect1, sizeof(effect1));
		Twitch_Votes.GetArray(1, effect2, sizeof(effect2));
		Twitch_Votes.GetArray(2, effect3, sizeof(effect3));
		Twitch_Votes.GetArray(3, effect4, sizeof(effect4));
		
		int totalVotes = effect1.votes + effect2.votes + effect3.votes + effect4.votes;

		int check1 = effect1.votes;
		int check2 = check1 + effect2.votes;
		int check3 = check2 + effect3.votes;
		int check4 = check3 + effect4.votes;

		int randomNumber = GetRandomInt(1, totalVotes);
		ranEffects = true;
		if(randomNumber <= check1){
			GetEffectData(effect1.FunctionName, effectReturn);
		}else if(randomNumber <= check2){
			GetEffectData(effect2.FunctionName, effectReturn);
		}else if(randomNumber <= check3){
			GetEffectData(effect3.FunctionName, effectReturn);
		}else if(randomNumber <= check4){
			GetEffectData(effect4.FunctionName, effectReturn);
		}else{
			ranEffects = false;
		}
	}else{
		Twitch_Votes.Sort(Sort_Descending, Sort_Integer);

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
	}
	return ranEffects;
}