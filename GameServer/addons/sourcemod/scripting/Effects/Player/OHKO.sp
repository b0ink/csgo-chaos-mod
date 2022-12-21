#define EFFECTNAME OHKO

SETUP(effect_data effect){
	effect.Title = "1 HP";
	effect.Duration = 15;
	
	effect.AddAlias("1 HP");
	effect.AddAlias("Knockout");
	effect.AddAlias("One Hit Knock Out");
}

START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, 1);
	}
}

RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			SetEntityHealth(i, 100);
		}
	}
}

public void Chaos_OHKO_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntityHealth(client, 1);
	}
}