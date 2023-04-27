

public questmenu(int client)
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
	Format(query, sizeof(query), "SELECT timestamp,UNIX_TIMESTAMP(Now()) FROM lada_questtime WHERE steam_id = '%s'", v_steam_id);
	SQL_TQuery(hDatabase, T_GetPlayerQuest, query, client);
}

public void T_GetPlayerQuest(Handle owner, Handle hndl, const String:error[], int client)
{
	if (IsValidClient(client))
	{
		if (hndl == INVALID_HANDLE)
		{
			LogError("[Ladarendszer]Query failed! %s", error);
		}
		else if (SQL_GetRowCount(hndl) == 0)
		{
			char steam_id[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
			new buffer_len = strlen(steam_id) * 2 + 1;
			new String: v_steam_id[buffer_len];
			SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			char query[255];
			Format(query, sizeof(query), "INSERT INTO lada_questtime (steam_id,timestamp) VALUES ('%s',UNIX_TIMESTAMP(Now()))", v_steam_id);
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			q_done[client] = 0;
			openquest(client);
		}
		if (SQL_FetchRow(hndl))
		{
			int times = SQL_FetchInt(hndl, 0);
			int now	  = SQL_FetchInt(hndl, 1);
			if ((times + 3600) <= now)
			{
				q_canreset[client] = 1;
			}
			if (q_done[client] == 1)
			{
				if ((times + 3600) <= now)
				{
					q_done[client]	   = 0;
					q_canreset[client] = 1;
					q_ckills[client]   = 0;
					openquest(client);
				}
				else {
					CPrintToChat(client, "%T %T", "Server Name", client, "error only 1 quest", client);
					q_canreset[client] = 0;
					q_ckills[client]   = 0;
					Cmd_mainmenu(client);
				}
			}
			else {
				openquest(client);
			}
		}
	}
}

public openquest(int client)
{
	char query[2000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "Select weapon,head,kills,ckills,win1,win1db,win2,win2db,winc FROM lada_quest WHERE steam_id='%s'", v_steam_id);
	SQL_TQuery(hDatabase, T_openquest, query, client);
}

public T_openquest(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	if (SQL_GetRowCount(hndl) == 0)
	{
		insertquest(client);
	}
	if (SQL_FetchRow(hndl))
	{
		q_questid[client] = SQL_FetchInt(hndl, 0);
		q_head[client]	   = SQL_FetchInt(hndl, 1);
		q_kills[client]	   = SQL_FetchInt(hndl, 2);
		int win1, win1db, win2, win2db, winc;
		win1   = SQL_FetchInt(hndl, 4);
		win1db = SQL_FetchInt(hndl, 5);
		win2   = SQL_FetchInt(hndl, 6);
		win2db = SQL_FetchInt(hndl, 7);
		winc   = SQL_FetchInt(hndl, 8);
		openquestmenu(client, win1, win1db, win2, win2db, winc);
	}
}

openquestmenu(int client, int win1, int win1db, int win2, int win2db, int winc)
{
	char name[20];
	Format(name,sizeof(name),"%d",q_questid[client]);
	KvJumpToKey(quest_kv, name);

	char questname[PLATFORM_MAX_PATH];
	KvGetString(quest_kv, "name", questname, PLATFORM_MAX_PATH, "none");
	
	KvRewind(quest_kv);
	



	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char szoveg[1000];
	if (q_head[client] == 0)
	{
		Format(szoveg, sizeof(szoveg), "Fegyver: %s\nÖlések: [%d/%d]\n\nNyeremények:", questname, q_kills[client], q_ckills[client]);
	}
	else {
		Format(szoveg, sizeof(szoveg), "Fegyver: %s\nÖlések: [%d/%d]Csak fejlövéssel!!!\n\n\n\nNyeremények:", questname, q_kills[client], q_ckills[client]);
	}
	menu.DrawText(szoveg);
	Format(szoveg, sizeof(szoveg), "");
	if (win1db > 0)
	{
		if (win1 <= maxloadedlada)
		{
			Format(szoveg, sizeof(szoveg), "%s láda [%d db]", ladaidtonev(win1), win1db);
		}
		else {
			Format(szoveg, sizeof(szoveg), "%s ládakulcs [%d db]", ladaidtonev(win1 - (maxloadedlada)), win1db);
		}
	}
	if (win2db > 0)
	{
		if (win2 <= maxloadedlada)
		{
			Format(szoveg, sizeof(szoveg), "%s\n%s láda [%d db]", szoveg, ladaidtonev(win2), win2db);
		}
		else {
			Format(szoveg, sizeof(szoveg), "%s\n%s ládakulcs [%d db]", szoveg, ladaidtonev(win2 - (maxloadedlada)), win2db);
		}
	}
	Format(szoveg, sizeof(szoveg), "%s\n%s %T", szoveg, formatosszeg(winc), "coin name", client);
	menu.DrawText(szoveg);
	menu.DrawText(" ");
	if (q_kills[client] == q_ckills[client])
	{
		menu.DrawItem("Jutalom begyűjtése");
	}
	else {
		menu.DrawItem("Új küldetés kérése(óránként 1x)");
	}

	menu.DrawText(" ");
	menu.CurrentKey = 9;
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, m_openquestmenu, 60);
	delete menu;
}

