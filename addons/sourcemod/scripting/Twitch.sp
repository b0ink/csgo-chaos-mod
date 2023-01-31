#pragma semicolon 1

ArrayList Twitch_Votes;
bool alternateIndex = false;
bool EnableRandomEffectOption = true;

int expectedTimeForNewEffect = 0;
bool AppIsActive = false; // if the app does not rcon the server during a full round, the connvar will be disabled automatically.

// #define DEBUG_TWITCH_VOTES true

#define LoopAllVotes(%1,%2) for(int %2 = 0; %2 < 999; %2++) if(%2 < Twitch_Votes.Length) if(Twitch_Votes.GetArray(%2, %1, sizeof(%1)))

enum struct vote_data{
	int votes;
	char name[128];
	char FunctionName[128];
}

// When the twitch app calls `chaos_votes`, it passes the most potential winning effect back to the plugin, so if the timing is off it will know what was the most voted effect
void RegisterTwitchCommands(){
	RegAdminCmd("chaos_votes", 					Command_GetVotes, 		ADMFLAG_ROOT);
	// RegAdminCmd("save_chaos_vote", 				Command_SaveVote, 		ADMFLAG_ROOT);
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
	//* Remove current items from the history/cooldown, as we can assume those effects have not been run.
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
		Twitch_PoolNewVotingEffects(); //* start votes at the start of the round
	}
	return Plugin_Continue;
}


public Action Command_GetVotes(int client, int args){
	char votedEffect[64];
	if(args == 1){
		GetCmdArg(1, votedEffect, 64);
	}

	if(votedEffect[0] != '\0'){
		g_sForceCustomEffect = votedEffect;
	}

	AppIsActive = true;
	if(GetPlayerCount() == 0){
		g_cvChaosTwitchEnabled.SetInt(0);
	}

	int index = 1;
	if(alternateIndex) index = 5;

	
	char json[1024];

	Format(json, sizeof(json), "{");
	Format(json, sizeof(json), "%s\"lastPlayedEffect\":\"%s\",", json, g_sLastPlayedEffect);
	Format(json, sizeof(json), "%s\"twitchEnabled\":%s,", json, g_cvChaosTwitchEnabled.BoolValue ? "true" : "false");
	Format(json, sizeof(json), "%s\"newEffectTime\":%i,", json, expectedTimeForNewEffect);
	Format(json, sizeof(json), "%s\"hideEffectList\":%s,", json, (GameRules_GetProp("m_bWarmupPeriod") == 1 || !g_bCanSpawnEffect) ? "true" : "false");
	Format(json, sizeof(json), "%s\"effects\":[", json);
	
	vote_data effect;
	for(int i = 0; i < Twitch_Votes.Length; i++){
		Twitch_Votes.GetArray(i, effect, sizeof(effect));
		Format(json, sizeof(json), "%s%s{\"index\":%i,\"name\":\"%s\", \"function\":\"%s\"}", json, (i > 0) ? "," : "", index, effect.name, effect.FunctionName);
		// Format(json, sizeof(json), "%s{\"index\":%i,\"name\":\"%s\",\"votes\":%i, \"function\":\"%s\"},", json, index, effect.name, effect.votes, effect.FunctionName);
		index++;
	}

	Format(json, sizeof(json), "%s]}", json);
	// Format(json, sizeof(json), "%s}", json);
	
	ReplyToCommand(client, json);
	
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
			(!Effect_Recently_Played(effect.FunctionName)) &&
			effect.Timer == INVALID_HANDLE &&
			effect.IsCompatible() &&
			!IsEffectInVoteList(effect.FunctionName) &&
			!effect.IsMetaEffect &&
			effect.CanRunEffect(true)
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