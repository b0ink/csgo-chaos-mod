public void Chaos_BlindPlayers(effect_data effect){
	effect.Title = "Blind";
	effect.Duration = 7;
}

public void Chaos_BlindPlayers_START(){
	LoopAlivePlayers(i){
		PerformBlind(i, 255);
	}
}

public Action Chaos_BlindPlayers_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		PerformBlind(i, 0);
	}
}

// UserMessageId for Fade.
UserMsg g_FadeUserMsgId;
void PerformBlind(int target, int amount, int duration = 1536, int holdtime = 1536){
	int targets[2];
	targets[0] = target;
	
	// int duration = 1536;
	// int holdtime = 1536;
	int flags;
	if (amount == 0){
		flags = (0x0001 | 0x0010);
	}else{
		flags = (0x0002 | 0x0008);
	}
	
	int color[4] = { 0, 0, 0, 0 };
	color[3] = amount;
	g_FadeUserMsgId = GetUserMessageId("Fade");
	
	// Handle message = StartMessageEx(g_FadeUserMsgId, targets, 1);
	Handle message = StartMessageEx(g_FadeUserMsgId, targets, 1);
	if (GetUserMessageType() == UM_Protobuf){
		Protobuf pb = UserMessageToProtobuf(message);
		pb.SetInt("duration", duration);
		pb.SetInt("hold_time", holdtime);
		pb.SetInt("flags", flags);
		pb.SetColor("clr", color);
	}else{
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