public int m_openquestmenu(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char query[2000];
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		new buffer_len = strlen(steam_id) * 2 + 1;
		new String: v_steam_id[buffer_len];
		SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
		if (item == 1)
		{
			if (q_kills[client] == q_ckills[client])
			{
				q_done[client]	 = 1;
				q_ckills[client] = 0;
				Format(query, sizeof(query), "Select win1,win1db,win2,win2db,winc FROM lada_quest WHERE steam_id='%s'", v_steam_id);
				SQL_TQuery(hDatabase, T_openquest2, query, client);
			}
			else {
				if (q_canreset[client] == 1)
				{
					q_canreset[client] = 0;
					Format(query, sizeof(query), "DELETE FROM lada_quest where steam_id='%s'", v_steam_id);
					SQL_TQuery(hDatabase, T_TestKnife4, query, client);
					Format(query, sizeof(query), "UPDATE lada_questtime SET timestamp=UNIX_TIMESTAMP(Now()) where steam_id='%s'", v_steam_id);
					SQL_TQuery(hDatabase, T_resetquest, query, client);
				}
				else {
					CPrintToChat(client, "%T %T", "Server Name", client, "error only 1 quest reset", client);
					openquest(client);
				}
			}
		}
		else {
			Cmd_premainmenu(client, 0);
		}
	}
}

public T_openquest2(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	if (SQL_FetchRow(hndl))
	{
		int win1, win1db, win2, win2db, winc;
		win1   = SQL_FetchInt(hndl, 0);
		win1db = SQL_FetchInt(hndl, 1);
		win2   = SQL_FetchInt(hndl, 2);
		win2db = SQL_FetchInt(hndl, 3);
		winc   = SQL_FetchInt(hndl, 4);
		char query[2000];
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		new buffer_len = strlen(steam_id) * 2 + 1;
		new String: v_steam_id[buffer_len];
		SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
		Format(query, sizeof(query), "DELETE FROM lada_quest where steam_id='%s'", v_steam_id);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		char logto[200];
		if (win1db > 0)
		{
			if (win1 <= maxloadedlada)
			{
				CPrintToChat(client, "%T %T", "Server Name", client, "quest case", client, win1db, ladaidtonev(win1));
				addlada(client,win1,win1db);
			}
			else {
				CPrintToChat(client, "%T %T", "Server Name", client, "quest key", client, win1db, ladaidtonev(win1 - (maxloadedlada)));
				addkey(client,win1 - (maxloadedlada),win1db);
			}
		}
		if (win2db > 0)
		{
			if (win2 <= maxloadedlada)
			{
				CPrintToChat(client, "%T %T", "Server Name", client, "quest case", client, win2db, ladaidtonev(win2));
				addlada(client,win2,win2db);
			}
			else {
				CPrintToChat(client, "%T %T", "Server Name", client, "quest key", client, win2db, ladaidtonev(win2 - (maxloadedlada)));
				addkey(client,win2 - (maxloadedlada),win2db);
			}
		}
		addcredit(client, winc);
		Format(logto, sizeof(logto), "Quest credit: %d", winc);
		LogToSql(client, logto);
		char asd277[1000];
		Format(asd277, sizeof(asd277), "%T", "coin name", client);
		char osszeg[50];
		Format(osszeg, sizeof(osszeg), "%s", formatosszeg(winc));
		Format(asd277, sizeof(asd277), "%T", "quest coin", client, osszeg, asd277);
		CPrintToChat(client, "%T %s", "Server Name", client, asd277);
		g_PlayerStats[client][6] += winc;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query, sizeof(query), "UPDATE lada_stats set allcredit=allcredit+'%d' where steam_id='%s'", winc, steam_id);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		q_ckills[client] = 0;
	}
}

