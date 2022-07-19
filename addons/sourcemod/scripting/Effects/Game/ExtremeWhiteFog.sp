public void Chaos_ExtremeWhiteFog_START(){
	ExtremeWhiteFog();
}

public Action Chaos_ExtremeWhiteFog_RESET(bool HasTimerEnded){
	ExtremeWhiteFog(true);
	// Fog_OFF();
}


public bool Chaos_ExtremeWhiteFog_HasNoDuration(){
	return false;
}

public bool Chaos_ExtremeWhiteFog_Conditions(){
	return true;
}