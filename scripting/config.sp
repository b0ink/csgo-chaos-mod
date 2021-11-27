
//touchy
float g_Chaos_RandomWeapons_Interval = 5.0; //5+ recommended for bomb plants
float g_TaserKnockback = -1000.0; 

char weapons[][64] = {
	"weapon_glock",
    "weapon_p250",
    "weapon_fiveseven",
    "weapon_deagle",
    "weapon_elite",
    "weapon_hkp2000",
    "weapon_tec9",

    "weapon_nova",
    "weapon_xm1014",
    "weapon_sawedoff",

    "weapon_m249",
    "weapon_negev",
    "weapon_mag7",

    "weapon_mp7",
    "weapon_ump45",
    "weapon_p90",
    "weapon_bizon",
    "weapon_mp9",
    "weapon_mac10",

    "weapon_famas",
    "weapon_m4a1",
    "weapon_aug",
    "weapon_galilar",
    "weapon_ak47",
    "weapon_sg556",

    "weapon_ssg08",
    "weapon_awp",
    "weapon_scar20",
    "weapon_g3sg1",

    // "weapon_taser",
    // "weapon_molotov",
    // "weapon_hegrenade"
};


char skyboxes[][] = {
	"cs_baggage_skybox_",
	"cs_tibet",
	"embassy",
	"italy",
	"jungle",
	"office",
	"sky_cs15_daylight01_hdr",
	"sky_cs15_daylight02_hdr",
	"sky_cs15_daylight03_hdr",
	"sky_cs15_daylight04_hdr",
	"sky_day02_05",
	"nukeblank",
	"sky_venice",
	"sky_csgo_cloudy01",
	"sky_csgo_night02",
	"sky_csgo_night02b",
	"vertigo",
	"vertigoblue_hdr",
	"sky_dust",
	"vietnam"
};


//no touchy
bool g_MegaChaos = false;
int g_Chaos_Event_Count = 0;
// int g_Previous_Chaos_Event = -1;
bool g_BombPlanted = false;
bool g_PlayersCanDropWeapon = true;
bool g_CanSpawnChickens = true;
int g_c4chickenEnt = -1;
Handle g_MapCoordinates = INVALID_HANDLE;
Handle g_UnusedCoordinates = INVALID_HANDLE;
Handle bombSiteA = INVALID_HANDLE;
Handle bombSiteB = INVALID_HANDLE;


void COORD_INIT() {g_UnusedCoordinates = CreateArray(3); }



bool g_ClearChaos = false;
bool g_DecidingChaos = false;
int g_RandomEvent = 0;
bool g_CountingChaos = false;


public void PrecacheTextures(){
	PrecacheModel("props_c17/oildrum001_explosive.mdl", true);
	AddFileToDownloadsTable("materials/models/props_c17/oil_drum001a_normal.vtf");
	AddFileToDownloadsTable("materials/models/props_c17/oil_drum001h.vmt");
	AddFileToDownloadsTable("materials/models/props_c17/oil_drum001h.vtf");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.dx80.vtx");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.dx90.vtx");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.mdl");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.phy");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.sw.vtx");
	AddFileToDownloadsTable("models/props_c17/oildrum001_explosive.vvd");

    
}

Handle TPos = INVALID_HANDLE;
Handle CTPos = INVALID_HANDLE;
Handle tIndex = INVALID_HANDLE;
Handle ctIndex = INVALID_HANDLE;
public void TEAMMATESWAP_INIT(){
	TPos = CreateArray(3);
	CTPos = CreateArray(3);
	tIndex = CreateArray(1);
	ctIndex = CreateArray(1);
}

char playerModel_Path[][] = {
	"models/player/custom_player/legacy/tm_leet_varianti.mdl",
	"models/player/custom_player/legacy/tm_leet_variantg.mdl",
	"models/player/custom_player/legacy/tm_leet_variantg.mdl",
	"models/player/custom_player/legacy/tm_leet_varianth.mdl",
	"models/player/custom_player/legacy/tm_leet_varianti.mdl",
	"models/player/custom_player/legacy/tm_leet_variantf.mdl",
	"models/player/custom_player/legacy/tm_leet_variantj.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_varianta.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantb.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantc.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantd.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variante.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantf.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantb2.mdl",
	"models/player/custom_player/legacy/tm_jungle_raider_variantf2.mdl",
	"models/player/custom_player/legacy/tm_phoenix_varianth.mdl",
	"models/player/custom_player/legacy/tm_phoenix_variantf.mdl",
	"models/player/custom_player/legacy/tm_phoenix_variantg.mdl",
	"models/player/custom_player/legacy/tm_phoenix_varianti.mdl",
	"models/player/custom_player/legacy/tm_professional_varf.mdl",
	"models/player/custom_player/legacy/tm_professional_varg.mdl",
	"models/player/custom_player/legacy/tm_professional_varh.mdl",
	"models/player/custom_player/legacy/tm_professional_varj.mdl"
};