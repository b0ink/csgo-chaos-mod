Handle g_Chaos_RandomWeapons_Timer = INVALID_HANDLE;

public void GiveAndSwitchWeapon(int client, char[] weaponName){
	
	char playersWeapon[64];
	GetClientWeapon(client, playersWeapon, sizeof(playersWeapon));

	StripPlayer(client, true, true, false, true); //keeps bomb and knives
	int weapon = GivePlayerItem(client, weaponName);

	//if player has their knife or bomb out, don't switch to new weapon
	if(StrContains(playersWeapon, "c4") != -1 || StrContains(playersWeapon, "knife") != -1){
        if(StrContains(playersWeapon, "knife") != -1){
            FakeClientCommand(client, "use %s", "weapon_knife"); //ignored by weapon_knife_karambit etc.
            InstantSwitch(client, weapon);
        }else{
            FakeClientCommand(client, "use %s", playersWeapon);
            InstantSwitch(client, weapon);
        }
	}else{
        FakeClientCommand(client, "use %s", weaponName);
        InstantSwitch(client, weapon);
    }
}

public void InstantSwitch(int client, int weapon){	
    float GameTime = GetGameTime();
    SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GameTime);
    int ViewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
    SetEntProp(ViewModel, Prop_Send, "m_nSequence", 0);
}