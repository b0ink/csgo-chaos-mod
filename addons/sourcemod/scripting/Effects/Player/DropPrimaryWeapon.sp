public void Chaos_DropPrimaryWeapon_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i) && !HasMenuOpen(i)){
			ClientCommand(i, "slot2;slot1");
		}
	}
	CreateTimer(0.1, Timer_DropPrimary);
}

public Action Timer_DropPrimary(Handle timer){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "drop");
		}
	}
}


public Action Chaos_DropPrimaryWeapon_RESET(bool HasTimerEnded){

}


public bool Chaos_DropPrimaryWeapon_HasNoDuration(){
	return true;
}

public bool Chaos_DropPrimaryWeapon_Conditions(){
	return true;
}