SETUP(effect_data effect){
	effect.Title = "Random Teleport";
	effect.Duration = 30;
	effect.HasNoDuration = true;
}

START(){
	DoRandomTeleport();
}