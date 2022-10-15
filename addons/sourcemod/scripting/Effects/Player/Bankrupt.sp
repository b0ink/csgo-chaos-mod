public void Chaos_Bankrupt(effect_data effect){
	effect.Title = "Bankrupt";
	effect.HasNoDuration = true;
	effect.AddAlias("Money");
}

public void Chaos_Bankrupt_START(){
	LoopAlivePlayers(i){
		SetClientMoney(i, 0, true);
	}
}