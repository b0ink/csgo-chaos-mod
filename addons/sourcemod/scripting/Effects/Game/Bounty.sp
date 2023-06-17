#pragma semicolon 1

int BountyPlayer = -1;
int BountyAmount = 500;

public void Chaos_Bounty(EffectData effect) {
	effect.Title = "Set Player Bounty";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;

	HookEvent("player_death", Bounty_Event_PlayerDeath);
}

public void Chaos_Bounty_OnMapStart(){
	BountyPlayer = -1;
}

public void Chaos_Bounty_START() {
	int player = GetRandomPlayer(.alive = true);
	int bounty = 500;

	int rand = GetRandomInt(1, 4);
	switch(rand) {
		case 1: bounty = 1000;
		case 2: bounty = 1500;
		case 3: bounty = 2000;
		case 4: bounty = 2500;
	}

	BountyPlayer = GetClientSerial(player);
	BountyAmount = bounty;

	char announce[64];
	Format(announce, sizeof(announce), "Set $%i Bounty on %.8N", bounty, player);
	AnnounceChaos(announce, -1.0);
}

public void Bounty_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {
	int client = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));

	int bounty = GetClientFromSerial(BountyPlayer);
	if(!IsValidClient(bounty)) {
		BountyPlayer = -1;
		return;
	}

	if(client == attacker) {
		return;
	}

	if(client == bounty && IsValidClient(attacker)) {
		SetClientMoney(attacker, BountyAmount);
		CPrintToChatAll("%s {lime}%N {default}has collected {orange}%N's {default}bounty of {lime}$%i{default}!", g_Prefix, attacker, client, BountyAmount);
		RequestFrame(Bounty_PlayCollectSound, attacker);
		PrintHintText(attacker, "You have collected %N's bounty of $%i!", client, BountyAmount);
		BountyPlayer = -1;
	}
}

public void Bounty_PlayCollectSound(int client) {
	EmitSoundToClient(client, "survival/money_collect_04.wav", _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
}