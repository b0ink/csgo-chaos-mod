public void Chaos_RandomSkybox_START(){
	int randomSkyboxIndex = GetRandomInt(0, sizeof(g_sSkyboxes)-1);
	DispatchKeyValue(0, "skyname", g_sSkyboxes[randomSkyboxIndex]);
}

public Action Chaos_RandomSkybox_RESET(bool EndChaos){

}

public bool Chaos_RandomSkybox_HasNoDuration(){
	return true;
}

public bool Chaos_RandomSkybox_Conditions(){
	return true;
}