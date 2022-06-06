public void Chaos_LightsOff_START(){
	LightsOff();
}

public Action Chaos_LightsOff_RESET(bool EndChaos){
	Fog_OFF();
}

public bool Chaos_LightsOff_HasNoDuration(){
	return false;
}

public bool Chaos_LightsOff_Conditions(){
	return true;
}