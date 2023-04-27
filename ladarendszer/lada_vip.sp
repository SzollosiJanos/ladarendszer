#if defined RAB

public Action:cmd_addvip(int client, int argc)
{
	char nev[64], ertek[32], tipus[32];
	if (argc <= 2)
	{
		CReplyToCommand(client, "%T Használat: {grey}!addvip <név> <vip időtartama napokban> <típus>", "Server Name", client);
		return Plugin_Handled;
	}
	GetCmdArg(1, nev, sizeof(nev));
	decl m_iTargets[1];
	decl bool: m_bTmp;
	int target = ProcessTargetString(nev, 0, m_iTargets, 1, 0, nev, sizeof(nev), m_bTmp);
	if (target > 2)
	{
		CReplyToCommand(client, "%T {red}Több játékos található ezzel a névvel!", "Server Name", client);
		return Plugin_Handled;
	}
	if (target != 1)
	{
		CReplyToCommand(client, "%T {red}Játékos nem található!", "Server Name", client);
		return Plugin_Handled;
	}
	target = m_iTargets[0];
	GetCmdArg(2, ertek, sizeof(ertek));
	GetCmdArg(3, tipus, sizeof(tipus));
	if (!IsInteger(ertek))
	{
		CPrintToChat(client, "%s", "%T %T", "Server Name", client, "error not a number", client);
		return Plugin_Handled;
	}
	int szam = StringToInt(ertek, 10);
	if (szam > 0)
	{
		char query[255];
		char steamid[32];
		GetClientAuthId(target, AuthId_Steam2, steamid, sizeof(steamid), true);
		Format(query, sizeof(query), "SELECT timestamp,UNIX_TIMESTAMP(Now()) FROM lada_vip WHERE steam_id = '%s'", steamid);
		Handle  hPackedSQL = CreateDataPack();
		char info[200];
		Format(info, sizeof(info), "%d|%d|%s", target, szam, tipus);
		WritePackString(hPackedSQL, info);
		SQL_TQuery(hDatabase, T_GetPlayerVip, query, hPackedSQL);
		CPrintToChat(client, "{red}%N kapott %d nap vipet!!", target, szam);
	}
	else {
		CPrintToChat(client, "{red}A számnak nagyobbnak kell lennie, mint 0!!");
	}
	return Plugin_Handled;
}

