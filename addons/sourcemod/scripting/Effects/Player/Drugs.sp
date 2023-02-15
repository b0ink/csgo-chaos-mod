#pragma semicolon 1

//taken from base sourcemod

UserMsg g_FadeUserMsgId_drugs;

public void Chaos_Drugs(EffectData effect){
	effect.Title = "Drugs";
	effect.Duration = 30;
}

public void Chaos_Drugs_INIT(){
	g_FadeUserMsgId_drugs = GetUserMessageId("Fade");
}
Handle g_DrugTimers[MAXPLAYERS+1];
float g_DrugAngles[20] = {0.0, 5.0, 10.0, 15.0, 20.0, 25.0, 20.0, 15.0, 10.0, 5.0, 0.0, -5.0, -10.0, -15.0, -20.0, -25.0, -20.0, -15.0, -10.0, -5.0};

public void Chaos_Drugs_START(){
	LoopAlivePlayers(i){
		CreateDrug(i);
	}
}

public void Chaos_Drugs_RESET(int ResetType){
	KillAllDrugs();
}

public void Chaos_Drugs_OnPlayerSpawn(int client){
	CreateDrug(client);
}

void CreateDrug(int client){
	g_DrugTimers[client] = CreateTimer(1.0, Timer_Drug, client, TIMER_REPEAT);	
}

void KillDrug(int client){
	KillDrugTimer(client);
	
	float angs[3];
	GetClientEyeAngles(client, angs);
	
	angs[2] = 0.0;
	
	TeleportEntity(client, NULL_VECTOR, angs, NULL_VECTOR);	
	
	int clients[2];
	clients[0] = client;

	int duration = 1536;
	int holdtime = 1536;
	int flags = (0x0001 | 0x0010);
	int color[4] = { 0, 0, 0, 0 };

	Handle message = StartMessageEx(g_FadeUserMsgId_drugs, clients, 1);
	if (GetUserMessageType() == UM_Protobuf){
		Protobuf pb = UserMessageToProtobuf(message);
		pb.SetInt("duration", duration);
		pb.SetInt("hold_time", holdtime);
		pb.SetInt("flags", flags);
		pb.SetColor("clr", color);
	}
	else{	
		BfWrite bf = UserMessageToBfWrite(message);
		bf.WriteShort(duration);
		bf.WriteShort(holdtime);
		bf.WriteShort(flags);
		bf.WriteByte(color[0]);
		bf.WriteByte(color[1]);
		bf.WriteByte(color[2]);
		bf.WriteByte(color[3]);
	}
	
	EndMessage();
}

void KillDrugTimer(int client){
	KillTimer(g_DrugTimers[client]);
	g_DrugTimers[client] = null;	
}

void KillAllDrugs(){
	LoopAllClients(i){
		if (g_DrugTimers[i] != null){
			if(IsValidClient(i)){
				KillDrug(i);
			}else{
				KillDrugTimer(i);
			}
		}
	}
}

Action Timer_Drug(Handle timer, any client){
	if (!IsValidClient(client)){
		KillDrugTimer(client);
		return Plugin_Handled;
	}
	
	if (!IsPlayerAlive(client)){
		KillDrug(client);
		return Plugin_Handled;
	}
	
	float angs[3];
	GetClientEyeAngles(client, angs);
	
	angs[2] = g_DrugAngles[GetRandomInt(0,100) % 20];
	
	TeleportEntity(client, NULL_VECTOR, angs, NULL_VECTOR);
	
	int clients[2];
	clients[0] = client;	
	
	int duration = 255;
	int holdtime = 255;
	int flags = 0x0002;
	int color[4] = { 0, 0, 0, 128 };
	color[0] = GetRandomInt(0,255);
	color[1] = GetRandomInt(0,255);
	color[2] = GetRandomInt(0,255);

	Handle message = StartMessageEx(g_FadeUserMsgId_drugs, clients, 1);
	if (GetUserMessageType() == UM_Protobuf){
		Protobuf pb = UserMessageToProtobuf(message);
		pb.SetInt("duration", duration);
		pb.SetInt("hold_time", holdtime);
		pb.SetInt("flags", flags);
		pb.SetColor("clr", color);
	}else{
		BfWriteShort(message, duration);
		BfWriteShort(message, holdtime);
		BfWriteShort(message, flags);
		BfWriteByte(message, color[0]);
		BfWriteByte(message, color[1]);
		BfWriteByte(message, color[2]);
		BfWriteByte(message, color[3]);
	}
	
	EndMessage();
		
	return Plugin_Handled;
}