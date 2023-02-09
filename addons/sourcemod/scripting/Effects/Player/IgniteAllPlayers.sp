#pragma semicolon 1

public void Chaos_IgniteAllPlayers(EffectData effect){
	effect.Title = "Ignite All Players";
	effect.HasNoDuration = true;
}
public void Chaos_IgniteAllPlayers_START(){
	LoopAlivePlayers(i){
		IgniteEntity(i, 5.0);
	}
}