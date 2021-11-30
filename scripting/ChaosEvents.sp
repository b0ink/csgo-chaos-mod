//todo; any instances of a retryevent should be handled inside this function
//		running the function then retrying it is doomed for endless loops, and is simply inefficient ??
//todo: go through each one to see what crashes.
//test to see if its the removechickens function
public void Chaos(){
	if(IsChaosEnabled("Chaos_Nothing"))  Chaos_Nothing(); //cannot be turned off
	if(IsChaosEnabled("Chaos_NoScopeOnly"))  Chaos_NoScopeOnly();
	if(IsChaosEnabled("Chaos_PortalGuns"))  Chaos_PortalGuns();
	if(IsChaosEnabled("Chaos_Aimbot"))  Chaos_Aimbot();
	if(IsChaosEnabled("Chaos_InfiniteAmmo"))  Chaos_InfiniteAmmo();
	if(IsChaosEnabled("Chaos_DecoyDodgeball"))  Chaos_DecoyDodgeball();
	if(!g_MegaChaos){
		if(IsChaosEnabled("Chaos_MEGACHAOS"))  Chaos_MEGACHAOS();
		if(GetRandomInt(0, 100) <= 50) if(IsChaosEnabled("Chaos_FakeCrash", 0))  Chaos_FakeCrash(); //risky.. lol
	}
	if(IsChaosEnabled("Chaos_RandomInvisiblePlayer"))  Chaos_RandomInvisiblePlayer();
	if(IsChaosEnabled("Chaos_Bankrupt"))  Chaos_Bankrupt();
	if(IsChaosEnabled("Chaos_Shields"))  Chaos_Shields();
	if(IsChaosEnabled("Chaos_BlindPlayers"))  Chaos_BlindPlayers();
	if(IsChaosEnabled("Chaos_AutoPlantC4"))  Chaos_AutoPlantC4();
	if(IsChaosEnabled("Chaos_InfiniteGrenades"))  Chaos_InfiniteGrenades();
	if(IsChaosEnabled("Chaos_KnifeFight"))  Chaos_KnifeFight();
	if(IsChaosEnabled("Chaos_RandomWeapons"))  Chaos_RandomWeapons();
	if(IsChaosEnabled("Chaos_TeammateSwap"))  Chaos_TeammateSwap();
	if(IsChaosEnabled("Chaos_OHKO"))  Chaos_OHKO();
	if(IsChaosEnabled("Chaos_Flying"))  Chaos_Flying();
	if(IsChaosEnabled("Chaos_OneBulletMag"))  Chaos_OneBulletMag();
	if(IsChaosEnabled("Chaos_Thirdperson"))  Chaos_Thirdperson();
	if(!g_c4Chicken) if(IsChaosEnabled("Chaos_C4Chicken"))  Chaos_C4Chicken();
	if(IsChaosEnabled("Chaos_AlienModelKnife"))  Chaos_AlienModelKnife();
	if(IsChaosEnabled("Chaos_IsThisMexico"))  Chaos_IsThisMexico();
	if(IsChaosEnabled("Chaos_HeadshotOnly"))  Chaos_HeadshotOnly();
	if(IsChaosEnabled("Chaos_RandomMolotovSpawn"))  Chaos_RandomMolotovSpawn();

	if(IsChaosEnabled("Chaos_CrabPeople"))  Chaos_CrabPeople();
	if(IsChaosEnabled("Chaos_Spin180"))  Chaos_Spin180();
	if(IsChaosEnabled("Chaos_OneWeaponOnly"))  Chaos_OneWeaponOnly();
	if(IsChaosEnabled("Chaos_NoSpread"))  Chaos_NoSpread();
	if(IsChaosEnabled("Chaos_Invis"))  Chaos_Invis();
	if(IsChaosEnabled("Chaos_MoonGravity"))  Chaos_MoonGravity();
	if(GetAliveCTCount() >= 2 && GetAliveTCount() >= 2) if(IsChaosEnabled("Chaos_SlayRandomPlayer"))  Chaos_SlayRandomPlayer();
	if(IsChaosEnabled("Chaos_TaserParty"))  Chaos_TaserParty();
	if(IsChaosEnabled("Chaos_InsaneGravity"))  Chaos_InsaneGravity();
	if(IsChaosEnabled("Chaos_ESP"))  Chaos_ESP();
	if(IsChaosEnabled("Chaos_RandomSlap"))  Chaos_RandomSlap();
	if(IsChaosEnabled("Chaos_Healthshot"))  Chaos_Healthshot();
	if(IsChaosEnabled("Chaos_Jackpot"))  Chaos_Jackpot();
	if(IsChaosEnabled("Chaos_Binoculars"))  Chaos_Binoculars();
	if(IsChaosEnabled("Chaos_QuakeFOV"))  Chaos_QuakeFOV();
	if(IsChaosEnabled("Chaos_VampireHeal"))  Chaos_VampireHeal();
	if(IsChaosEnabled("Chaos_NightVision"))  Chaos_NightVision();
	if(IsChaosEnabled("Chaos_ReversedMovement"))  Chaos_ReversedMovement();
	if(IsChaosEnabled("Chaos_Funky"))  Chaos_Funky();
	if(IsChaosEnabled("Chaos_IceySurface"))  Chaos_IceySurface();
	if(IsChaosEnabled("Chaos_IncreasedRecoil"))  Chaos_IncreasedRecoil();
	if(IsChaosEnabled("Chaos_ReversedRecoil"))  Chaos_ReversedRecoil();
	if(IsChaosEnabled("Chaos_Bumpmines"))  Chaos_Bumpmines();
	if(IsChaosEnabled("Chaos_SlowSpeed"))  Chaos_SlowSpeed();
	if(IsChaosEnabled("Chaos_FastSpeed"))  Chaos_FastSpeed();
	if(IsChaosEnabled("Chaos_IgnitePlayer"))  Chaos_IgnitePlayer();
	if(IsChaosEnabled("Chaos_ChickenPlayers"))  Chaos_ChickenPlayers();
	if(IsChaosEnabled("Chaos_Earthquake"))  Chaos_Earthquake();
	if(IsChaosEnabled("Chaos_LockPlayersAim"))  Chaos_LockPlayersAim();
	if(IsChaosEnabled("Chaos_OneBulletOneGun"))  Chaos_OneBulletOneGun();
	if(FogIndex != -1){
		if(IsChaosEnabled("Chaos_LowRenderDistance"))  Chaos_LowRenderDistance();
		if(IsChaosEnabled("Chaos_ExtremeWhiteFog"))  Chaos_ExtremeWhiteFog();
		if(IsChaosEnabled("Chaos_NormalWhiteFog"))  Chaos_NormalWhiteFog();
		if(IsChaosEnabled("Chaos_LightsOff"))  Chaos_LightsOff();
		if(IsChaosEnabled("Chaos_DiscoFog"))  Chaos_DiscoFog();
	}
	if(IsChaosEnabled("Chaos_Jumping"))  Chaos_Jumping();
	if(IsChaosEnabled("Chaos_DisableForwardBack"))  Chaos_DisableForwardBack();
	if(IsChaosEnabled("Chaos_DisableStrafe"))  Chaos_DisableStrafe();
	if(IsChaosEnabled("Chaos_SpeedShooter"))  Chaos_SpeedShooter();
	if(IsChaosEnabled("Chaos_ExplosiveBullets"))  Chaos_ExplosiveBullets();
	if(IsChaosEnabled("Chaos_DiscoPlayers"))  Chaos_DiscoPlayers();
	if(IsChaosEnabled("Chaos_SimonSays"))  Chaos_SimonSays();
	if(IsChaosEnabled("Chaos_BuyAnywhere"))  Chaos_BuyAnywhere();
	if(IsChaosEnabled("Chaos_HealAllPlayers"))  Chaos_HealAllPlayers();
	if(IsChaosEnabled("Chaos_Give100HP"))  Chaos_Give100HP();
	if(IsChaosEnabled("Chaos_EnemyRadar"))  Chaos_EnemyRadar();
	if(IsChaosEnabled("Chaos_Drugs"))  Chaos_Drugs();
	if(IsChaosEnabled("Chaos_SuperJump"))  Chaos_SuperJump();
	if(IsChaosEnabled("Chaos_NoCrosshair"))  Chaos_NoCrosshair();
	if(IsChaosEnabled("Chaos_ChickensIntoPlayers"))  Chaos_ChickensIntoPlayers();
	if(IsChaosEnabled("Chaos_Juggernaut"))  Chaos_Juggernaut();

	if(IsChaosEnabled("Chaos_RapidFire"))  Chaos_RapidFire();
	if(IsChaosEnabled("Chaos_DisableRadar")) Chaos_DisableRadar();
	if(IsChaosEnabled("Chaos_InsaneAirSpeed")) Chaos_InsaneAirSpeed();
	if(IsChaosEnabled("Chaos_DropCurrentWeapon")) Chaos_DropCurrentWeapon();
	if(IsChaosEnabled("Chaos_DropPrimaryWeapon")) Chaos_DropPrimaryWeapon();

	//anything BUT dust2 (underwhelming effect due to dust2's 3d skybox :[ )
	char MapName[128];
	GetCurrentMap(MapName, sizeof(MapName));
	if(StrEqual(MapName, "de_dust2", false) == false){
		if(IsChaosEnabled("Chaos_RandomSkybox"))  Chaos_RandomSkybox();
	}

	if(Chaos_Round_Count > 0){
		if(IsChaosEnabled("Chaos_RespawnTheDead"))  Chaos_RespawnTheDead();
		if(IsChaosEnabled("Chaos_ResetSpawns"))  Chaos_ResetSpawns();
		if(IsChaosEnabled("Chaos_RespawnDead_LastLocation"))  Chaos_RespawnDead_LastLocation();
		if(IsChaosEnabled("Chaos_BreakTime"))  Chaos_BreakTime();
		if(IsChaosEnabled("Chaos_RewindTenSeconds"))  Chaos_RewindTenSeconds();
		if(ValidMapPoints()){
			if(IsChaosEnabled("Chaos_RespawnTheDead_Randomly"))  Chaos_RespawnTheDead_Randomly();
		}
	}

	if(ValidMapPoints()){
		if(g_CanSpawnChickens){
			if(IsChaosEnabled("Chaos_LittleChooks"))  Chaos_LittleChooks();
			if(IsChaosEnabled("Chaos_BigChooks"))  Chaos_BigChooks();
			if(IsChaosEnabled("Chaos_MamaChook"))  Chaos_MamaChook();
		}
		if(IsChaosEnabled("Chaos_MoneyRain"))  Chaos_MoneyRain();
		if(IsChaosEnabled("Chaos_RandomTeleport"))  Chaos_RandomTeleport();
		if(IsChaosEnabled("Chaos_LavaFloor"))  Chaos_LavaFloor();
		if(IsChaosEnabled("Chaos_SmokeMap"))  Chaos_SmokeMap();
		if(IsChaosEnabled("Chaos_Soccerballs"))  Chaos_Soccerballs();
		if(IsChaosEnabled("Chaos_FakeTeleport"))  Chaos_FakeTeleport();
		if(IsChaosEnabled("Chaos_TeleportFewMeters"))  Chaos_TeleportFewMeters();
		if(IsChaosEnabled("Chaos_SpawnFlashbangs"))  Chaos_SpawnFlashbangs();
		if(IsChaosEnabled("Chaos_SpawnExplodingBarrels"))  Chaos_SpawnExplodingBarrels();
	}

	g_ClearChaos = false;

	// if(IsChaosEnabled("FUNCTION"))  Chaos_PropHunt(); //CRASHES

	//todo; if full version (prop hunts), include a separate chaos file that goes in here
}
