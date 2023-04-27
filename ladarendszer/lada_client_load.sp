

public void OnClientPostAdminCheck(int client)
{
	if (IsValidClient(client))
	{
		g_betoltve[client]		 = 0;
		char query[255];
		char steamid[32];
		g_ChatColor[client]	   = "";
		g_ChatTag[client]	   = "";
		g_ScoreTag[client]	   = "";
		g_ScoreTagOkay[client] = 0;
		g_transferdata[client] = "";
		g_NameColor[client]	   = "";
		g_awaitladacucc[client]=0;
		g_awaitladacuccinput[client]=0;
		g_crashmax[client]=0;
		g_crashcurrent[client]=0;
		trade_reset(client);
		g_tradepartner[client]=0;
		g_changenametag[client]=false;
		g_usereferal[client]=false;
		g_multiopencasemenu[client]=0;
#if defined RAB
		checkvip(client);
#endif
		g_isporget[client]=0;
		GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
		restart(client);
		for (int i = 0; i < 8; i++)
		{
			g_PlayerStats[client][i] = 0;
		}
		for (int i = 0; i < 53; i++)
		{
			g_gotskinlasttime[client][i] = 0;
		}
		for (int i = 0; i < MAX_LADA; i++)
		{
			g_tradekulcs[client][i]=0;
			g_tradelada[client][i]=0;
			g_lada[client][i][0] = 0;
			g_lada[client][i][1] = 0;
		}
		q_ckills[client]				= 0;
		g_open[client]					= 0;
		g_isopening[client]				= 0;
		q_head[client]					= 0;
		q_kills[client]					= -1;
		q_questid[client]				= -1;
		q_done[client]					= 0;
		g_sTargetCredit[client]			= 0;
		g_bAwaitingCredit[client]		= false;
		g_bAwaitingCreditCasino[client] = 0;
		g_valasztottroulettszin[client] = -1;
		g_RoulettCredit[client]			= 0;
		g_credits[client]				= 0;
		g_connected[client]				= 0;
		g_opencooldown[client]			= false;
		asd2[client]						= 100;
		pivot[client]					= 0;
		bpivot[client]					= 1;
		g_dropped[client]				= 0;
		allas[client]					= 0;
		p_fegyverid[client]				= -1;
		p_credit[client]				= -1;
		p_color[client]					= -1;
		p_time[client]					= 0;
		g_multiplecaseopen[client]=-1;
		//lada_cheat
		addcroleinput[client]=-1;
		for (int i = 0; i < 10000; i++)
		{
			p_checked[client][i] = -1;
		}
		p_checkcounter[client] = 0;
		Format(p_osszesitett[client], sizeof(p_osszesitett[]), "GROUP BY id DESC");
		Format(p_osszesitettw[client], sizeof(p_osszesitettw[]), "");
		Format(p_osszesitettw2[client], sizeof(p_osszesitettw2[]), "");
		Format(query, sizeof(query), "SELECT * FROM lada_playerlada WHERE steam_id = '%s'", steamid);
		SQL_TQuery(hDatabase, T_GetPlayerDataCallback, query, client);
		Format(query, sizeof(query), "SELECT * FROM lada_stats WHERE steam_id = '%s'", steamid);
		SQL_TQuery(hDatabase, T_GetPlayerDataCallback2, query, client);
		Format(query, sizeof(query), "SELECT * FROM lada_blockopen WHERE steam_id = '%s'", steamid);
		SQL_TQuery(hDatabase, T_GetPlayerDataCallback3, query, client);
		Format(query, sizeof(query), "Select weapon,head,kills,ckills FROM lada_quest WHERE steam_id='%s'", steamid);
		SQL_TQuery(hDatabase, T_loadquest, query, client);
		int buffer_len = strlen(steamid) * 2 + 1;
		new String: v_steam_id[buffer_len];
		SQL_EscapeString(hDatabase, steamid, v_steam_id, buffer_len);
		char nev[60];
		GetClientName(client, nev, sizeof(nev));
		ReplaceString(nev, sizeof(nev), "'", "");
		ReplaceString(nev, sizeof(nev), "\"", "");
		ReplaceString(nev, sizeof(nev), ";", "");
		buffer_len = strlen(nev) * 2 + 1;
		new String: v_nev[buffer_len];
		SQL_EscapeString(hDatabase, nev, v_nev, buffer_len);
		Format(query, sizeof(query), "UPDATE lada_playerlada SET player_name='%s' where steam_id='%s'", v_nev, v_steam_id);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	
	g_bInGame[client]				 = false;
	g_eSSPItem[client]				 = None;
	g_iOponent[client]				 = -1;
	g_iGameAmount[client]			 = -1;
	g_bInAccept[client]				 = false;
	g_bIgnoringInvites[client]		 = false;
	g_iIgnoringInvitesBellow[client] = 0;

	if (CheckCommandAccess(client, "sm_totenfluchCMDAccess", ADMFLAG_GENERIC, true) && g_bDefaultOffForAdmins && !g_bUseMysqlForBlockSSP)
		g_bIgnoringInvites[client] = true;

	if (g_bUseMysqlForBlockSSP)
	{
		char checkId[20];
		GetClientAuthId(client, AuthId_Steam2, checkId, sizeof(checkId));

		Handle datapack = CreateDataPack();
		WritePackCell(datapack, client);
		ResetPack(datapack);

		char query[512];
		Format(query, sizeof(query), "SELECT Count(*) FROM ssp_sspblocked WHERE playerid = '%s'", checkId);
		SQL_TQuery(hDatabase, sql_CheckIfSSPBlockedCallback, query, datapack);
	}
}}

