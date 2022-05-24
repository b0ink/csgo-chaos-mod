char PrecipitationModel[128];

#define SOUND_SUPERSLAY  "weapons/hegrenade/hegrenade_detonate_02.wav"
#define LIGHTNING_EFFECT "sprites/lgtning.vmt"
#define TYPE_SNOWFALL define value
enum WEATHER_TYPE{
    RAIN,
    SNOW,
    ASH,
    SNOWFALL,
    PARTICLE_RAIN,
    PARTICLE_RAINSTORM,
    PARTICLE_SNOW,
};
int    LIGHTNING_sprite = -1;

float map_vecOrigin[3];
float map_maxbounds[3];
float map_minbounds[3];

void WEATHER_INIT(){
    PrecacheSound(SOUND_SUPERSLAY);

    LIGHTNING_sprite = PrecacheModel(LIGHTNING_EFFECT);

    Format(PrecipitationModel, sizeof(PrecipitationModel), "maps/%s.bsp", mapName);
    PrecacheModel(PrecipitationModel, true);
    GetEntPropVector(0, Prop_Data, "m_WorldMins", map_minbounds); // rain shit
    GetEntPropVector(0, Prop_Data, "m_WorldMaxs", map_maxbounds);

    map_vecOrigin[0] = (map_minbounds[0] + map_maxbounds[0]) / 2;
    map_vecOrigin[1] = (map_minbounds[1] + map_maxbounds[1]) / 2;
    map_vecOrigin[2] = (map_minbounds[2] + map_maxbounds[2]) / 2;

}

void SPAWN_WEATHER(WEATHER_TYPE type){
    int ent = CreateEntityByName("func_precipitation");
    char PrecipType[8];
    FormatEx(PrecipType, sizeof(PrecipType), "%i.0", view_as<int>(type));
    DispatchKeyValue(ent, "model", PrecipitationModel);
    DispatchKeyValue(ent, "preciptype", PrecipType);
    DispatchKeyValue(ent, "renderamt", "5.0");
    DispatchKeyValue(ent, "density", "100");
    DispatchKeyValue(ent, "rendercolor", "255 255 255");
    DispatchSpawn(ent);
    ActivateEntity(ent);

    SetEntPropVector(ent, Prop_Send, "m_vecMins", map_minbounds);
    SetEntPropVector(ent, Prop_Send, "m_vecMaxs", map_maxbounds);    
    TeleportEntity(ent, map_vecOrigin, NULL_VECTOR, NULL_VECTOR); 
}
