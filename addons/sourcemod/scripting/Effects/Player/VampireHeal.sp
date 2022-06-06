
bool g_bVampireRound = false;
public Action Chaos_VampireHeal_Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype){
	if(g_bVampireRound){
		if(IsValidClient(victim) && IsValidClient(inflictor)){
			//todo; fix this its not working
			if(GetClientTeam(victim) != GetClientTeam(inflictor)){ //ensure opposite teams
				int health = GetEntProp(inflictor, Prop_Send, "m_iHealth");
				health = health + RoundFloat(damage);
				if(health > 100) health = 100;
				SetEntityHealth(inflictor, health);
			}
		}
	}
}

public void Chaos_VampireHeal_START(){
	g_bVampireRound = true;
}

public Action Chaos_VampireHeal_RESET(bool EndChaos){
	g_bVampireRound = false;
}

public Action Chaos_VampireHeal_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_VampireHeal_HasNoDuration(){
	return false;
}

public bool Chaos_VampireHeal_Conditions(){
	return true;
}