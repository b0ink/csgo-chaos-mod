public void Chaos_MoonGravity_START(){
	SetPlayersGravity(0.6);
}
	//TODO: fluctuating gravity thoughout the round?

public Action Chaos_MoonGravity_RESET(bool EndChaos){
	SetPlayersGravity(1.0);
}


public bool Chaos_MoonGravity_HasNoDuration(){
	return false;
}

public bool Chaos_MoonGravity_Conditions(){
	return true;
}