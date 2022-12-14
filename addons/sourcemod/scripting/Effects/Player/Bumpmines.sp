SETUP(effect_data effect){
	effect.Title = "Bumpmines";
	effect.HasNoDuration = true;
}
START(){
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_bumpmine");
	}
}