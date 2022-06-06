public void Chaos_Bankrupt_START(){
	for(int i = 0; i <= MaxClients; i++) if(IsValidClient(i)) SetClientMoney(i, 0, true);
}

public Action Chaos_Bankrupt_RESET(bool EndChaos){

}


public bool Chaos_Bankrupt_HasNoDuration(){
	return true;
}

public bool Chaos_Bankrupt_Conditions(){
	return true;
}