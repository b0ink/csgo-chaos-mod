#pragma semicolon 1

public void Chaos_HealAllPlayers(EffectData effect){
	effect.Title = "Heal All Players";
	effect.HasNoDuration = true;
}

public void Chaos_HealAllPlayers_START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, 100);
	}
}