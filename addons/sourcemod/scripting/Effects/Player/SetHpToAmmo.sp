#pragma semicolon 1

public void Chaos_SetHpToAmmo(EffectData effect) {
	effect.Title = "Set Health To Ammo Count";
	effect.HasNoDuration = true;
}

public void Chaos_SetHpToAmmo_START() {
	LoopAlivePlayers(i) {
		int primary = GetPlayerWeaponSlot(i, CS_SLOT_PRIMARY);
		int secondary = GetPlayerWeaponSlot(i, CS_SLOT_SECONDARY);

		if(primary == -1 && secondary == -1) continue;

		int weapon = primary;
		if(weapon == -1) weapon = secondary;

		// OneBulletMag.sp
		int ammoCount = GetEntData(weapon, g_iOffset_Clip1);

		if(ammoCount > 0) {
			SetEntityHealth(i, ammoCount);
		}
	}
}