bool g_bg_TaserRound = false;

/* CREDIT TO:
    name        = "Weapon Jump",
    author      = "Nyuu",
    description = "Knockback the players when shooting",
    version     = C_PLUGIN_VERSION,
    url         = "https://forums.alliedmods.net/showthread.php?t=292151"
 */

/* Knockback weapon property                                                 */
#define C_WEAPON_PROPERTY_KNOCKBACK     (0)
/* Velocity weapon property                                                  */
#define C_WEAPON_PROPERTY_VELOCITY      (1)
/* Ground weapon property                                                    */
#define C_WEAPON_PROPERTY_GROUND        (2)
/* Maximum weapon property                                                   */
#define C_WEAPON_PROPERTY_MAXIMUM       (3)

/* Players weapon jump                                                       */
bool g_b     gl_bPlayerWeaponJump        [MAXPLAYERS + 1];
/* Players weapon jump velocity                                              */
float     gl_vPlayerWeaponJumpVelocity[MAXPLAYERS + 1][3];

public void WeaponJumpDisconnect_Handler(int iClient){
   // Initialize the client data
    gl_bPlayerWeaponJump        [iClient]    = false;
    gl_vPlayerWeaponJumpVelocity[iClient][0] = 0.0;
    gl_vPlayerWeaponJumpVelocity[iClient][1] = 0.0;
    gl_vPlayerWeaponJumpVelocity[iClient][2] = 0.0;
}
public void WeaponJumpConnect_Handler(int iClient){
	// Initialize the client data
	SDKHook(iClient, SDKHook_PostThinkPost, OnPlayerPostThinkPost);
	gl_bPlayerWeaponJump        [iClient]    = false;
	gl_vPlayerWeaponJumpVelocity[iClient][0] = 0.0;
	gl_vPlayerWeaponJumpVelocity[iClient][1] = 0.0;
	gl_vPlayerWeaponJumpVelocity[iClient][2] = 0.0;
}


// public void OnWeaponFirePost(Event hEvent, const char[] szName, bool g_bbDontBroadcast)
public void weaponJump(int client, char[] szWeaponName)
{
	int iPlayer = client;
	// int iPlayer = GetClientOfUserId(hEvent.GetInt("userid"));
	if(IsValidClient(iPlayer)){
        int iWeapon = GetEntPropEnt(iPlayer, Prop_Send, "m_hActiveWeapon");
        if (GetEntProp(iWeapon, Prop_Send, "m_iClip1") > 0){
			// char szWeaponName[32];
			// int  arrWeaponProperty[C_WEAPON_PROPERTY_MAXIMUM];

			// Get the weapon name
			// hEvent.GetString("weapon", szWeaponName, sizeof(szWeaponName));
			//TODO: 
			if(StrContains(szWeaponName, "taser") != -1 && g_TaserRound){
				 // Convert the weapon properties
                    // float flKnockback = view_as<float>(arrWeaponProperty[C_WEAPON_PROPERTY_KNOCKBACK]);
                    // float flVelocity  = view_as<float>(arrWeaponProperty[C_WEAPON_PROPERTY_VELOCITY]);
                    // bool g_b bGround     = view_as<bool> (arrWeaponProperty[C_WEAPON_PROPERTY_GROUND]);
					// The available properties are:
					//
					//    "knockback" - Required: Set the weapon knockback value.
					//    "velocity"  - Optional: Set the player velocity factor to keep.
					//                  > Default value: 0.00
					//                  > Minimum value: 0.00
					//                  > Maximum value: 1.00
					//    "ground"    - Optional: Allow to weapon jump on the ground.
					//                  > Default value: 0
					//                  > Minimum value: 0
					//                  > Maximum value: 1
					// --------------------------------------------
					float flKnockback = g_TaserKnockback;
					// float flKnockback = -750.0;
					float flVelocity = 0.0;
					bool g_bbGround = true;
                    // Check if the player can weapon jump on ground
					if (!(GetEntityFlags(iPlayer) & FL_ONGROUND) || bGround){
						float vPlayerVelocity[3];
						float vPlayerEyeAngles[3];
						float vPlayerForward[3];

						// Get the player velocity
						GetEntPropVector(iPlayer, Prop_Data, "m_vecVelocity", vPlayerVelocity);

						// Get the player forward direction
						GetClientEyeAngles(iPlayer, vPlayerEyeAngles);
						GetAngleVectors(vPlayerEyeAngles, vPlayerForward, NULL_VECTOR, NULL_VECTOR);

						// Compute the player weapon jump velocity
						gl_vPlayerWeaponJumpVelocity[iPlayer][0] = vPlayerVelocity[0] * flVelocity - vPlayerForward[0] * flKnockback;
						gl_vPlayerWeaponJumpVelocity[iPlayer][1] = vPlayerVelocity[1] * flVelocity - vPlayerForward[1] * flKnockback;
						gl_vPlayerWeaponJumpVelocity[iPlayer][2] = vPlayerVelocity[2] * flVelocity - vPlayerForward[2] * flKnockback;

						// Set the player weapon jump
						gl_bPlayerWeaponJump[iPlayer] = true;
					}
                }
			}
		}

}

/* ------------------------------------------------------------------------- */
/* Player                                                                    */
/* ------------------------------------------------------------------------- */

public void OnPlayerPostThinkPost(int iPlayer)
{
    // Check if the player must weapon jump
    if (gl_bPlayerWeaponJump[iPlayer])
    {
        // Check if the player is still alive
        if (IsPlayerAlive(iPlayer))
        {
            // Knockback the player
            TeleportEntity(iPlayer, NULL_VECTOR, NULL_VECTOR, gl_vPlayerWeaponJumpVelocity[iPlayer]);
        }
        
        // Reset the player weapon jump
        gl_bPlayerWeaponJump[iPlayer] = false;
    }
}
