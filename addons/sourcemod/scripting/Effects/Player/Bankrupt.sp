#pragma semicolon 1

public void Chaos_Bankrupt(EffectData effect){
	effect.Title = "Bankrupt";
	effect.HasNoDuration = true;
	effect.AddAlias("Money");
	effect.BlockInCoopStrike = true;
}

public void Chaos_Bankrupt_START(){
	LoopAlivePlayers(i){
		SetClientMoney(i, 0, true);
	}
}