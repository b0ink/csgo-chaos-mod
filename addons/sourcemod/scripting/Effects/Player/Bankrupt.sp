public void Chaos_Bankrupt(effect_data effect){
	effect.HasNoDuration = true;
}

public void Chaos_Bankrupt_START(){
	LoopAlivePlayers(i){
		SetClientMoney(i, 0, true);
	}
}