bool g_Chatterbox = false;
bool g_CalloutSent[MAXPLAYERS+1];

SETUP(effect_data effect){
	effect.Title = "Chatterbox";
	effect.Duration = 30;
	
	effect.AddAlias("Callouts");
	effect.AddAlias("Location");
}


START(){
	g_Chatterbox = true;
	CreateTimer(5.0, Timer_SendChatterboxCallout, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	LoopAllClients(i){
		g_CalloutSent[i] = false;
	}
}

int calloutCounter = 0;
char callout_names[][] = {
	"I'm at",
	"Jeee I hope they don't come near",
	"I'm hiding at",
	"Shhhh I'm walking past",
	"I'm flanking from",
	"Running past",
	"I'm camping in",
};

void SendCallout(int client){
	g_CalloutSent[client] = true;
	char location[64];
	GetEntPropString(client, Prop_Send, "m_szLastPlaceName", location, sizeof(location));

	// Break string by uppercase letters
	// eg. location will ready "OutsideTunnel", this breaks it into "Outside Tunnel"

	char location_final[64];
	FormatEx(location_final, sizeof(location_final), "%c", location[0]);

	for(int i = 1; i < sizeof(location); i++){
		if(IsCharUpper(location[i])){
			if(!IsCharUpper(location[i+1])){ // Check if it's the case of "CT Spawn", that has two double uppercase letters
				Format(location_final, sizeof(location_final), "%s ", location_final);
			}
		}
		Format(location_final, sizeof(location_final), "%s%c", location_final, location[i]);
	}

	//! the one case I see 3 words used, and 'of' is lowercase :')
	if(StrEqual("topofmid", location, false)) location_final = "Top of Mid";

	FakeClientCommand(client, "say %s %s%s", callout_names[calloutCounter], location_final, (GetRandomInt(0, 100) < 50) ? "!" : "...");

	calloutCounter++;
	if(calloutCounter >= sizeof(callout_names)){
		calloutCounter = 0;
	}
	
}

public Action Timer_SendChatterboxCallout(Handle timer){
	bool T_Sent = false;
	bool CT_Sent = false;

	bool SentCallout = false;

	if(g_Chatterbox){
		int players = 0;
		LoopAlivePlayers(i){
			players++;
			if(!g_CalloutSent[i]){
				if(GetClientTeam(i) == CS_TEAM_CT && !CT_Sent){
					CT_Sent = true;
					SentCallout = true;
					SendCallout(i);
				}
				if(GetClientTeam(i) == CS_TEAM_T && !T_Sent){
					T_Sent = true;
					SentCallout = true;
					SendCallout(i);
				}
			}		
		}
		if(!SentCallout && timer != null && players > 0){ // only failsafe once
			LoopAllClients(i){
				g_CalloutSent[i] = false;
			}
			Timer_SendChatterboxCallout(null);
		}
	}else{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

RESET(bool HasTimerEnded){
	g_Chatterbox = false;
}

CONDITIONS(){
	// Seems like certain maps such as de_lake don't have callouts
	char location[64];
	bool hasLocations = false;
	LoopAlivePlayers(i){
		GetEntPropString(i, Prop_Send, "m_szLastPlaceName", location, sizeof(location));
		if(location[0] != '\0') hasLocations = true;
	}
	return hasLocations;
}