#pragma semicolon 1

/*
	https://forums.alliedmods.net/showthread.php?p=923823
*/

bool TearGas = false;
public void Chaos_TearGas(EffectData effect){
	effect.Title = "Tear Gas";
	effect.Duration = 45;

	HookEvent("smokegrenade_detonate", TearGas_Event_SmokeDetonate);
}

public void TearGas_Event_SmokeDetonate(Event event, const char[] name, bool dontBroadcast){
	if(!TearGas) return;

	int client = GetClientOfUserId(GetEventInt(event,"userid"));
	if(!IsValidClient(client)) return;

	int hurt = CreateEntityByName("point_hurt");
	if(hurt == -1) return;
	DispatchKeyValueFloat(hurt, "DamageRadius", 200.0);
	DispatchKeyValueFloat(hurt, "Damage", 4.0);
	DispatchKeyValueFloat(hurt, "DamageType", 32.00);

	float VectorPos[3];

	VectorPos[0]=event.GetFloat("x");
	VectorPos[1]=event.GetFloat("y");
	VectorPos[2]=event.GetFloat("z");
	TeleportEntity(hurt, VectorPos, NULL_VECTOR, NULL_VECTOR);

	DispatchSpawn(hurt);
		
	SetVariantString("OnUser1 !self,kill,-1,20");
	AcceptEntityInput(hurt, "AddOutput");
	AcceptEntityInput(hurt, "TurnOn");
	AcceptEntityInput(hurt, "FireUser1");
}

public void Chaos_TearGas_START(){
	LoopAlivePlayers(i){
		GivePlayerItem(i, "weapon_smokegrenade");
	}
	TearGas = true;	
}

public void Chaos_TearGas_RESET(int ResetType){
	TearGas = false;	
}