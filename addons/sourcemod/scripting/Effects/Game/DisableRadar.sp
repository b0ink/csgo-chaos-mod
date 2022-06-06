
public void Chaos_DisableRadar_START(){
	cvar("sv_disable_radar", "1");
}

public Action Chaos_DisableRadar_RESET(bool EndChaos){
	ResetCvar("sv_disable_radar", "0", "1");
}


public bool Chaos_DisableRadar_Conditions(){
	return true;
}