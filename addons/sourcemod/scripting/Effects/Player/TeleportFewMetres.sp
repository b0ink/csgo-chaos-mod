public void Chaos_TeleportFewMetres(effect_data effect){
	effect.Title = "Teleport Players A Few Metres";
	effect.Duration = 30;
	effect.HasNoDuration = true;
}

public void Chaos_TeleportFewMetres_START(){
	SavePlayersLocations();
	TeleportPlayersToClosestLocation(-1, 350); //250 units of minimum teleport distance
}