public T_resetquest(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	char logto[200];
	Format(logto, sizeof(logto), "Quest reset");
	q_ckills[client] = 0;
	LogToSql(client, logto);
	questmenu(client);
}

public insertquest(int client)
{
	char query[2000];
	char steam_id[32];
	q_ckills[client] = 0;
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "UPDATE lada_questtime SET timestamp=UNIX_TIMESTAMP(Now()) where steam_id='%s'", v_steam_id);
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	char iweapon[100];
	
	KvGotoFirstSubKey(quest_kv);
	char buffer[255];
	int maxi=0;
    do
    {
        KvGetSectionName(quest_kv,buffer, sizeof(buffer));
		if(StringToInt(buffer)>maxi){
			maxi=StringToInt(buffer);
		}
    } while (KvGotoNextKey(quest_kv));
	KvRewind(quest_kv);
	int	 randomi;
	if(maxi==0){
		randomi= 0;
	}else{
		randomi= GetRandomInt(0, maxi);
	}
	
	
	char name[20];
	Format(name,sizeof(name),"%d",randomi);
	KvJumpToKey(quest_kv, name);

	char questname[PLATFORM_MAX_PATH];
	KvGetString(quest_kv, "name", questname, PLATFORM_MAX_PATH, "none");
	
	KvRewind(quest_kv);
	 
	Format(iweapon, sizeof(iweapon), "%s", questname);
	int	  win1		 = GetRandomInt(0, maxloadedlada);
	int	  win2		 = GetRandomInt(0, maxloadedlada);
	bool ok=false;
	while(ok==false){
		win1 = GetRandomInt(0, maxloadedlada);
		if(g_ladadropkill[win1]==1){
			ok=true;
		}
	}
	ok=false;
	while(ok==false){
		win2 = GetRandomInt(0, maxloadedlada);
		if(g_ladadropkill[win2]==1){
			ok=true;
		}
	}
	if(GetRandomInt(0, 1)==1){
		win1+=maxloadedlada+1;
	}
	if(GetRandomInt(0, 1)==1){
		win2+=maxloadedlada+1;
	}
	int	  win1db	 = GetRandomInt(0, 3);
	int	  win2db	 = GetRandomInt(0, 3);
	int	  questkills = GetRandomInt(10, 30);
	int	  questhead	 = GetRandomInt(0, 100);
	int	  head		 = 0;
	float winci		 = float(questkills * 27);
	if (questhead <= 35)
	{
		winci = winci * 1.3;
	}
	int winc = RoundFloat(winci);

	Format(query, sizeof(query), "INSERT INTO lada_quest(steam_id,weapon,head,kills,ckills,win1,win1db,win2,win2db,winc) VALUES('%s','%d','%d','%d','%d','%d','%d','%d','%d','%d')", v_steam_id, randomi, head, questkills, 0, win1, win1db, win2, win2db, winc);
	SQL_TQuery(hDatabase, T_insertquest, query, client);
}

public T_insertquest(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	openquest(client);
	return;
}