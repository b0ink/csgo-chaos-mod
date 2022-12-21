#define EFFECTNAME IgniteAllPlayers

SETUP(effect_data effect){
	effect.Title = "Ignite All Players";
	effect.HasNoDuration = true;
}
START(){
	LoopAlivePlayers(i){
		IgniteEntity(i, 10.0);
	}
}