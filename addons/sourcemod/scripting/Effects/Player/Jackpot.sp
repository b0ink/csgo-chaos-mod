#pragma semicolon 1


public void Chaos_Jackpot(EffectData effect){
	effect.Title = "Jackpot";
	effect.HasNoDuration = true;
}

public void Chaos_Jackpot_OnMapStart(){
	PrecacheSound("survival/money_collect_04.wav");
}
public void Chaos_Jackpot_START(){
	LoopValidPlayers(i){
		EmitSoundToClient(i, "survival/money_collect_04.wav", _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
		SetClientMoney(i, 16000);
	}
}