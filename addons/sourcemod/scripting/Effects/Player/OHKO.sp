#pragma semicolon 1

public void Chaos_OHKO(EffectData effect){
	effect.Title = "1 HP";
	effect.Duration = 10;
	
	effect.AddAlias("1 HP");
	effect.AddAlias("Knockout");
	effect.AddAlias("One Hit Knock Out");

	effect.IncompatibleWith("Chaos_Thunderstorm");
	effect.IncompatibleWith("Chaos_Armageddon");
	effect.IncompatibleWith("Chaos_ExplosiveBullets");
	effect.IncompatibleWith("Chaos_ExplodingBarrels");
	effect.IncompatibleWith("Chaos_LavaFloor");
	effect.IncompatibleWith("Chaos_IgniteAllPlayers");
}

public void Chaos_OHKO_START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, 1);
	}
}

public void Chaos_OHKO_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		LoopAlivePlayers(i){
			SetEntityHealth(i, 100);
		}
	}
}

public void Chaos_OHKO_OnPlayerSpawn(int client){
	SetEntityHealth(client, 1);
}