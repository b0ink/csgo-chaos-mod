public void Chaos_Jackpot_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			EmitSoundToClient(i, SOUND_MONEY, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
			SetClientMoney(i, 16000);
		}
	}
}

public Action Chaos_Jackpot_RESET(bool EndChaos){

}

public bool Chaos_Jackpot_HasNoDuration(){
	return false;
}

public bool Chaos_Jackpot_Conditions(){
	return true;
}