#if defined RAB

public Action:WelcomePlayer(Handle timer, int client)
{
	if (IsValidClient(client))
	{
		char szoveg[1000];
		Format(szoveg, sizeof(szoveg), "sm_loadcustomtag \"%s\" \"%s\" \"%s\" \"%s\"", g_ChatColor[client], g_ChatTag[client], g_ScoreTag[client], g_NameColor[client]);
		FakeClientCommandEx(client, szoveg);
		char sTag[400];
		CS_GetClientClanTag(client, sTag, sizeof(sTag));
		if (g_ScoreTagOkay[client] == 0)
		{
			if (StrEqual(sTag, g_ScoreTag[client]))
			{
				g_ScoreTagOkay[client] = 1;
			}
			else {
				CreateTimer(2.0, WelcomePlayer, client);
			}
		}
	}
}
#endif

public void restart(int client)
{
	if (IsValidClient(client))
	{
		for (int i = 0; i < g_DB[client]; i++)
		{
			if(i>=MAX_SKIN){
				continue;
			}
			g_Skins[client][i]		   = 0;
			g_Weapon[client][i]		   = 0;
			g_Stattrak[client][i]	   = 0;
			g_StattrakCount[client][i] = 0;
			g_Seed[client][i]		   = 0;
			g_Float[client][i]		   = 0.0;
			g_SkinName[client][i]	   = "";
			g_Rare[client][i]		   = 0;
			g_skinlocked[client][i]    = false;
			g_Nametag[client][i]="";
		}
		for (int i = 0; i < 36; i++)
		{
			g_fegyvid[client][i] = -1;
		}
		g_DB[client]			 = 1;
		g_betoltve[client]		 = 0;
		g_eladskincredit[client] = 0;
		LoadPlayer(client);
	}
}

public void T_GetPlayerDataCallback3(Handle owner, Handle hndl, const String:error[], int client)
{
	if (IsValidClient(client))
	{
		if (hndl == INVALID_HANDLE)
		{
			LogError("[Ladarendszer]Query failed! %s", error);
		}
		if (SQL_GetRowCount(hndl) == 0)
		{}
		else {
			g_open[client] = 1;
		}
	}
}

public void T_GetPlayerDataCallback2(Handle owner, Handle hndl, const String:error[], int client)
{
	if (IsValidClient(client))
	{
		if (hndl == INVALID_HANDLE)
		{
			LogError("[Ladarendszer]Query failed! %s", error);
		}
		if (SQL_GetRowCount(hndl) == 0)
		{
			char steamid[32];
			if (GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true))
			{
				char query[255];
				Format(query, sizeof(query), "INSERT INTO lada_stats (steam_id) VALUES ('%s')", steamid);
				SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			}
		}
	}
}

public void T_GetPlayerDataCallback(Handle owner, Handle hndl, const String:error[], int client)
{
	if (IsValidClient(client))
	{
		if (hndl == INVALID_HANDLE)
		{
			LogError("[Ladarendszer]Query failed! %s", error);
		}
		if (SQL_GetRowCount(hndl) == 0)
		{
			char steamid[32];
			if (GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true))
			{
				char query[255];
				char nev[60];
				GetClientName(client, nev, sizeof(nev));
				ReplaceString(nev, sizeof(nev), "'", "");
				ReplaceString(nev, sizeof(nev), "\"", "");
				ReplaceString(nev, sizeof(nev), ";", "");
				int buffer_len = strlen(nev) * 2 + 1;
				new String: v_nev[buffer_len];
				SQL_EscapeString(hDatabase, nev, v_nev, buffer_len);
				Format(query, sizeof(query), "INSERT INTO lada_playerlada (steam_id,player_name) VALUES ('%s','%s')", steamid, v_nev);
				SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			}
		}
		else
		{
			LoadPlayerLada(client);
		}
	}
}

