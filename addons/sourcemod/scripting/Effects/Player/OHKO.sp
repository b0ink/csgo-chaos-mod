public void Chaos_OHKO(effect_data effect){
	effect.Title = "1 HP";
	effect.Duration = 15;
	
	effect.AddAlias("1 HP");
	effect.AddAlias("Knockout");
	effect.AddAlias("One Hit Knock Out");
}

public void Chaos_OHKO_START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, 1);
	}
}

public Action Chaos_OHKO_RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			SetEntityHealth(i, 100);
		}
	}
}