public void T_GetPlayerVip(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[200];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[3][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int	 client = StringToInt(str[0]);
	int	 szam	= StringToInt(str[1]);
	char tipus[32];
	Format(tipus, sizeof(tipus), "%s", str[2]);
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	char steamid[32];
	char query[255];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
	if (SQL_GetRowCount(hndl) == 0)
	{
		int asd2 = szam * 86400;
		Format(query, sizeof(query), "INSERT INTO lada_vip (steam_id,timestamp,type) VALUES ('%s',%s+%d,'%s')", steamid, "UNIX_TIMESTAMP(Now())", asd2, tipus);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		Format(query, sizeof(query), "INSERT INTO lada_viptags (steam_id) VALUES ('%s')", steamid);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	}
	if (SQL_FetchRow(hndl))
	{
		int timestamp = SQL_FetchInt(hndl, 0);
		int now		  = SQL_FetchInt(hndl, 1);
		if (now > timestamp)
		{
			int asd2 = szam * 86400;
			Format(query, sizeof(query), "UPDATE lada_vip set timestamp=%d,type='%s' WHERE steam_id='%s'", asd2 + now, tipus, steamid);
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		}
		else {
			int asd2 = szam * 86400;
			Format(query, sizeof(query), "UPDATE lada_vip set timestamp=timestamp+%d,type='%s' WHERE steam_id='%s'", asd2, tipus, steamid);
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		}
	}
	loadvip(client, tipus);
}

loadvip(int client, char tipus[32])
{
	char steamid[32];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
	new GroupId:id = FindAdmGroup(tipus);
	if (id == INVALID_GROUP_ID)
	{
		return;
	}
	new AdminId:admin = CreateAdmin();
	SetUserAdmin(client, admin, true);
	AdminInheritGroup(admin, id);
	if (StrEqual(tipus, "vip"))
	{
		EmitSoundToAll("join_sounds/vip_join_astronaut.mp3");
		CPrintToChatAll("[{darkred}JOIN{grey}] {darkred}Vip{grey}: {BLUE}%N{grey} has joined the server.", client);
	}
}

checkvip(int client)
{
	char steamid[32];
	char query[255];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
	Format(query, sizeof(query), "SELECT timestamp,UNIX_TIMESTAMP(Now()),type FROM lada_vip WHERE steam_id = '%s'", steamid);
	SQL_TQuery(hDatabase, T_CheckPlayerVip, query, client);
}

public void T_CheckPlayerVip(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	char steamid[32];
	char query[255];
	char tipus[32];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
	if (SQL_FetchRow(hndl))
	{
		int timestamp = SQL_FetchInt(hndl, 0);
		int now		  = SQL_FetchInt(hndl, 1);
		SQL_FetchString(hndl, 2, tipus, sizeof(tipus));
		if (now > timestamp)
		{
			if (StrEqual(tipus, "vip"))
			{
				Format(query, sizeof(query), "DELETE FROM lada_vip WHERE steam_id = '%s'", steamid);
				SQL_TQuery(hDatabase, T_TestKnife4, query, client);
				Format(query, sizeof(query), "DELETE FROM lada_viptags WHERE steam_id='%s'", steamid);
				SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			}
			else {
				ReplaceString(tipus, sizeof(tipus), "vip", "");
				Format(query, sizeof(query), "UPDATE lada_vip set type='%s' WHERE steam_id='%s'", steamid, tipus);
				SQL_TQuery(hDatabase, T_TestKnife4, query, client);
				addadminprefix(client, tipus);
				loadvip(client, tipus);
			}
		}
		else {
			Format(query, sizeof(query), "SELECT ChatTag,ChatColor,NameColor FROM lada_viptags WHERE steam_id = '%s'", steamid);
			SQL_TQuery(hDatabase, T_CheckPlayerColors, query, client);
			loadvip(client, tipus);
		}
	}
	else {
		Format(query, sizeof(query), "SELECT ChatTag,ChatColor,NameColor FROM lada_viptags WHERE steam_id = '%s'", steamid);
		SQL_TQuery(hDatabase, T_CheckPlayerColors2, query, client);
	}
}

addadminprefix(int client, char tipus[32])
{
	Format(g_NameColor[client], sizeof(g_NameColor[]), "{grey}");
	Format(g_ChatColor[client], sizeof(g_ChatColor[]), "{green}");
	if (StrEqual(tipus, "foadmin"))
	{
		Format(g_ChatTag[client], sizeof(g_ChatTag[]), "{red}[Főadmin] ");
	}
	else if (StrEqual(tipus, "admin")) {
		Format(g_ChatTag[client], sizeof(g_ChatTag[]), "{red}[Admin] ");
	}
	else {
		Format(g_ChatTag[client], sizeof(g_ChatTag[]), "{red}[Ideiglenes Admin] ");
	}
	CreateTimer(1.0, WelcomePlayer, client);
	CreateTimer(10.0, WelcomePlayer, client);
	CreateTimer(20.0, WelcomePlayer, client);
}

public void T_CheckPlayerColors2(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	char steamid[32];
	char query[255];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
	if (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, g_ChatTag[client], sizeof(g_ChatTag[]));
		SQL_FetchString(hndl, 1, g_ChatColor[client], sizeof(g_ChatColor[]));
		SQL_FetchString(hndl, 2, g_NameColor[client], sizeof(g_NameColor[]));
		Format(g_ScoreTag[client], sizeof(g_ScoreTag[]), "%s", g_ChatTag[client]);
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{default}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lightred}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{red}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{darkred}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{blue}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{darkblue}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{bluegrey}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{purple}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{orchid}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{yellow}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{green}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lightgreen}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lime}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{grey}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{gold}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{grey2}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{random}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{rainbow}", "");
	}
	CreateTimer(1.0, WelcomePlayer, client);
	CreateTimer(10.0, WelcomePlayer, client);
	CreateTimer(20.0, WelcomePlayer, client);
}