public LoadPlayerLada(int client)
{
	decl String: query[2000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	
	char szoveg[100];
	char info[100];
	Format(query, sizeof(query), "Select credits FROM `lada_playerlada` WHERE `steam_id`='%s'", v_steam_id);
	SQL_TQuery(hDatabase, T_ladaload2, query, client);
	for(int i=0;i<= maxloadedlada;i++){
		Format(szoveg,sizeof(szoveg),"%s",g_ladanev[i]);
		ReplaceString(szoveg,sizeof(szoveg)," ","_");
		Format(info, sizeof(info), "%d|%d", client, i);
		Handle hPackedSQL = CreateDataPack();
		WritePackString(hPackedSQL, info);
		Format(query, sizeof(query), "Select %s_l,%s_k FROM `lada_playerlada` WHERE `steam_id`='%s'",szoveg,szoveg, v_steam_id);
		SQL_TQuery(hDatabase, T_ladaload, query, hPackedSQL);
	}
	
	Format(query, sizeof(query), "Select openedlada,opened1,opened2,opened3,opened4,opened6,allcredit,opened7 FROM `lada_stats` WHERE `steam_id`='%s'", v_steam_id);
	SQL_TQuery(hDatabase, T_player_stat, query, client);
	LoadPlayer(client);
}

public T_ladaload(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int	 client	 = StringToInt(str[0]);
	int	 i		 = StringToInt(str[1]);
	if (SQL_FetchRow(hndl))
	{
		g_lada[client][i][0]=SQL_FetchInt(hndl, 0);
		g_lada[client][i][1]=SQL_FetchInt(hndl, 1);
		if(g_lada[client][i][0]<0){
			addlada(client,i,-g_lada[client][i][0]);
		}
		if(g_lada[client][i][1]<0){
			addkey(client,i,-g_lada[client][i][1]);
		}
	}
}

public T_ladaload2(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	
	if (SQL_FetchRow(hndl))
	{
		g_credits[client] = SQL_FetchInt(hndl, 0);
		char	logto[200];
		Format(logto, sizeof(logto), "Connected: %d", g_credits[client]);
		LogToSql(client, logto);
	}
}


public T_player_stat(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}

	if (SQL_FetchRow(hndl))
	{
		for (int i = 0; i < 8; i++)
		{
			g_PlayerStats[client][i] = SQL_FetchInt(hndl, i);
		}
	}
}
public LoadPlayer(int client)
{
	decl String: query[1024];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "Select skin_last,fegyver_id, skin_name, skin_id,skin_float,skin_stattrak,skin_stattrak_count,skin_seed,id,rare,skin_locked,skin_nametag FROM `lada_inv` WHERE `steam_id`='%s' ORDER BY `id` asc", v_steam_id);
	SQL_TQuery(hDatabase, T_playerload, query, client);
}

public T_loadquest(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	if (SQL_FetchRow(hndl))
	{
		q_questid[client] = SQL_FetchInt(hndl, 0);
		q_head[client]	   = SQL_FetchInt(hndl, 1);
		q_kills[client]	   = SQL_FetchInt(hndl, 2);
		q_ckills[client]   = SQL_FetchInt(hndl, 3);
	}
	else {
		q_done[client] = 1;
	}
}

public T_playerload(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	g_DB[client] = 1;
	int asd2;
	int lock;
	while (SQL_FetchRow(hndl))
	{
		if(g_DB[client]>=MAX_SKIN){
				continue;
		}
		asd2							   = SQL_FetchInt(hndl, 0);
		g_Weapon[client][g_DB[client]] = SQL_FetchInt(hndl, 1);
		SQL_FetchString(hndl, 2, g_SkinName[client][g_DB[client]], sizeof(g_SkinName[][]));
		g_Skins[client][g_DB[client]]		  = SQL_FetchInt(hndl, 3);
		g_Float[client][g_DB[client]]		  = SQL_FetchInt(hndl, 4);
		g_Stattrak[client][g_DB[client]]	  = SQL_FetchInt(hndl, 5);
		g_StattrakCount[client][g_DB[client]] = SQL_FetchInt(hndl, 6);
		g_Seed[client][g_DB[client]]		  = SQL_FetchInt(hndl, 7);
		if (asd2 == 1)
		{
			g_fegyvid[client][Getfegyverid(client, g_DB[client])] = g_DB[client];
		}
		g_Id[client][g_DB[client]]	 = SQL_FetchInt(hndl, 8);
		g_Rare[client][g_DB[client]] = SQL_FetchInt(hndl, 9);
		lock = SQL_FetchInt(hndl,10);
		if(lock==1){
			g_skinlocked[client][g_DB[client]]=true;
		}else{
			g_skinlocked[client][g_DB[client]]=false;
		}
		SQL_FetchString(hndl, 11, g_Nametag[client][g_DB[client]], sizeof(g_Nametag[][]));
		if(asd2==1 && g_Rare[client][g_DB[client]]==8){
			felveszcustomskin(client,g_Weapon[client][g_DB[client]],g_SkinName[client][g_DB[client]]);
		}
		g_DB[client]++;
	}
	g_betoltve[client]	= 1;
	g_connected[client] = 1;
}
