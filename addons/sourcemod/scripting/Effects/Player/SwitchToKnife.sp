public void Chaos_SwitchToKnife(EffectData effect){
	effect.Title = "Pull out knife";
	effect.HasNoDuration = true;
}

public void Chaos_SwitchToKnife_START(){
	LoopAlivePlayers(i){
		SwitchToKnife(i);
	}
}