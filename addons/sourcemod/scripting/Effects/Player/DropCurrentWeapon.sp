public void Chaos_DropCurrentWeapon_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			ClientCommand(i, "drop");
		}
	}
}

public Action Chaos_DropCurrentWeapon_RESET(bool EndChaos){

}


public bool Chaos_DropCurrentWeapon_HasNoDuration(){
	return true;
}

public bool Chaos_DropCurrentWeapon_Conditions(){
	return true;
}