public void T_CheckPlayerColors(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	char steamid[32];
	char query[255];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
	if (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, g_ChatTag[client], sizeof(g_ChatTag[]));
		SQL_FetchString(hndl, 1, g_ChatColor[client], sizeof(g_ChatColor[]));
		SQL_FetchString(hndl, 2, g_NameColor[client], sizeof(g_NameColor[]));
		Format(g_ScoreTag[client], sizeof(g_ScoreTag[]), "%s", g_ChatTag[client]);
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{default}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lightred}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{red}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{darkred}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{blue}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{darkblue}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{bluegrey}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{purple}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{orchid}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{yellow}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{green}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lightgreen}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lime}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{grey}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{gold}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{grey2}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{random}", "");
		ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{rainbow}", "");
		CreateTimer(1.0, WelcomePlayer, client);
	}
	if (SQL_GetRowCount(hndl) == 0)
	{
		Format(query, sizeof(query), "INSERT INTO lada_viptags (steam_id) VALUES ('%s')", steamid);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		CreateTimer(1.0, WelcomePlayer, client);
		CreateTimer(10.0, WelcomePlayer, client);
		CreateTimer(20.0, WelcomePlayer, client);
	}
}

freeaddvip(int client, int szam)
{
	char steamid[32];
	char query[255];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
	Handle  hPackedSQL = CreateDataPack();
	char info[200];
	Format(info, sizeof(info), "%d|%d", client, szam);
	WritePackString(hPackedSQL, info);
	CPrintToChat(client, "{red}Gratulálok, nyitottál %d nap vipet!!", szam);
	char logto[200];
	Format(logto, sizeof(logto), "28. nap free vip");
	LogToSql(client, logto);
	Format(query, sizeof(query), "SELECT type,timestamp,UNIX_TIMESTAMP(Now()) FROM lada_vip WHERE steam_id = '%s'", steamid);
	SQL_TQuery(hDatabase, T_CheckPlayerFreeVip, query, hPackedSQL);
}

public void T_CheckPlayerFreeVip(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	char steamid[32];
	char query[255];
	char tipus[32];
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	int szam   = StringToInt(str[1]);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
	if (SQL_FetchRow(hndl))
	{
		int timestamp;
		int now;
		SQL_FetchString(hndl, 0, tipus, sizeof(tipus));
		timestamp = SQL_FetchInt(hndl, 1);
		now		  = SQL_FetchInt(hndl, 2);
		if (now > timestamp)
		{
			if (StrContains(tipus, "vip") != -1)
			{
				int asd2 = szam * 86400;
				Format(query, sizeof(query), "UPDATE lada_vip set timestamp=UNIX_TIMESTAMP(Now())+%d WHERE steam_id='%s'", asd2, steamid);
				SQL_TQuery(hDatabase, T_CheckPlayerVip, query, client);
			}
			else {
				char szoveg[32];
				Format(szoveg, sizeof(szoveg), "%svip", tipus);
				int asd2 = szam * 86400;
				Format(query, sizeof(query), "UPDATE lada_vip set timestamp=UNIX_TIMESTAMP(Now())+%d,type='%s' WHERE steam_id='%s'", asd2, szoveg, steamid);
				SQL_TQuery(hDatabase, T_CheckPlayerVip, query, client);
			}
		}
		else {
			if (StrContains(tipus, "vip") != -1)
			{
				int asd2 = szam * 86400;
				Format(query, sizeof(query), "UPDATE lada_vip set timestamp=timestamp+%d WHERE steam_id='%s'", asd2, steamid);
				SQL_TQuery(hDatabase, T_CheckPlayerVip, query, client);
			}
			else {
				char szoveg[32];
				Format(szoveg, sizeof(szoveg), "%svip", tipus);
				int asd2 = szam * 86400;
				Format(query, sizeof(query), "UPDATE lada_vip set timestamp=timestamp+%d,type='%s' WHERE steam_id='%s'", asd2, szoveg, steamid);
				SQL_TQuery(hDatabase, T_CheckPlayerVip, query, client);
			}
		}
	}
	if (SQL_GetRowCount(hndl) == 0)
	{
		int asd2 = 86400 * szam;
		Format(query, sizeof(query), "INSERT INTO lada_vip (steam_id,type,timestamp) VALUES ('%s','%s',%s+%d)", steamid, "vip", "UNIX_TIMESTAMP(Now())", asd2);
		SQL_TQuery(hDatabase, T_CheckPlayerVip, query, client);
	}
}

