StringMap Twitch_Votes;
Handle VotingEffects = INVALID_HANDLE;
// StringMapSnapshot Twitch_Votes_Snapshot;
bool alternateIndex = false;

public Action Command_GetVotes(int client, int args){
	
	char effectName[128];
	int index = 1;
	if(alternateIndex){
		index = 5;
	}
	for(int i = 0; i < GetArraySize(VotingEffects); i++){
		GetArrayString(VotingEffects, i, effectName, sizeof(effectName));
		int voteCount = 0;
		Twitch_Votes.GetValue(effectName, voteCount);
		ReplyToCommand(client, "%i--%s--%i", index, effectName, voteCount);
		index++;
	}

	return Plugin_Handled;
}


public Action Command_SaveVote(int client, int args){
	char sVote[2];
	GetCmdArg(1, sVote, sizeof(sVote));

	int vote = StringToInt(sVote);
	char effectName[128];
	GetArrayString(VotingEffects, vote, effectName, sizeof(effectName));
	int currentVotes = 0;
	Twitch_Votes.GetValue(effectName, currentVotes);
	int newVotes = currentVotes + 1;
	Twitch_Votes.SetValue(effectName, newVotes);
	return Plugin_Handled;
}

void TWITCH_INIT(){
	Twitch_Votes = new StringMap();
	VotingEffects = CreateArray(128);
}

void Twitch_PoolNewVotingEffects(){
	alternateIndex = !alternateIndex;
	ClearArray(VotingEffects);
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
			FindStringInArray(VotingEffects, effect.config_name) == -1
		){
			PushArrayString(VotingEffects, effect.title);
			PushArrayString(Effect_History, effect.config_name);

			float average = float((Possible_Chaos_Effects.Length / 4) * 3); //idk
			if(GetArraySize(Effect_History) > average) RemoveFromArray(Effect_History, 0);
		}
	}while(GetArraySize(VotingEffects) < 4);

	char effectName[128];
	for(int i = 0; i < GetArraySize(VotingEffects); i++){
		GetArrayString(VotingEffects, i, effectName, sizeof(effectName));
		Twitch_Votes.SetValue(effectName, 0);
	}
}