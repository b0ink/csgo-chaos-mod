public void Chaos_Jackpot(effect_data effect){
	effect.title = "Jackpot";
	effect.HasNoDuration = true;
}
public void Chaos_Jackpot_START(){
	LoopValidPlayers(i){
		EmitSoundToClient(i, SOUND_MONEY, _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
		SetClientMoney(i, 16000);
	}
}