public Action:Command_chatcolor(int client, int argc)
{
	char nev[100];
	char query[500];
	char steamid[32];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
	if (argc < 1)
	{
		CReplyToCommand(client, "%T Használat: {grey}!chatcolor szín", "Server Name", client);
		return Plugin_Handled;
	}
	GetCmdArg(1, nev, sizeof(nev));
	if (StrEqual(nev, "lightred", false)) { Format(g_ChatColor[client], sizeof(g_ChatColor), "{lightred}"); }
	else if (StrEqual(nev, "darkred", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{darkred}");
	}
	else if (StrEqual(nev, "red", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{red}");
	}
	else if (StrEqual(nev, "green", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{green}");
	}
	else if (StrEqual(nev, "lightgreen", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{lightgreen}");
	}
	else if (StrEqual(nev, "lime", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{lime}");
	}
	else if (StrEqual(nev, "gold", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{gold}");
	}
	else if (StrEqual(nev, "yellow", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{yellow}");
	}
	else if (StrEqual(nev, "blue", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{blue}");
	}
	else if (StrEqual(nev, "darkblue", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{darkblue}");
	}
	else if (StrEqual(nev, "grey", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{grey}");
	}
	else if (StrEqual(nev, "grey2", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{grey2}");
	}
	else if (StrEqual(nev, "bluegrey", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{bluegrey}");
	}
	else if (StrEqual(nev, "default", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{default}");
	}
	else if (StrEqual(nev, "purple", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{purple}");
	}
	else if (StrEqual(nev, "rainbow", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{rainbow}");
	}
	else if (StrEqual(nev, "random", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{random}");
	}
	else if (StrEqual(nev, "orchid", false)) {
		Format(g_ChatColor[client], sizeof(g_ChatColor), "{orchid}");
	}
	else {
		CPrintToChat(client, "{red}Hiba!! Nincs ilyen szín");
		return Plugin_Handled;
	}
	Format(query, sizeof(query), "UPDATE lada_viptags set ChatColor='%s' WHERE steam_id='%s'", g_ChatColor[client], steamid);
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	CreateTimer(1.0, WelcomePlayer, client);
	return Plugin_Handled;
}

public Action:Command_namecolor(int client, int argc)
{
	char nev[100];
	char query[500];
	char steamid[32];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
	if (argc < 1)
	{
		CReplyToCommand(client, "%T Használat: {grey}!namecolor szín", "Server Name", client);
		return Plugin_Handled;
	}
	GetCmdArg(1, nev, sizeof(nev));
	if (StrEqual(nev, "lightred", false)) { Format(g_NameColor[client], sizeof(g_NameColor), "{lightred}"); }
	else if (StrEqual(nev, "darkred", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{darkred}");
	}
	else if (StrEqual(nev, "red", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{red}");
	}
	else if (StrEqual(nev, "green", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{green}");
	}
	else if (StrEqual(nev, "lightgreen", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{lightgreen}");
	}
	else if (StrEqual(nev, "lime", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{lime}");
	}
	else if (StrEqual(nev, "gold", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{gold}");
	}
	else if (StrEqual(nev, "yellow", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{yellow}");
	}
	else if (StrEqual(nev, "blue", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{blue}");
	}
	else if (StrEqual(nev, "darkblue", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{darkblue}");
	}
	else if (StrEqual(nev, "grey", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{grey}");
	}
	else if (StrEqual(nev, "grey2", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{grey2}");
	}
	else if (StrEqual(nev, "bluegrey", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{bluegrey}");
	}
	else if (StrEqual(nev, "default", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{default}");
	}
	else if (StrEqual(nev, "purple", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{purple}");
	}
	else if (StrEqual(nev, "random", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{random}");
	}
	else if (StrEqual(nev, "rainbow", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{rainbow}");
	}
	else if (StrEqual(nev, "orchid", false)) {
		Format(g_NameColor[client], sizeof(g_NameColor), "{orchid}");
	}
	else {
		CPrintToChat(client, "{red}Hiba!! Nincs ilyen szín");
		return Plugin_Handled;
	}
	Format(query, sizeof(query), "UPDATE lada_viptags set NameColor='%s' WHERE steam_id='%s'", g_NameColor[client], steamid);
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	CreateTimer(1.0, WelcomePlayer, client);
	return Plugin_Handled;
}

public Action:Command_colors(int client, int argc)
{
	if (argc < 1)
	{
		CPrintToChat(client, "{default}default  {red}red  {darkred}darkred");
		CPrintToChat(client, "{blue}blue  {darkblue}darkblue  {bluegrey}bluegrey");
		CPrintToChat(client, "{purple}purple  {orchid}orchid  {yellow}yellow  {green}green");
		CPrintToChat(client, "{lime}lime  {grey}grey  {grey2}grey2 {gold}gold");
		return Plugin_Handled;
	}
}

public Action:Command_chattag(int client, int argc)
{
	char nev[400];
	char query[500];
	char steamid[32];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
	if (argc < 1)
	{
		CReplyToCommand(client, "%T Használat: {grey}!chattag formázás", "Server Name", client);
		return Plugin_Handled;
	}
	GetCmdArg(1, nev, sizeof(nev));
	Format(g_ChatTag[client], sizeof(g_ChatTag[]), "%s", nev);
	Format(g_ScoreTag[client], sizeof(g_ScoreTag[]), "%s", g_ChatTag[client]);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{default}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lightred}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{red}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{darkred}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{blue}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{darkblue}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{bluegrey}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{purple}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{orchid}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{yellow}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{green}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lightgreen}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{lime}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{grey}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{gold}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{grey2}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{rainbow}", "", false);
	ReplaceString(g_ScoreTag[client], sizeof(g_ScoreTag[]), "{random}", "", false);

	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{lightred}", "{lightred}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{red}", "{red}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{darkred}", "{darkred}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{blue}", "{blue}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{darkblue}", "{darkblue}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{bluegrey}", "{bluegrey}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{purple}", "{purple}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{orchid}", "{orchid}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{yellow}", "{yellow}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{green}", "{green}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{lightgreen}", "{lightgreen}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{lime}", "{lime}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{grey}", "{grey}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{gold}", "{gold}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{grey2}", "{grey2}", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{rainbow}", "", false);
	ReplaceString(g_ChatTag[client], sizeof(g_ChatTag[]), "{random}", "", false);
	char sEscapeName[400];
	SQL_EscapeString(hDatabase, g_ChatTag[client], sEscapeName, sizeof(sEscapeName));
	Format(query, sizeof(query), "UPDATE lada_viptags set ChatTag='%s' WHERE steam_id='%s'", sEscapeName, steamid);
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	// SendDiscordMessageClanTag(client);
	CreateTimer(1.0, WelcomePlayer, client);
	return Plugin_Handled;
}
#endif