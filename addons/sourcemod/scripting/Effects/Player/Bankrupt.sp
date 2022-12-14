SETUP(effect_data effect){
	effect.Title = "Bankrupt";
	effect.HasNoDuration = true;
	effect.AddAlias("Money");
}

START(){
	LoopAlivePlayers(i){
		SetClientMoney(i, 0, true);
	}
}