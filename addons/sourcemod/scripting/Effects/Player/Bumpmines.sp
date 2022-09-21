public void Chaos_Bumpmines(effect_data effect){
	effect.title = "Bumpmines";
	effect.HasNoDuration = true;
}
public void Chaos_Bumpmines_START(){
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_bumpmine");
	}
}