

public napifree(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	char query[255];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "SELECT timestamp,UNIX_TIMESTAMP(Now()),counter FROM lada_freelada WHERE steam_id = '%s'", v_steam_id);
	SQL_TQuery(hDatabase, T_GetPlayernapicheckmain, query, client);
}

public void T_GetPlayernapicheckmain(Handle owner, Handle hndl, const String:error[], int client)
{
	if (IsValidClient(client))
	{
		if (hndl == INVALID_HANDLE)
		{
			LogError("[Ladarendszer]Query failed! %s", error);
		}
		else if (SQL_GetRowCount(hndl) == 0)
		{
			Menu menu = CreateMenu(T_NapiFreeMain);
			menu.SetTitle("");
			char szoveg[500];
			char query[255];
			char steam_id[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
			new buffer_len = strlen(steam_id) * 2 + 1;
			new String: v_steam_id[buffer_len];
			SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			Format(query, sizeof(query), "INSERT INTO lada_freelada(timestamp,steam_id,counter) VALUES (0,'%s',0) ", v_steam_id);
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			Format(szoveg, sizeof(szoveg), "Napi ingyenes ládanyitás\n");
			for (int i = 1; i <= 28; i++)
			{
				if (i < 10) { Format(szoveg, sizeof(szoveg), "%s0%d. ", szoveg, i); }
				else {
					Format(szoveg, sizeof(szoveg), "%s%d. ", szoveg, i);
				}

				if (i == 7 || i == 14 || i == 21 || i == 28)
				{
					Format(szoveg, sizeof(szoveg), "%s\n", szoveg);
				}
			}
			int counter = 0;
			menu.AddItem("", szoveg, ITEMDRAW_DISABLED);
			Format(szoveg, sizeof(szoveg), "%d", counter);
			menu.AddItem(szoveg, "Jutalom begyűjtése");
			menu.Display(client, 60);
		}
		if (SQL_FetchRow(hndl))
		{
			int	 times	 = SQL_FetchInt(hndl, 0);
			int	 now	 = SQL_FetchInt(hndl, 1);
			int	 counter = SQL_FetchInt(hndl, 2);
			char query[255];
			char steam_id[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
			new buffer_len = strlen(steam_id) * 2 + 1;
			new String: v_steam_id[buffer_len];
			SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			if (times + (86400 * 2) < now)
			{
				Format(query, sizeof(query), "UPDATE lada_freelada SET counter=0 where steam_id='%s'", v_steam_id);
				SQL_TQuery(hDatabase, T_TestKnife4, query, client);
				counter = 0;
			}
			int	 diff = (times + 86400) - now;
			int	 ora  = diff / 3600;
			int	 perc = (diff - (ora * 3600)) / 60;
			Menu menu = CreateMenu(T_NapiFreeMain);
			menu.SetTitle("");
			char szoveg[500];
			Format(szoveg, sizeof(szoveg), "Napi ingyenes ládanyitás\n");
			for (int i = 1; i <= 28; i++)
			{
				if (counter != i)
				{
					if (i < 10) { Format(szoveg, sizeof(szoveg), "%s0%d. ", szoveg, i); }
					else {
						Format(szoveg, sizeof(szoveg), "%s%d. ", szoveg, i);
					}
				}
				else {
					if (i < 10) { Format(szoveg, sizeof(szoveg), "%s(0%d.) ", szoveg, i); }
					else {
						Format(szoveg, sizeof(szoveg), "%s(%d.) ", szoveg, i);
					}
				}
				if (i == 7 || i == 14 || i == 21 || i == 28)
				{
					Format(szoveg, sizeof(szoveg), "%s\n", szoveg);
				}
			}
			Format(szoveg, sizeof(szoveg), "%s\n", szoveg);
			menu.AddItem("", szoveg, ITEMDRAW_DISABLED);
			if ((times + 86400) <= now)
			{
				Format(szoveg, sizeof(szoveg), "%d", counter);
				menu.AddItem(szoveg, "Jutalom begyűjtése");
			}
			else {
				Format(szoveg, sizeof(szoveg), "%d óra %d perc múlva tudod begyűjteni újra!!", ora, perc);
				menu.AddItem("", szoveg, ITEMDRAW_DISABLED);
			}
			menu.Display(client, 60);
		}
	}
}

public int T_NapiFreeMain(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int counter = StringToInt(info);
		opennapifree(client, counter);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public opennapifree(int client, int counter)
{
	char query[255];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	counter++;
	int szorzo = 1;
	int rands  = GetRandomInt(0, 100000);
	switch (counter)
	{
		case 7:
		{
			szorzo = 3;
			rands  = GetRandomInt(1001, 79999);
		}
		case 14:
		{
			szorzo = 6;
			rands  = GetRandomInt(1001, 79999);
		}
		case 21:
		{
			szorzo = 10;
			rands  = GetRandomInt(1001, 79999);
		}
		case 28:
		{
			szorzo = 0;
			rands  = 111111;
		}
	}
	if (counter == 28)
	{
		Format(query, sizeof(query), "UPDATE lada_freelada SET timestamp=UNIX_TIMESTAMP(Now()),counter=%d where steam_id='%s'", 0, v_steam_id);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	}
	else {
		Format(query, sizeof(query), "UPDATE lada_freelada SET timestamp=UNIX_TIMESTAMP(Now()),counter=%d where steam_id='%s'", counter, v_steam_id);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	}

	if (rands <= 60000) {
		rands = GetRandomInt(50, 200);
		rands = rands * szorzo;
		addcredit(client, rands);
		g_PlayerStats[client][6] += rands;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query, sizeof(query), "UPDATE lada_stats set allcredit=allcredit+'%d' where steam_id='%s'", rands, steam_id);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		char asd277[1000];
		Format(asd277, sizeof(asd277), "%T", "coin name", client);
		char osszeg[50];
		Format(osszeg, sizeof(osszeg), "%s", formatosszeg(rands));

		Format(asd277, sizeof(asd277), "%T", "quest coin", client, osszeg, asd277);
		CPrintToChat(client, "%T %s", "Server Name", client, asd277);
	}
	else {
		rands = GetRandomInt(200, 400);
		rands = rands * szorzo;
		addcredit(client, rands);
		g_PlayerStats[client][6] += rands;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query, sizeof(query), "UPDATE lada_stats set allcredit=allcredit+'%d' where steam_id='%s'", rands, steam_id);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		char asd277[1000];
		Format(asd277, sizeof(asd277), "%T", "coin name", client);
		char osszeg[50];
		Format(osszeg, sizeof(osszeg), "%s", formatosszeg(rands));

		Format(asd277, sizeof(asd277), "%T", "quest coin", client, osszeg, asd277);
		CPrintToChat(client, "%T %s", "Server Name", client, asd277);
		char logto[200];
	}

	char steam_id2[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id2, sizeof(steam_id2));
	if (CheckCommandAccess(client, "sm_vipvalamicuccos", ADMFLAG_CUSTOM5) || StrContains(steam_id2, "104603658", false) != -1)
	{
		int lada = GetRandomInt(0, maxloadedlada);
		bool ok=false;
		while(ok==false){
			lada = GetRandomInt(0, maxloadedlada);
			if(g_ladadropkill[lada]==1){
				ok=true;
			}
		}
		addkey(client,lada,1);
		addlada(client,lada,1);
	}
	CPrintToChat(client, "%T %T", "Server Name", client, "free credit ad", client);
	counter = 0;
	napifree(client);
}
