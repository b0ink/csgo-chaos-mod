public void Chaos_Bumpmines_START(){
	for(int i = 0; i <= MaxClients; i++) if(ValidAndAlive(i)) GivePlayerItem(i, "weapon_bumpmine");
}

public Action Chaos_Bumpmines_RESET(bool HasTimerEnded){

}


public bool Chaos_Bumpmines_HasNoDuration(){
	return true;
}

public bool Chaos_Bumpmines_Conditions(){
	return true;
}