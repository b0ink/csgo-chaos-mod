ArrayList Twitch_Votes;
bool alternateIndex = false;

#define LoopAllVotes(%1,%2) for(int %2 = 0; %2 < 999; %2++)\
									if(%2 < Twitch_Votes.Length)\
									if(Twitch_Votes.GetArray(%2, %1, sizeof(%1)))

/*
	bool EnsureValidEffect - Checks to see if the effect can be run (not disabled at time)
*/
enum struct vote_data{
	int votes;
	char name[128];
	char config_name[128];
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
	Twitch_Votes.Clear();
}

public Action Timer_DelayTwitchPool(Handle timer){
	Twitch_PoolNewVotingEffects(); //*start votes at the start of the round
}

public Action Command_GetVotes(int client, int args){
	
	ReplyToCommand(client, "%s", GetChaosTitle(g_sLastPlayedEffect));

	if(g_bChaos_TwitchEnabled){
		ReplyToCommand(client, "twitch-enabled");
	}else{
		ReplyToCommand(client, "twitch-disabled");
	}


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
	alternateIndex = !alternateIndex;
	Twitch_Votes.Clear();
	int randomEffect = -1;
	effect_data effect;
	do{
		int totalEffects = ChaosEffects.Length;
		randomEffect = GetRandomInt(0, totalEffects - 1);
		ChaosEffects.GetArray(randomEffect, effect, sizeof(effect));
		if(
			effect.enabled &&
			effect.can_run_effect() &&
			(!Effect_Recently_Played(effect.config_name)) &&
			effect.timer == INVALID_HANDLE &&
			effect.isCompatible() &&
			!IsEffectInVoteList(effect.config_name)
		){
			// PushArrayString(VotingEffects, effect.title);
			vote_data vote;
			vote.name = effect.title;
			vote.votes = 0;
			vote.config_name = effect.config_name;
			Twitch_Votes.PushArray(vote);
			PushArrayString(Effect_History, effect.config_name);

			float average = float((Possible_Chaos_Effects.Length / 4) * 3); //idk
			if(GetArraySize(Effect_History) > average) RemoveFromArray(Effect_History, 0);
		}
	}while(Twitch_Votes.Length < 4);

}


bool GetHighestVotedEffect(effect_data effectReturn, bool EnsureValidEffect = false){
	Twitch_Votes.Sort(Sort_Descending, Sort_Integer);

	bool ranEffects = false;
	vote_data vote;
	effect_data effect;
	
	LoopAllVotes(vote, index){
		GetEffectData(vote.config_name, effect);
		if(
			(effect.enabled &&
			effect.can_run_effect() &&
			// (!Effect_Recently_Played(effect.config_name)) &&
			effect.timer == INVALID_HANDLE &&
			effect.isCompatible())
			|| EnsureValidEffect
		){
			effectReturn = effect;
			ranEffects = true;
			break;
		}
	}
	if(!ranEffects){
		PrintToChatAll("couldnt find effect");
	}
	return ranEffects;
}