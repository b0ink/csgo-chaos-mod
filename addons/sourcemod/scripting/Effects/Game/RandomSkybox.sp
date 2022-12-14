SETUP(effect_data effect){
	effect.Title = "Random Skybox";
	effect.HasNoDuration = true;
}
START(){
	int randomSkyboxIndex = GetRandomInt(0, sizeof(g_sSkyboxes)-1);
	DispatchKeyValue(0, "skyname", g_sSkyboxes[randomSkyboxIndex]);
}

CONDITIONS(){
	if(StrEqual(mapName, "de_dust2")){
		return false;
	}
	return true;
}