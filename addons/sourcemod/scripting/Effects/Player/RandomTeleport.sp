#pragma semicolon 1

public void Chaos_RandomTeleport(effect_data effect){
	effect.Title = "Random Teleport";
	effect.Duration = 30;
	effect.HasNoDuration = true;
}

public void Chaos_RandomTeleport_START(){
	DoRandomTeleport();
}