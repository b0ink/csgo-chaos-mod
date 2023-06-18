#pragma semicolon 1

bool DropWeaponOnMiss = false;
bool DropWeaponOnMissPlayerShot[MAXPLAYERS + 1];

public void Chaos_DropWeaponOnMissedShot(EffectData effect) {
	effect.Title = "Drop Weapon on Missed Shot";
	effect.Duration = 30;

	HookEvent("player_hurt", DropWeaponMissedShot_Event_PlayerHurt);
	HookEvent("weapon_fire", DropWeaponMissedShot_Event_WeaponFire);
}

public void Chaos_DropWeaponOnMissedShot_START() {
	DropWeaponOnMiss = true;
}

public void Chaos_DropWeaponOnMissedShot_RESET() {
	DropWeaponOnMiss = false;
}

public void DropWeaponMissedShot_Event_WeaponFire(Event event, const char[] name, bool dontBroadcast) {
	if(!DropWeaponOnMiss) return;

	int client = GetClientOfUserId(event.GetInt("userid"));
	if(ValidAndAlive(client)) {
		int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");

		// filter knife and grenades
		if(GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType") != -1 && GetEntProp(weapon, Prop_Send, "m_iClip1") != 255) {
			DropWeaponOnMissPlayerShot[client] = true;
			RequestFrame(CheckFire_DropWeaponOnMiss, client);
		}
	}
}

public void DropWeaponMissedShot_Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast) {
	if(!DropWeaponOnMiss) return;

	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));

	// shot wasn't missed, reset state
	if(ValidAndAlive(attacker) && ValidAndAlive(victim)) {
		DropWeaponOnMissPlayerShot[attacker] = false;
	}
}

public void CheckFire_DropWeaponOnMiss(int client) {
	if(!ValidAndAlive(client)) return;

	if(DropWeaponOnMissPlayerShot[client]) {
		ClientCommand(client, "playgamesound \"weapons/knife/knife_slash2.wav\"");
		ClientCommand(client, "drop");
	}
	DropWeaponOnMissPlayerShot[client] = false;
}