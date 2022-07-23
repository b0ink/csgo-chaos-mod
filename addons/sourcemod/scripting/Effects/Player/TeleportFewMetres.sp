public void Chaos_TeleportFewMetres(effect_data effect){
	effect.HasNoDuration = true ;
}

public void Chaos_TeleportFewMetres_START(){
	SavePlayersLocations();
	TeleportPlayersToClosestLocation(-1, 350); //250 units of minimum teleport distance
}