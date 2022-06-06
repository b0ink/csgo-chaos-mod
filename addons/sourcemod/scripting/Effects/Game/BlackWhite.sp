public void Chaos_BlackWhite_START(){
	CREATE_CC("blackandwhite");
}

public Action Chaos_BlackWhite_RESET(bool EndChaos){
	CLEAR_CC("blackandwhite.raw");
}

public bool Chaos_BlackWhite_HasNoDuration(){
	return false;
}

public bool Chaos_BlackWhite_Conditions(){
	return true;
}