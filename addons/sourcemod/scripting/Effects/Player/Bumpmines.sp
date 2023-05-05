#pragma semicolon 1

public void Chaos_Bumpmines(EffectData effect){
	effect.Title = "Bumpmines";
	effect.HasNoDuration = true;
	effect.BlockInCoopStrike = true;
}
public void Chaos_Bumpmines_START(){
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_bumpmine");
	}
}