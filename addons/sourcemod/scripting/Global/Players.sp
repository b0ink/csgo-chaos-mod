#pragma semicolon 1

//TODO: Similar to how Fog.sp's Fog_Stream Queue is handled, the same should be done to player data, eg:
/*
	enum struct player_data{
		float speed;
		float gravity;
		float airacceleration; https://forums.alliedmods.net/showthread.php?t=121739
		https://github.com/JoinedSenses/SM-Air-Accelerate-Control/blob/main/scripting/airaccel_control.sp
		float FOV
		..
	}
*/



// enum struct player_data{
// 	float speed;
// 	float gravity;
// 	float airacceleration;
// 	float FOV;
	
// 	float Disable_LEFT;
// 	float Disable_RIGHT;
// 	float Disable_FORWARD;
// 	float Disable_BACK;

// 	bool KnifeOnly;
// }

int BlockGun_EffectCount = 0;
public Action BlockAllGuns(int client, int weapon) {
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(
		StrContains(WeaponName, "fists") == -1 &&
		StrContains(WeaponName, "knife") == -1 &&
		StrContains(WeaponName, "c4") == -1 &&
		StrContains(WeaponName, "grenade") == -1 &&
		StrContains(WeaponName, "molotov") == -1 &&
		StrContains(WeaponName, "flashbang") == -1 &&
		StrContains(WeaponName, "decoy") == -1 &&
		StrContains(WeaponName, "snowball") == -1 &&
		StrContains(WeaponName, "diversion") == -1
		){
			FakeClientCommand(client, "use weapon_knife");
			return Plugin_Handled;
	}
	return Plugin_Continue;
}

/**
 * Blocks (most) primary and secondary weapons, allows knives, grenades and c4 only.
 * If multiple effects use this, both will need to use UnhookBlockAllGuns() to releaes the lock.
 */
//TODO: if you pick up a grenade you cant see your knife anymore
void HookBlockAllGuns(int client = -1){
	if(IsValidClient(client)){
		SDKUnhook(client, SDKHook_WeaponSwitch, BlockAllGuns);
		SDKHook(client, SDKHook_WeaponSwitch, BlockAllGuns);
		return;
	}
	
	BlockGun_EffectCount++;

	LoopAllClients(i){
		SDKUnhook(i, SDKHook_WeaponSwitch, BlockAllGuns);
	}
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_WeaponSwitch, BlockAllGuns);
	}
}

public void UnhookBlockAllGuns(){
	if(BlockGun_EffectCount > 0) BlockGun_EffectCount--;
	if(BlockGun_EffectCount == 0){
		LoopAlivePlayers(i){
			SDKUnhook(i, SDKHook_WeaponSwitch, BlockAllGuns);
		}
	}
}





int PreventWeaponDrop_EffectCount = 0;
public Action PreventWeaponDrop(int client, int weapon) {
	if(!ValidAndAlive(client)) return Plugin_Continue;
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(
		StrContains(WeaponName, "c4") == -1
		){
			return Plugin_Handled;
	}
	return Plugin_Continue;
}

void HookPreventWeaponDrop(int client = -1){
	if(IsValidClient(client)){
		SDKUnhook(client, SDKHook_WeaponDrop, PreventWeaponDrop);
		SDKHook(client, SDKHook_WeaponDrop, PreventWeaponDrop);
		return;
	}
	
	PreventWeaponDrop_EffectCount++;

	LoopAllClients(i){
		SDKUnhook(i, SDKHook_WeaponDrop, PreventWeaponDrop);
	}
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_WeaponDrop, PreventWeaponDrop);
	}
}

public void UnhookPreventWeaponDrop(){
	if(PreventWeaponDrop_EffectCount > 0) PreventWeaponDrop_EffectCount--;
	if(PreventWeaponDrop_EffectCount == 0){
		LoopAlivePlayers(i){
			SDKUnhook(i, SDKHook_WeaponDrop, PreventWeaponDrop);
		}
	}
}



/*
	TODO:
		- add player_data to each effect
		- go through the effects inside of the HUD queue, (attached to an effect?)
		- everytime a new one is added or deleted, loop through effects from newest to oldest, if a variable is set to null, check the next effect
		
*/