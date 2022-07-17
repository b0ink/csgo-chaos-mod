public void Chaos_DropCurrentWeapon_START(){
	LoopAlivePlayers(i){
		ClientCommand(i, "drop");
	}
}

public Action Chaos_DropCurrentWeapon_RESET(bool HasTimerEnded){

}


public bool Chaos_DropCurrentWeapon_HasNoDuration(){
	return true;
}

public bool Chaos_DropCurrentWeapon_Conditions(){
	return true;
}