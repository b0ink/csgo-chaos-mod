public void Chaos_RandomSkybox(effect_data effect){
	effect.HasNoDuration = true;
}
public void Chaos_RandomSkybox_START(){
	int randomSkyboxIndex = GetRandomInt(0, sizeof(g_sSkyboxes)-1);
	DispatchKeyValue(0, "skyname", g_sSkyboxes[randomSkyboxIndex]);
}

public bool Chaos_RandomSkybox_Conditions(){
	if(StrEqual(mapName, "de_dust2")){
		return false;
	}
	return true;
}