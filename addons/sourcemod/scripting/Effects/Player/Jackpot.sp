public void Chaos_Jackpot_START(){
	LoopValidPlayers(i){
		EmitSoundToClient(i, SOUND_MONEY, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
		SetClientMoney(i, 16000);
	}
}

public Action Chaos_Jackpot_RESET(bool HasTimerEnded){

}

public bool Chaos_Jackpot_HasNoDuration(){
	return true;
}

public bool Chaos_Jackpot_Conditions(){
	return true;
}