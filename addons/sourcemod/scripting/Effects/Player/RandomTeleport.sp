public void Chaos_RandomTeleport(effect_data effect){
	effect.title = "Random Teleport";
	effect.duration = 30;
	effect.HasNoDuration = true;
}

public void Chaos_RandomTeleport_START(){
	DoRandomTeleport();
}