public void Chaos_QuakeFOV_START(){
	int RandomFOV = GetRandomInt(130,160);
	SetPlayersFOV(RandomFOV);

}

public Action Chaos_QuakeFOV_RESET(bool HasTimerEnded){
	ResetPlayersFOV();
}


public bool Chaos_QuakeFOV_HasNoDuration(){
	return true;
}

public bool Chaos_QuakeFOV_Conditions(){
	return true;
}