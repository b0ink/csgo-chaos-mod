#pragma semicolon 1

Handle FakeDefuseTimer = INVALID_HANDLE;

public void Chaos_FakeDefuse(EffectData effect) {
	effect.Title = "Fake Defuse";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.BlockInCoopStrike = true;

	HookEvent("round_end", Chaos_FakeDefuse_Event_RoundEnd);
}

public void Chaos_FakeDefuse_START() {
	AnnounceChaos("Auto Defuse C4", -1.0);
	LoopValidPlayers(i) {
		ClientCommand(i, "playgamesound \"radio/bombdef.wav\"");
	}
	FakeDefuseTimer = CreateTimer(2.0, Timer_FakeDefuseWin);
}

public Action Timer_FakeDefuseWin(Handle timer) {
	FakeDefuseTimer = INVALID_HANDLE;
	LoopValidPlayers(i) {
		ClientCommand(i, "playgamesound \"radio/ctwin.wav\"");
	}

	FakeDefuseTimer = CreateTimer(1.5, Timer_FakeDefuseTitleChange);
	return Plugin_Stop;
}

public Action Timer_FakeDefuseTitleChange(Handle timer) {
	FakeDefuseTimer = INVALID_HANDLE;
	RemoveHudByName("Auto Defuse C4");
	AnnounceChaos(GetChaosTitle("Chaos_FakeDefuse"), -1.0);
	return Plugin_Stop;
}

public void Chaos_FakeDefuse_Event_RoundEnd(Event event, const char[] name, bool dontBroadcast) {
	StopTimer(FakeDefuseTimer);
}
