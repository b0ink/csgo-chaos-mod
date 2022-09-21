public void Chaos_TeleportFewMetres(effect_data effect){
	effect.title = "Teleport Players A Few Metres";
	effect.duration = 30;
	effect.HasNoDuration = true;
}

public void Chaos_TeleportFewMetres_START(){
	SavePlayersLocations();
	TeleportPlayersToClosestLocation(-1, 350); //250 units of minimum teleport distance
}