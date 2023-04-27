

public openlotto(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	char query[255];
	Format(query, sizeof(query), "SELECT timestamp,UNIX_TIMESTAMP(Now()) FROM lada_lottotimer");
	SQL_TQuery(hDatabase, T_GetLottoTimer, query, client);
}

public Action:Cmd_openlotto(int client, int argc)
{
	openlotto(client);
}

public void T_GetLottoTimer(Handle owner, Handle hndl, const String:error[], int client)
{
	if (IsValidClient(client))
	{
		if (hndl == INVALID_HANDLE)
		{
			LogError("[Ladarendszer]Query failed! %s", error);
		}
		if (SQL_FetchRow(hndl))
		{
			int	 timestamp = SQL_FetchInt(hndl, 0);
			int	 now	   = SQL_FetchInt(hndl, 1);
			char query[255];
			char steam_id[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
			new buffer_len = strlen(steam_id) * 2 + 1;
			new String: v_steam_id[buffer_len];
			SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			Format(query, sizeof(query), "SELECT number FROM lada_lotto WHERE steam_id='%s'", v_steam_id);
			char asd2[100];
			Format(asd2, sizeof(asd2), "%d|%d|%d", client, timestamp, now);
			Handle  hPackedSQL = CreateDataPack();
			WritePackString(hPackedSQL, asd2);
			SQL_TQuery(hDatabase, T_GetLottoPlayer, query, hPackedSQL);
		}
	}
}

public void T_GetLottoPlayer(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[3][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	if (IsValidClient(client))
	{
		if (hndl == INVALID_HANDLE)
		{
			LogError("[Ladarendszer]Query failed! %s", error);
		}
		if (SQL_GetRowCount(hndl) == 0)
		{
			char query[255];
			char steam_id[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
			new buffer_len = strlen(steam_id) * 2 + 1;
			new String: v_steam_id[buffer_len];
			SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			Format(query, sizeof(query), "INSERT INTO lada_lotto(steam_id,number) VALUES ('%s',0)", v_steam_id);
			SQL_TQuery(hDatabase, T_LottoOpenAgain, query, client);
		}
		if (SQL_FetchRow(hndl))
		{
			int	 number = SQL_FetchInt(hndl, 0);
			char query[255];
			Format(query, sizeof(query), "SELECT SUM(number) FROM lada_lotto");
			char asd2[200];
			Format(asd2, sizeof(asd2), "%d|%d|%d|%d", StringToInt(str[0]), StringToInt(str[1]), StringToInt(str[2]), number);
			Handle  hPackedSQL2 = CreateDataPack();
			WritePackString(hPackedSQL2, asd2);
			SQL_TQuery(hDatabase, T_GetLottoPlayer2, query, hPackedSQL2);
		}
	}
}

public void T_GetLottoPlayer2(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[200];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[4][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	if (IsValidClient(client))
	{
		if (hndl == INVALID_HANDLE)
		{
			LogError("[Ladarendszer]Query failed! %s", error);
		}
		if (SQL_FetchRow(hndl))
		{
			int sumnumber = SQL_FetchInt(hndl, 0);
			openlottofinal(StringToInt(str[0]), StringToInt(str[3]), StringToInt(str[1]), StringToInt(str[2]), sumnumber);
		}
	}
}

openlottofinal(int client, int number, int timestamp, int now, int sumnumber)
{
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char asd2[100];
	Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client, formatosszeg(g_credits[client]));
	menu.DrawText(asd2);
	menu.DrawText(" ");

	char szoveg[50];
	int	 elapsed = (timestamp + 604800) - now;
	if (elapsed > 0)
	{
		int nap	 = elapsed / 86400;
		int ora	 = (elapsed - (nap * 86400)) / 3600;
		int perc = (elapsed - (ora * 3600 + nap * 86400)) / 60;
		Format(szoveg, sizeof(szoveg), "Szelvényeid: %d", number);
		menu.DrawText(szoveg);
		menu.DrawText("Hátralévő idő sorsolásig:");
		Format(szoveg, sizeof(szoveg), "%d nap %d óra %d perc", nap, ora, perc);
		menu.DrawText(szoveg);
		Format(szoveg, sizeof(szoveg), "Nyeremény: %d.00 %T", sumnumber * (g_ilottoar - g_iquickselllotto), "coin name", client);
		menu.DrawText(szoveg);
	}
	else {
		int nap	 = elapsed / 86400;
		int ora	 = (elapsed - (nap * 86400)) / 3600;
		int perc = (elapsed - (ora * 3600 + nap * 86400)) / 60;
		Format(szoveg, sizeof(szoveg), "Szelvényeid: %d", number);
		menu.DrawText(szoveg);
		menu.DrawText("Hátralévő idő sorsolásig:");
		Format(szoveg, sizeof(szoveg), "Hamarosan");
		menu.DrawText(szoveg);
		Format(szoveg, sizeof(szoveg), "Nyeremény: %d.00 %T", sumnumber * (g_ilottoar - g_iquickselllotto), "coin name", client);
		menu.DrawText(szoveg);
	}

	char asd22[50];
	Format(asd22, sizeof(asd22), "Szelvény vásárlása %d %Tért", g_ilottoar, "coin name", client);
	menu.DrawItem(asd22);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, T_Lotto, 60);
	delete menu;
}

public int T_Lotto(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if (item == 1)
		{
			char query[255];
			char steam_id[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
			new buffer_len = strlen(steam_id) * 2 + 1;
			new String: v_steam_id[buffer_len];
			SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			if (g_credits[client] > g_ilottoar * 100)
			{
				addcredit(client, -g_ilottoar * 100);
				addado(g_iquickselllotto * 100);
				char logto[200];
				LogToSql(client, logto);
				Format(query, sizeof(query), "UPDATE lada_lotto SET number=number+1 WHERE steam_id='%s'", v_steam_id);
				SQL_TQuery(hDatabase, T_LottoOpenAgain, query, client);
			}
			else {
				char asd277[1000];
				Format(asd277, sizeof(asd277), "%T", "coin name", client);
				Format(asd277, sizeof(asd277), "%T", "Not enough coin", client, asd277);
				CPrintToChat(client, "%T %s", "Server Name", client, asd277);
			}
		}
		else {
			casinoalap(client);
		}
	}
}

public T_LottoOpenAgain(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	openlotto(client);
	return;
}

public void T_GetLottoTimerWinner(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	if (SQL_FetchRow(hndl))
	{
		int timestamp = SQL_FetchInt(hndl, 0);
		int now		  = SQL_FetchInt(hndl, 1);
		int elapsed	  = (timestamp + 604800) - now;
		if (elapsed < 0)
		{
			char query[255];
			Format(query, sizeof(query), "SELECT SUM(number) FROM lada_lotto");
			SQL_TQuery(hDatabase, T_GetLottoWinner, query, 0);
			Format(query, sizeof(query), "UPDATE lada_lottotimer SET timestamp=timestamp+604800");
			SQL_TQuery(hDatabase, T_TestKnife4, query, 0);
		}
	}
}

public void T_GetLottoWinner(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	if (SQL_GetRowCount(hndl) == 0)
	{
		for (int k = 1; k < MAXPLAYERS; k++)
		{
			if (IsValidClient(k))
			{
				CPrintToChat(k, "%T %T", "Server Name", k, "no lotto this week", k);
			}
		}
		SendDiscordMessageLotto("Nem vett senki sem szelvényt", 0);
	}
	else if (SQL_FetchRow(hndl)) {
		int sumnumber = SQL_FetchInt(hndl, 0);
		if (sumnumber == 0)
		{
			for (int k = 1; k < MAXPLAYERS; k++)
			{
				if (IsValidClient(k))
				{
					CPrintToChat(k, "%T %T", "Server Name", k, "no lotto this week", k);
				}
			}
			SendDiscordMessageLotto("Nem vett senki sem szelvényt", 0);
		}
		else {
			char query[255];
			Format(query, sizeof(query), "SELECT steam_id,number FROM lada_lotto");
			SQL_TQuery(hDatabase, T_GetLottoWinner2, query, sumnumber);
		}
	}
}

public void T_GetLottoWinner2(Handle owner, Handle hndl, const String:error[], int sumnumber)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	int k = 0;
	while (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, l_steam_id[k], sizeof(l_steam_id[]));
		l_numbers[k] = SQL_FetchInt(hndl, 1);
		k++;
	}
	int randomplayer = GetRandomInt(0, sumnumber - 1);
	int max;
	while (randomplayer > 0)
	{
		max = GetRandomInt(0, k);
		randomplayer -= l_numbers[max];
	}

	char query[255];
	char logto[200];
	
	Format(query, sizeof(query), "Select player_name from `lada_playerlada` where `steam_id`='%s'", l_steam_id[max]);
	SQL_TQuery(hDatabase, T_GetPlayerName, query, sumnumber);
	Format(query, sizeof(query), "UPDATE lada_playerlada set credits=credits+'%d' where `steam_id`='%s'", sumnumber * 100 * (g_ilottoar - g_iquickselllotto), l_steam_id[max]);
	SQL_TQuery(hDatabase, T_TestKnife4, query, 0);
	Format(query, sizeof(query), "DELETE FROM lada_lotto");
	SQL_TQuery(hDatabase, T_TestKnife4, query, 0);
}

public void T_GetPlayerName(Handle owner, Handle hndl, const String:error[], int sumnumber)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	if (SQL_FetchRow(hndl))
	{
		char playername[100];
		SQL_FetchString(hndl, 0, playername, sizeof(playername));
		char asd2[1000];
		char osszeg[50];
		for (int k = 1; k < MAXPLAYERS; k++)
		{
			if (IsValidClient(k))
			{
				Format(asd2, sizeof(asd2), "%T", "coin name", k);
				Format(osszeg, sizeof(osszeg), "%d", sumnumber * (g_ilottoar - g_iquickselllotto));
				Format(asd2, sizeof(asd2), "%T", "lotto winner", k, playername, osszeg, asd2);

				CPrintToChat(k, "%T %s", "Server Name", k, asd2);
			}
		}
		SendDiscordMessageLotto(playername, sumnumber);
	}
}