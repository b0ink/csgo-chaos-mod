public void Chaos_IgniteAllPlayers(effect_data effect){
	effect.Title = "Ignite All Players";
	effect.HasNoDuration = true;
}
public void Chaos_IgniteAllPlayers_START(){
	LoopAlivePlayers(i){
		IgniteEntity(i, 10.0);
	}
}