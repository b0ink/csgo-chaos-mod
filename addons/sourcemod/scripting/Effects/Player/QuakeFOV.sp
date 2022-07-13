public void Chaos_QuakeFOV_START(){
	int RandomFOV = GetRandomInt(130,160);
	SetPlayersFOV(RandomFOV);

}

public Action Chaos_QuakeFOV_RESET(bool EndChaos){
	ResetPlayersFOV();
}


public bool Chaos_QuakeFOV_HasNoDuration(){
	return false;
}

public bool Chaos_QuakeFOV_Conditions(){
	return true;
}