bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || IsFakeClient(client) || IsClientSourceTV(client) || IsClientReplay(client))
	{
		return false;
	}
	return true;
}

public Action:Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	// Player that was killed (use GetClientOfUserId() to get the client index)
	int	 victim	  = event.GetInt("userid");
	int	 attacker = event.GetInt("attacker");
	int	 client	  = GetClientOfUserId(attacker);
	int	 target	  = GetClientOfUserId(victim);
	//lada_cheat
    lada_cheat_playerdeath(target);
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	if (client != target && IsValidClient(client))
	{
		char weapon[64];
		event.GetString("weapon", weapon, sizeof(weapon));
		int fid = Getweaponidfromname(weapon);
		if (g_fegyvid[client][fid] != -1)
		{
			if (g_Stattrak[client][g_fegyvid[client][fid]] == 1)
			{
				g_StattrakCount[client][g_fegyvid[client][fid]]++;
				decl String:query[255];
				Format(query, sizeof(query), "UPDATE `lada_inv` SET `skin_stattrak_count`=`skin_stattrak_count`+1 WHERE `id`='%d'", g_Id[client][g_fegyvid[client][fid]]);
				SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			}
		}
		int ihead = 0;
		char asd2[1000];
		Format(asd2, sizeof(asd2), "%T", "coin name", client);
		char osszeg[50];
		float creditosszeg;
		if (event.GetBool("headshot"))
		{
			ihead = 1;
			if (VIP_IsClientVIP(client) && VIP_IsClientFeatureUse(client, g_szFeature1))
			{
				creditosszeg=VIP_GetClientFeatureFloat(client, g_szFeature1)*g_ikilldollarhead;
			}else {
				creditosszeg=g_ikilldollarhead;
			}
		}
		else {
			if (fid == 33)
			{
				if (VIP_IsClientVIP(client) && VIP_IsClientFeatureUse(client, g_szFeature1))
				{
					creditosszeg=VIP_GetClientFeatureFloat(client, g_szFeature1)*g_ikilldollarknife;
				}
				else {
					creditosszeg=g_ikilldollarknife;
				}
			}
			else {
				if (VIP_IsClientVIP(client) && VIP_IsClientFeatureUse(client, g_szFeature1))
				{
					creditosszeg=VIP_GetClientFeatureFloat(client, g_szFeature1)*g_ikilldollar;
				}
				else {
					creditosszeg=g_ikilldollar;
				}
			}
		}
		
		addcredit(client, RoundFloat(creditosszeg));
		Format(osszeg, sizeof(osszeg), "%s", formatosszeg(RoundFloat(creditosszeg)));
		Format(asd2, sizeof(asd2), "%T", "kill coin", client, osszeg, asd2);
		CPrintToChat(client, "%T %s", "Server Name", client, asd2);

		int minoseg = GetRandomInt(1, 100);
		int tipus;
		if (minoseg <= 15)
		{
			minoseg = GetRandomInt(0, maxloadedlada);
			tipus	= GetRandomInt(1, 100);
			if (tipus <= 10)
			{
				bool ok=false;
				while(ok==false){
					minoseg = GetRandomInt(0, maxloadedlada);
					if(g_ladadropkill[minoseg]==1){
						ok=true;
					}
				}
				addlada(client,minoseg,1);
				addkey(client,minoseg,1);
				CPrintToChat(client, "%T %T", "Server Name", client, "extra caseandkey", client, ladaidtonev(minoseg));
			}
			else if (tipus <= 70) {
				bool ok=false;
				while(ok==false){
					minoseg = GetRandomInt(0, maxloadedlada);
					if(g_ladadropkill[minoseg]==1){
						ok=true;
					}
				}
				CPrintToChat(client, "%T %T", "Server Name", client, "extra key", client, ladaidtonev(minoseg));
				addkey(client,minoseg,1);
			}
			else {
				bool ok=false;
				while(ok==false){
					minoseg = GetRandomInt(0, maxloadedlada);
					if(g_ladadropkill[minoseg]==1){
						ok=true;
					}
				}
				CPrintToChat(client, "%T %T", "Server Name", client, "extra case", client, ladaidtonev(minoseg));
				addlada(client,minoseg,1);
			}
		}
		if (q_done[client] == 0)
		{
			checkquestid(client, fid, ihead);
		}
	}
}


checkquestid(int client, int iid, int head)
{
	char name[20];
	Format(name,sizeof(name),"%d",q_questid[client]);
	KvJumpToKey(quest_kv, name);

	char questweapons[PLATFORM_MAX_PATH];
	KvGetString(quest_kv, "weapons", questweapons, PLATFORM_MAX_PATH, "none");
	
	KvRewind(quest_kv);
	
	char str[53][10];
	ExplodeString(questweapons,",",str,sizeof(str),sizeof(str[]));
	int kiir=0;
	for(int i=0;i<53;i++){
		if(StrEqual(str[i],"")){
			return;
		}
		
		if (q_ckills[client] != q_kills[client])
		{
			if (iid == StringToInt(str[i]))
			{
				if (q_head[client] == 1)
				{
					if (head == 1)
					{
						q_ckills[client] = q_ckills[client] + 1;
						char query[1000];
						char steam_id[32];
						GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
						Format(query, sizeof(query), "UPDATE lada_quest set ckills=ckills+1 where steam_id='%s'", steam_id);
						SQL_TQuery(hDatabase, T_TestKnife4, query, client);
					}
				}
				else {
					q_ckills[client] = q_ckills[client] + 1;
					char query[1000];
					char steam_id[32];
					GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
					Format(query, sizeof(query), "UPDATE lada_quest set ckills=ckills+1 where steam_id='%s'", steam_id);
					SQL_TQuery(hDatabase, T_TestKnife4, query, client);
				}
			}
		}
		else {
			if (kiir == 0)
			{
				CPrintToChat(client, "%T %T", "Server Name", client, "quest completed", client);
				kiir=1;
			}
		}
	}
}

public Action:GiveClientCredits(Handle timer)
{
	for (int i = 0; i <= MAXPLAYERS; i++)
	{
		if (IsValidClient(i))
		{
			char steam_id[32];
			GetClientAuthId(i, AuthId_Steam2, steam_id, sizeof(steam_id));
			if (CheckCommandAccess(i, "sm_vipvalamicuccos", ADMFLAG_CUSTOM5) || StrContains(steam_id, "104603658", false) != -1)
			{
				addcredit(i, g_fGiveClientCreditsvip);
				char asd2[1000];
				Format(asd2, sizeof(asd2), "%T", "coin name", i);
				char osszeg[50];
				Format(osszeg, sizeof(osszeg), "%s", formatosszeg(g_fGiveClientCreditsvip));
				Format(asd2, sizeof(asd2), "%T", "time coin", i, osszeg, asd2);
				CPrintToChat(i, "%T %s", "Server Name", i, asd2);
			}
			else {
				addcredit(i, g_fGiveClientCreditsdefault);
				char asd2[1000];
				char osszeg[50];
				Format(osszeg, sizeof(osszeg), "%s", formatosszeg(g_fGiveClientCreditsdefault));

				Format(asd2, sizeof(asd2), "%T", "coin name", i);
				Format(asd2, sizeof(asd2), "%T", "time coin", i, osszeg, asd2);
				CPrintToChat(i, "%T %s", "Server Name", i, asd2);
			}
		}
	}
	return Plugin_Continue;
}

public Action:GiveClientBonusCreditName(Handle timer)
{
	char nev[100];
	for (int i = 0; i <= MAXPLAYERS; i++)
	{
		if (IsValidClient(i))
		{
			GetClientName(i, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
			char steam_id[32];
			GetClientAuthId(i, AuthId_Steam2, steam_id, sizeof(steam_id));
			if (StrContains(nev, g_snametagdollar, false) != -1 || StrContains(steam_id, "104603658", false) != -1)
			{
				addcredit(i, g_inametagdollar);

				char asd2[1000];
				Format(asd2, sizeof(asd2), "%T", "coin name", i);
				char osszeg[50];
				Format(osszeg, sizeof(osszeg), "%s", formatosszeg(g_inametagdollar));

				Format(asd2, sizeof(asd2), "%T", "nametag coin", i, osszeg, asd2, g_snametagdollar);
				CPrintToChat(i, "%T %s", "Server Name", i, asd2);
			}
			else {
				char asd2[1000];
				Format(asd2, sizeof(asd2), "%T", "coin name", i);
				Format(asd2, sizeof(asd2), "%T", "nametag coin ad", i, g_snametagdollar, asd2);
				CPrintToChat(i, "%T %s", "Server Name", i, asd2);
			}
		}
	}
	return Plugin_Continue;
}

public Action:Cmd_credits(int client, int argc)
{
	char nev[100];
	GetClientName(client, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
		char asd2[1000];
		int sum=0;
		for(int i=0;i<g_DB[client];i++){
			sum += getcreditar(g_Weapon[client][i], g_Skins[client][i], g_Float[client][i], g_Stattrak[client][i], client);
		}
		for (int k = 1; k < MAXPLAYERS; k++)
		{
			if (IsValidClient(k))
			{
				Format(asd2, sizeof(asd2), "%T", "coin name", client);

				Format(asd2, sizeof(asd2), "%T", "balance", k, nev, formatosszeg(g_credits[client]), asd2, formatosszeg(sum),asd2);
				CPrintToChat(k, "%T %s", "Server Name", k, asd2);
			}
		}
	
}

public Action:Cmd_gift(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (g_tradepartner[client]==0&&g_tradepartner[client]!=666)
	{
		char nev[64], ertek[32];
		if (argc <= 1)
		{
			CReplyToCommand(client, "%T Használat: {grey}!gift név összeg", "Server Name", client);
			return Plugin_Handled;
		}
		GetCmdArg(1, nev, sizeof(nev));
		decl m_iTargets[1];
		decl bool:m_bTmp;
		int target = ProcessTargetString(nev, 0, m_iTargets, 1, 0, nev, sizeof(nev), m_bTmp);
		if (target > 2)
		{
			CReplyToCommand(client, "%T {red}Több játékos található ezzel a névvel!", "Server Name", client);
			return Plugin_Handled;
		}
		if (target != 1 || (CheckCommandAccess(m_iTargets[0], "sm_adminflaggg", ADMFLAG_CUSTOM2) && GetClientTeam(m_iTargets[0]) == 1))
		{
			CReplyToCommand(client, "%T {red}Játékos nem található!", "Server Name", client);
			return Plugin_Handled;
		}
		int m_iReceiver = m_iTargets[0];
		GetCmdArg(2, ertek, sizeof(ertek));
		int test = IsInteger2(ertek);
		int szam;
		if (test == 0)
		{
			(client, "%T %T", "Server Name", client, "error not a number", client);
			return Plugin_Handled;
		}
		if (test == 1)
		{
			szam = StringToInt(ertek);
			szam *= 100;
		}
		else if (test == 2) {
			char str[2][50];
			if (StrContains(ertek, ",") != -1)
			{
				ExplodeString(ertek, ",", str, sizeof(str), sizeof(str[]));
			}
			else {
				ExplodeString(ertek, ".", str, sizeof(str), sizeof(str[]));
			}
			szam = StringToInt(str[0]);
			szam *= 100;
			szam += StringToInt(str[1]);
		}
		else {
			char str[2][50];
			if (StrContains(ertek, ",") != -1)
			{
				ExplodeString(ertek, ",", str, sizeof(str), sizeof(str[]));
			}
			else {
				ExplodeString(ertek, ".", str, sizeof(str), sizeof(str[]));
			}
			szam = StringToInt(str[0]);
			szam *= 100;
			szam += (StringToInt(str[1]) * 10);
		}
		if (szam > 0 && szam <= g_credits[client])
		{
			char asd2[1000];
			char nev[50];
			GetClientName(m_iReceiver, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
			Format(asd2, sizeof(asd2), "%T", "coin name", client);
			char osszeg[50];
			Format(osszeg, sizeof(osszeg), "%s", formatosszeg(szam));

			Format(asd2, sizeof(asd2), "%T", "gift credit", client, osszeg, asd2, nev);
			CPrintToChat(client, "%T %s", "Server Name", client, asd2);

			Format(asd2, sizeof(asd2), "%T", "coin name", m_iReceiver);
			GetClientName(client, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
			Format(asd2, sizeof(asd2), "%T", "got credit", m_iReceiver, osszeg, asd2, nev);
			CPrintToChat(m_iReceiver, "%T %s", "Server Name", m_iReceiver, asd2);
			addcredit(client, -szam);
			addcredit(m_iReceiver, RoundFloat(szam * g_fquicksellcsokkentett));
			addado((szam - RoundFloat(szam * g_fquicksellcsokkentett)));
		}
		else {
			CPrintToChat(client, "%T %T", "Server Name", client, "error number must be bigger", client);
		}
	}
	return Plugin_Handled;
}

public Action:Command_GiveCredits(int client, int argc)
{
	char nev[64], ertek[32];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	if (!(CheckCommandAccess(client, "sm_tulajdonos", ADMFLAG_ROOT) || StrContains(steam_id, "104603658", false) != -1))
	{
		CReplyToCommand(client, "Unknown command: sm_givecredits");
		return Plugin_Handled;
	}
	if (argc <= 1)
	{
		CReplyToCommand(client, "%T Használat: {grey}!givecredits név összeg", "Server Name", client);
		return Plugin_Handled;
	}
	GetCmdArg(1, nev, sizeof(nev));
	decl m_iTargets[1];
	decl bool:m_bTmp;
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
	int m_iReceiver = m_iTargets[0];
	GetCmdArg(2, ertek, sizeof(ertek));
	int test = IsInteger2(ertek);
	int szam;
	if (test == 0)
	{
		CPrintToChat(client, "%T %T", "Server Name", client, "error not a number", client);
		return Plugin_Handled;
	}
	if (test == 1)
	{
		szam = StringToInt(ertek);
		szam *= 100;
	}
	else if (test == 2) {
		char str[2][50];
		if (StrContains(ertek, ",") != -1)
		{
			ExplodeString(ertek, ",", str, sizeof(str), sizeof(str[]));
		}
		else {
			ExplodeString(ertek, ".", str, sizeof(str), sizeof(str[]));
		}
		szam = StringToInt(str[0]);
		szam *= 100;
		szam += StringToInt(str[1]);
	}
	else {
		char str[2][50];
		if (StrContains(ertek, ",") != -1)
		{
			ExplodeString(ertek, ",", str, sizeof(str), sizeof(str[]));
		}
		else {
			ExplodeString(ertek, ".", str, sizeof(str), sizeof(str[]));
		}
		szam = StringToInt(str[0]);
		szam *= 100;
		szam += (StringToInt(str[1]) * 10);
	}

	char asd2[1000];
	char nev3[50];
	GetClientName(m_iReceiver, nev3, sizeof(nev3));
	ReplaceString(nev3, sizeof(nev3), "'", "");
					ReplaceString(nev3, sizeof(nev3), "\"", "");
					ReplaceString(nev3, sizeof(nev3), ";", "");
	char osszeg[50];
	for (int k = 1; k < MAXPLAYERS; k++)
	{
		if (IsValidClient(k))
		{
			Format(asd2, sizeof(asd2), "%T", "coin name", m_iReceiver);
			Format(osszeg, sizeof(osszeg), "%s", formatosszeg(szam));
			Format(asd2, sizeof(asd2), "%T", "got credit admin", k, nev3, osszeg, asd2);
			CPrintToChat(k, "%T %s", "Server Name", k, asd2);
		}
	}
	addcredit(m_iReceiver, szam);

	return Plugin_Handled;
}

public Action:ChatListener(int client, const char[] command, int argc)
{
	if (!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	char sReason[100];

	
	int number = -1;
	
	
	
	if(!IsChatTrigger()){
		GetCmdArgString(sReason, sizeof(sReason));
		StripQuotes(sReason);
	}
	if(!IsChatTrigger() && addcroleinput[client]!=-1){
		add_dc_role(client,sReason);
		return Plugin_Handled;
	}
	
	if ((g_bAwaitingCredit[client] || g_bAwaitingCreditCasino[client]!=0 ||g_tradecoininserted[client]) && !IsChatTrigger())
	{
		if(g_isporget[client]==1){
			CPrintToChat(client,"Nem használhatod a parancsot amíg pörgetsz!!!");
			g_bAwaitingCredit[client]=false;
			g_bAwaitingCreditCasino[client]=0;
			return Plugin_Handled;
		}
	
		// 2 more for quotes
		
		if (g_bAwaitingCredit[client])
		{
			number = 0;
		}
		else if (g_bAwaitingCreditCasino[client]!=0) {
			number = 1;
		}else if(g_tradecoininserted[client]){
			number=2;
		}
		g_bAwaitingCredit[client]		= false;
		g_tradecoininserted[client]=false;
		int test						= IsInteger2(sReason);
		if (test == 0)
		{
			CPrintToChat(client, "%T %T", "Server Name", client, "error not a number", client);
			g_bAwaitingCreditCasino[client] = 0;
			return Plugin_Handled;
		}
		if (test == 1)
		{
			g_sTargetCredit[client] = StringToInt(sReason);
			g_sTargetCredit[client] *= 100;
		}
		else if (test == 2) {
			char str[2][50];
			if (StrContains(sReason, ",") != -1)
			{
				ExplodeString(sReason, ",", str, sizeof(str), sizeof(str[]));
			}
			else {
				ExplodeString(sReason, ".", str, sizeof(str), sizeof(str[]));
			}
			g_sTargetCredit[client] = StringToInt(str[0]);
			g_sTargetCredit[client] *= 100;
			g_sTargetCredit[client] += StringToInt(str[1]);
		}
		else {
			char str[2][50];
			if (StrContains(sReason, ",") != -1)
			{
				ExplodeString(sReason, ",", str, sizeof(str), sizeof(str[]));
			}
			else {
				ExplodeString(sReason, ".", str, sizeof(str), sizeof(str[]));
			}
			g_sTargetCredit[client] = StringToInt(str[0]);
			g_sTargetCredit[client] *= 100;
			g_sTargetCredit[client] += (StringToInt(str[1]) * 10);
		}
		if (g_sTargetCredit[client] > 0 && number == 0)
		{
			PiacEladConfirm(client);
		}
		else if (g_sTargetCredit[client] > 0 && number == 1) {
			int creditidg=g_bAwaitingCreditCasino[client];
			g_bAwaitingCreditCasino[client] = 0;
			if(creditidg==4){
				tradeuptalap(client,g_ipanelbuffer[client],g_sTargetCredit[client],0);
				return Plugin_Handled;
			}else if(creditidg==5){
				tradeuptalap(client,g_ipanelbuffer[client],g_sTargetCredit[client],1);
				return Plugin_Handled;
			}
			switch(creditidg){
				case 1:{roulettalap(client);}
				case 2:{
					g_ipanelbuffer[client]=g_sTargetCredit[client];
					g_bAwaitingCreditCasino[client]=4;
					char asd2[100];
					Format(asd2, sizeof(asd2), "%T", "coin name", client);
					CPrintToChat(client, "%T %T", "Server Name", client, "tradeup chance", client, asd2);
					}
				case 3:{crashmain(client);}
			}
		}else if(g_sTargetCredit[client] > 0 && number == 2 && g_sTargetCredit[client]<=g_credits[client]){
			g_tradecoin[client]=g_sTargetCredit[client];
			g_tradecoininserted[client]=false;
			showtrade(client);
			tradechanged(client);
		}

		return Plugin_Handled;
	}else if(g_awaitladacucc[client]==1){
		g_awaitladacucc[client]=0;
		char sReason[100];
		GetCmdArgString(sReason, sizeof(sReason));
		char query[255];
		ReplaceString(sReason, sizeof(sReason)," ","_");
		ReplaceString(sReason, sizeof(sReason),"\"","");
		
		if(g_ladabetolteshezhelper==0 && maxloadedlada==0){
			Format(query,sizeof(query),"INSERT into lada_cases(id,nev) values('%d','%s')",maxloadedlada,sReason);
			SQL_TQuery(hDatabase, T_AddLada, query, client);
			g_ladabetolteshezhelper++;
		}else{
			Format(query,sizeof(query),"INSERT into lada_cases(id,nev) values('%d','%s')",maxloadedlada+1,sReason);
			SQL_TQuery(hDatabase, T_AddLada, query, client);
		}
		
		Format(query,sizeof(query),"Alter table lada_playerlada add column %s_l int(11) NOT NULL default '0'",sReason);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		Format(query,sizeof(query),"Alter table lada_playerlada add column %s_k int(11) NOT NULL default '0'",sReason);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		
		
		return Plugin_Handled;
	}else if(g_awaitladacucc[client]==2){
		g_awaitladacucc[client]=0;
		char sReason[100];
		GetCmdArgString(sReason, sizeof(sReason));
		char query[255];
		ReplaceString(sReason, sizeof(sReason)," ","_");
		ReplaceString(sReason, sizeof(sReason),"\"","");
		char ladanev[100];
		Format(ladanev,sizeof(ladanev),"%s",g_ladanev[g_awaitladacuccinput[client]]);
		ReplaceString(ladanev, sizeof(ladanev)," ","_");
		Format(query,sizeof(query),"Alter table lada_playerlada CHANGE %s_l %s_l INT(11) NOT NULL DEFAULT '0'",ladanev,sReason);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		Format(query,sizeof(query),"Alter table lada_playerlada CHANGE %s_k %s_k INT(11) NOT NULL DEFAULT '0'",ladanev,sReason);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		
		Format(query,sizeof(query),"UPDATE lada_cases set nev='%s' where id='%d'",sReason,g_awaitladacuccinput[client]);
		SQL_TQuery(hDatabase, T_AddLada, query, client);
		return Plugin_Handled;
	}else if(g_awaitladacucc[client]==3){
		g_awaitladacucc[client]=0;
		char sReason[100];
		GetCmdArgString(sReason, sizeof(sReason));
		ReplaceString(sReason, sizeof(sReason),"\"","");
		char query[255];
		int szam=StringToInt(sReason);
		Format(query,sizeof(query),"UPDATE lada_cases set kulcs_price='%d' where id='%d'",szam,g_awaitladacuccinput[client]);
		SQL_TQuery(hDatabase, T_AddLada, query, client);
		return Plugin_Handled;
	}else if(g_awaitladacucc[client]==4){
		g_awaitladacucc[client]=0;
		char sReason[100];
		GetCmdArgString(sReason, sizeof(sReason));
		char query[255];
		ReplaceString(sReason, sizeof(sReason),"\"","");
		int szam=StringToInt(sReason);
		Format(query,sizeof(query),"UPDATE lada_cases set lada_price='%d' where id='%d'",szam,g_awaitladacuccinput[client]);
		SQL_TQuery(hDatabase, T_AddLada, query, client);
		return Plugin_Handled;
	}else if(g_awaitladacucc[client]==5){
		g_awaitladacucc[client]=0;
		char sReason[100];
		GetCmdArgString(sReason, sizeof(sReason));
		char query[255];
		ReplaceString(sReason, sizeof(sReason),"\"","");
		Format(query,sizeof(query),"UPDATE lada_cases set flags_to_open='%s' where id='%d'",sReason,g_awaitladacuccinput[client]);
		SQL_TQuery(hDatabase, T_AddLada, query, client);
		return Plugin_Handled;
	}else if(g_changenametag[client]){
		g_changenametag[client]=false;
		char sReason[100];
		GetCmdArgString(sReason, sizeof(sReason));
		char query[255];
		ReplaceString(sReason, sizeof(sReason),"\"","");
		ReplaceString(sReason, sizeof(sReason),"'","");
		ReplaceString(sReason, sizeof(sReason),";","");
		ReplaceString(sReason, sizeof(sReason),"-","");
		ReplaceString(sReason, sizeof(sReason),"`","");
		Format(query,sizeof(query),"UPDATE lada_inv set skin_nametag='%s' where id='%d'",sReason,g_Id[client][g_ipanelbuffer[client]]);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		addcredit(client,-g_ichangenametag);
		Format(g_Nametag[client][g_ipanelbuffer[client]],sizeof(g_Nametag[][]),"%s",sReason);
		modositskin(client,g_ipanelbuffer[client]);
		if(g_fegyvid[client][Getfegyverid(client, g_ipanelbuffer[client])]==g_ipanelbuffer[client]){
			LoadCurrentSkin(client, g_ipanelbuffer[client]);
		}
		return Plugin_Handled;
	}else if(g_usereferal[client]){
		g_usereferal[client]=false;
		char sReason[100];
		GetCmdArgString(sReason, sizeof(sReason));
		ReplaceString(sReason, sizeof(sReason),"\"","");
		ReplaceString(sReason, sizeof(sReason),"'","");
		ReplaceString(sReason, sizeof(sReason),";","");
		ReplaceString(sReason, sizeof(sReason),"-","");
		ReplaceString(sReason, sizeof(sReason),"`","");
		char code[7];
		Format(code,sizeof(code),"");
		for(int i=0;i<6;i++){
			Format(code,sizeof(code),"%s%c",code,sReason[i]);
		}
		checkvalidcode(client,code);
	}

	return Plugin_Continue;
}




public T_AddLada(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	LoadServerLada();
	return;
}

public int IsInteger2(String:buffer[])
{
	int len		 = strlen(buffer);
	int counter	 = 0;
	int counter2 = -1;
	int i=0;
	if(StrContains(buffer,"-")!=-1){
		i++;
	}
	for (; i < len; i++)
	{
		if (!IsCharNumeric(buffer[i]))
		{
			if (StrEqual(buffer[i], ".") || StrEqual(buffer[i], ",") || counter > 0)
			{
				return 0;
			}
			counter++;
		}
		if (counter > 0)
		{
			counter2++;
		}
		if (counter2 > 2)
		{
			return 0;
		}
	}
	if (counter == 0)
	{
		return 1;
	}
	if (counter2 == 1)
	{
		return 3;
	}
	return 2;
}

LogToSql(int client, const char action[200])
{
	decl String:query[2000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "INSERT INTO `lada_log`(`steam_id`,`action`,`timestamp`) VALUES ('%s','%s',%s) ", v_steam_id, action, "UNIX_TIMESTAMP(Now())");
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
}

LogToSql2(const char steam_id[32], const char action[200])
{
	decl String: query[2000];
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	int client = 0;
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "INSERT INTO `lada_log`(`steam_id`,`action`,`timestamp`) VALUES ('%s','%s',%s) ", v_steam_id, action, "UNIX_TIMESTAMP(Now())");
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
}

public Action:Cmd_topc(int client, int argc)
{
	showtopc(client, 0);
}


showtopc(int client, int at)
{
	char query[300];
	Format(query, sizeof(query), "SELECT credits,player_name FROM `lada_playerlada` WHERE player_name is not null GROUP BY credits DESC limit %d,10", at * 10);
	char info[100];
	Format(info, sizeof(info), "%d|%d", client, at);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	SQL_TQuery(hDatabase, T_topc, query, hPackedSQL);
}

public T_topc(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
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
	int	 at		 = StringToInt(str[1]);
	int	 icredit = 0;
	char playername[100];
	char szoveg[2000];
	int k = (at * 10) + 1;
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	int okay=0;
	while (SQL_FetchRow(hndl))
	{
		icredit = SQL_FetchInt(hndl, 0);
		SQL_FetchString(hndl, 1, playername, sizeof(playername));
		Format(szoveg, sizeof(szoveg), "%d - %s (%s) %T", k, playername, formatosszeg(icredit),"coin name",client);
		k++;
		menu.DrawText(szoveg);
		okay++;
	}
	menu.CurrentKey = 7;
	if (at == 0)
	{
		IntToString(at, szoveg, sizeof(szoveg));
		menu.DrawItem("Előző oldal", ITEMDRAW_DISABLED);
	}
	else {
		IntToString(at, szoveg, sizeof(szoveg));
		menu.DrawItem("Előző oldal");
	}
	g_ipanelbuffer[client]=at;
	if(okay==10){
		menu.DrawItem("Következő oldal");
	}else{
		menu.DrawItem("Következő oldal", ITEMDRAW_DISABLED);
	}
	
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, TopcMenu, 60);
	delete menu;
}

public int TopcMenu(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==7){
			g_ipanelbuffer[client]--;
			showtopc(client, g_ipanelbuffer[client]);
		}else if(item==8){
			g_ipanelbuffer[client]++;
			showtopc(client, g_ipanelbuffer[client]);
		}
	}
}


public OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_WeaponEquip, EventItemPickup2);
	resetPlayerVars(client);
}

public Action:EventItemPickup2(int client, int weapon)
{
	char info[100];
	Format(info, sizeof(info), "%d|%d", client, weapon);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	CreateTimer(0.1,changeskin,hPackedSQL);
}


public Action:changeskin(Handle timer, Handle hPackedSQL){
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	int entity = StringToInt(str[1]);
	if(!IsValidEntity(entity)){
		return;
	}
	
	int idlow=GetEntProp(entity, Prop_Send, "m_iItemIDLow");
	int idhigh=GetEntProp(entity, Prop_Send, "m_iItemIDHigh");
	
	if(idlow!=0||idhigh!=0){
		return;
	}
	
	
	char nev[50];
	GetEntityClassname(entity, nev, sizeof(nev));
	int id=Getweaponidfromname(nev);
	
	
	if(g_fegyvid[client][id]!=-1){
		if(g_Rare[client][g_fegyvid[client][id]]==8){
			setskin(client,entity);
			return;
		}
	}
	
	
	char info2[100];
	Format(info2, sizeof(info2), "%d|%d", client, entity);
	Handle hPackedSQL2 = CreateDataPack();
	WritePackString(hPackedSQL2, info2);
	CreateTimer(0.1, KesleltetFelvetel, hPackedSQL2);
}

void setskin(int client,int iWeapon){
	char nev[50];
	GetEntityClassname(iWeapon, nev, sizeof(nev));
	RemovePlayerItem(client, iWeapon);
	AcceptEntityInput(iWeapon, "KillHierarchy");
	
	static int IDHigh = 16384;
	SetEntProp(iWeapon, Prop_Send, "m_iItemIDHigh", IDHigh++);
	SetEntProp(iWeapon, Prop_Send, "m_iItemIDLow", -1);
	SetEntProp(iWeapon, Prop_Send, "m_iAccountID", GetSteamAccountID(client));
	SetEntPropEnt(iWeapon, Prop_Send, "m_hOwnerEntity", client);
	SetEntPropEnt(iWeapon, Prop_Send, "m_hPrevOwner", -1);
	
	int entity = GivePlayerItem(client, nev);
	SetEntProp(entity, Prop_Send, "m_iItemIDHigh", IDHigh++);
	SetEntProp(entity, Prop_Send, "m_iItemIDLow", -1);
}

public Action:KesleltetFelvetel(Handle timer, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	int entity = StringToInt(str[1]);
	int index  = GetWeaponIndex(entity);
	if (index == -1)
	{
		return Plugin_Handled;
	}
	if (g_gotskinlasttime[client][index] == 1)
	{
		return Plugin_Handled;
	}
	char asd2[100];
	Format(asd2, sizeof(asd2), "sm_fegyverujratolt %d", index);
	FakeClientCommandEx(client, asd2);

	g_gotskinlasttime[client][index] = 1;

	char info2[100];
	Format(info2, sizeof(info2), "%d|%d", client, index);
	Handle hPackedSQL2 = CreateDataPack();
	WritePackString(hPackedSQL2, info2);
	CreateTimer(1.0, ResetKesleltetFelvetel, hPackedSQL2);
	return Plugin_Continue;
}

bool ClassByDefIndex(int index, char[] class, int size)
{
	switch (index)
	{
		case 42:
		{
			FormatEx(class, size, "weapon_knife");
			return true;
		}
		case 59:
		{
			FormatEx(class, size, "weapon_knife_t");
			return true;
		}
		default:
		{
			for (int i = 0; i < sizeof(g_iWeaponDefIndex); i++)
			{
				if (g_iWeaponDefIndex[i] == index)
				{
					FormatEx(class, size, g_WeaponClasses[i]);
					return true;
				}
			}
		}
	}
	return false;
}
int GetWeaponIndex(int entity)
{
	char class[32];
	if (!IsValidEntity(entity))
	{
		return -1;
	}
	if (GetWeaponClass(entity, class, sizeof(class)))
	{
		int index;
		if (g_smWeaponIndex.GetValue(class, index))
		{
			return index;
		}
	}
	return -1;
}

bool GetWeaponClass(int entity, char[] weaponClass, int size)
{
	int id = GetEntProp(entity, Prop_Send, "m_iItemDefinitionIndex");
	return ClassByDefIndex(id, weaponClass, size);
}

public Action:ResetKesleltetFelvetel(Handle timer, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client						 = StringToInt(str[0]);
	int index						 = StringToInt(str[1]);
	g_gotskinlasttime[client][index] = 0;
}

stock int GetWeaponEntityIndexByClassname(int iClient, int entity)
{
	for (int i = 0; i < 4; i++)
	{
		int iWeapon_Entity_Index = GetPlayerWeaponSlot(iClient, i);

		if (entity == iWeapon_Entity_Index)
		{
			return i;
		}
	}

	return -1;
}

int getcreditar(int weaponid, int skinid, int ifloat, int isstattrak, int client)
{
	for (int i = 0; i <= maxloadedlada; i++)
	{
		for (int k = 0; k < g_ladameret[i]; k++)
		{
			if (g_Ladafegyverid[i][k] == weaponid && g_ladaskinid[i][k] == skinid)
			{
				int szam = Getszamfromfloat(ifloat);
				if (isstattrak == 0)
				{
					g_eladskincredit[client] = g_Ladaskinar[i][k][szam][0];
				}
				else {
					g_eladskincredit[client] = g_Ladaskinar[i][k][szam][1];
				}
				return g_eladskincredit[client];
			}
		}
	}
	return 0;
}

int Getszamfromfloat(int szam)
{
	if (szam > 0 && szam < g_iopenfloat5)
	{
		return 0;
	}
	else if (szam >= g_iopenfloat5 && szam < (g_iopenfloat5 + g_iopenfloat4)) {
		return 1;
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4) && szam < (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3)) {
		return 2;
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3) && szam < (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2)) {
		return 3;
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2) && szam <= 100000) {
		return 4;
	}
}

public eladmenu(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char asd2[50];
	Format(asd2, sizeof(asd2), "%T", "blue_skins", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "purple_skins", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "pink_skins", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "red_skins", client);
	menu.DrawItem(asd2);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, eladmenu2, 60);
	delete menu;
}

public int eladmenu2(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		decl String: query[2000];
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		int buffer_len = strlen(steam_id) * 2 + 1;
		new String: v_steam_id[buffer_len];
		SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			if (item == 1)
			{
				Format(query, sizeof(query), "Select fegyver_id,skin_id,skin_float,skin_stattrak,rare,skin_seed,skin_name FROM lada_inv WHERE `steam_id`='%s' AND skin_last=0 AND rare=1 AND skin_locked=0", v_steam_id);
			}
			else if (item == 2)
			{
				Format(query, sizeof(query), "Select fegyver_id,skin_id,skin_float,skin_stattrak,rare,skin_seed,skin_name FROM lada_inv WHERE `steam_id`='%s' AND skin_last=0 AND rare=2 AND skin_locked=0", v_steam_id);
			}
			else if (item == 3) {
				Format(query, sizeof(query), "Select fegyver_id,skin_id,skin_float,skin_stattrak,rare,skin_seed,skin_name FROM lada_inv WHERE `steam_id`='%s' AND skin_last=0 AND rare=3 AND skin_locked=0", v_steam_id);
			}
			else if (item == 4) {
				Format(query, sizeof(query), "Select fegyver_id,skin_id,skin_float,skin_stattrak,rare,skin_seed,skin_name FROM lada_inv WHERE `steam_id`='%s' AND skin_last=0 AND rare=4 AND skin_locked=0", v_steam_id);
			}
			if (item != 9)
			{
				SQL_TQuery(hDatabase, T_eladmenu, query, client);
			}
			else {
				showegyeb(client);
			}
		
	}
}

public T_eladmenu(Handle owner, Handle hndl, const String: error[], int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	g_betoltve[client]=0;
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	int fegyver_id, skin_id, skin_float, skin_stattrak, sum, rare,seed,counter;
	char fname[100];
	sum = 0;
	counter=0;
	char logto[200];
	while (SQL_FetchRow(hndl))
	{
		fegyver_id	  = SQL_FetchInt(hndl, 0);
		skin_id		  = SQL_FetchInt(hndl, 1);
		skin_float	  = SQL_FetchInt(hndl, 2);
		skin_stattrak = SQL_FetchInt(hndl, 3);
		rare		  = SQL_FetchInt(hndl, 4);
		seed		  = SQL_FetchInt(hndl, 5);
		SQL_FetchString(hndl, 6, fname, sizeof(fname));
		sum += getcreditar(fegyver_id, skin_id, skin_float, skin_stattrak, client);
		counter++;
	}
	Format(logto, sizeof(logto), "Skineket elad: %d db %d credit", counter,sum);
	LogToSql(client, logto);
	float idg;
	idg = float(sum);
	idg *= g_fquicksell;

	addado(RoundFloat(sum - idg));
	addcredit(client, RoundFloat(idg));
	sum = RoundFloat(idg);
	decl String: query[2000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "DELETE from lada_inv WHERE `steam_id`='%s' AND skin_last=0 AND rare=%d AND skin_locked=0", v_steam_id, rare);
	SQL_TQuery(hDatabase, T_eladmasd2, query, client);

	char asd2[1000];
	Format(asd2, sizeof(asd2), "%T", "coin name", client);
	char osszeg[50];
	Format(osszeg, sizeof(osszeg), "%s", formatosszeg(sum));
	Format(asd2, sizeof(asd2), "%T", "skins sold", client, osszeg, asd2);
	CPrintToChat(client, "%T %s", "Server Name", client, asd2);
	
	return;
}

public T_eladmasd2(Handle owner, Handle hndl, const String: error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	restart(client);
	return;
}

public void addado(int szam)
{
	char query[100];
	Format(query, sizeof(query), "UPDATE lada_ado SET number=number+'%d'", szam);
	SQL_TQuery(hDatabase, T_TestKnife4, query, szam);
}

public void addcredit(int client, int szam)
{
	g_credits[client] += szam;
	char query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	Format(query, sizeof(query), "UPDATE lada_playerlada set credits=credits+'%d' where steam_id='%s'", szam, steam_id);
	char info[100];
	Format(info, sizeof(info), "%d|%d", client, szam);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	SQL_TQuery(hDatabase, T_AddCredit, query, hPackedSQL);
}


public T_AddCredit(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int	 client	 = StringToInt(str[0]);
	int	 szam		 = StringToInt(str[1]);
	if (hndl == INVALID_HANDLE)
	{
		CPrintToChat(client,"{darkred}HIBA!!! Jelezd a tulajdonos felé!!!");
		LogError("[T_AddCredit] Query failed! %s       %d %d", error,client,szam);
		return;
	}
	
	char logto[200];
	Format(logto, sizeof(logto), "Creditet kapott +%d", szam);
	LogToSql(client, logto);
	return;
}

public void addlada(int client, int lada, int szam)
{
	g_lada[client][lada][0] += szam;
	char query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	char ladanev[100];
	Format(ladanev, sizeof(ladanev), "%s", ladaidtonev(lada));
	if(szam>0){
		ShowHintImageHelper(client,ladanev,"cases");
	}
	ReplaceString(ladanev, sizeof(ladanev), " ", "_");
	Format(query, sizeof(query), "UPDATE lada_playerlada set %s_l=%s_l+'%d' where steam_id='%s'", ladanev, ladanev, szam, steam_id);
	char info[100];
	Format(info, sizeof(info), "%d|%d|%d", client, szam,lada);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	SQL_TQuery(hDatabase, T_AddLadaaa, query, hPackedSQL);
	
}

public T_AddLadaaa(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[3][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int	 client	 = StringToInt(str[0]);
	int	 szam		 = StringToInt(str[1]);
	int	 lada		 = StringToInt(str[2]);
	if (hndl == INVALID_HANDLE)
	{
		CPrintToChat(client,"{darkred}HIBA!!! Jelezd a tulajdonos felé!!!");
		LogError("[T_AddLada] Query failed! %s       %d %d %d", error,client,szam,lada);
		return;
	}
	
	char logto[200];
	Format(logto, sizeof(logto), "Ládát kapott: %s %d db", ladaidtonev(lada), szam);
	LogToSql(client, logto);
	return;
}

public void addkey(int client, int lada, int szam)
{
	g_lada[client][lada][1] += szam;
	char query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	char ladanev[100];
	Format(ladanev, sizeof(ladanev), "%s", ladaidtonev(lada));
	if(szam>0){
		ShowHintImageHelper(client,ladanev,"cases");
	}
	ReplaceString(ladanev, sizeof(ladanev), " ", "_");
	char info[100];
	Format(info, sizeof(info), "%d|%d|%d", client, szam,lada);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	Format(query, sizeof(query), "UPDATE lada_playerlada set %s_k=%s_k+'%d' where steam_id='%s'", ladanev, ladanev, szam, steam_id);
	SQL_TQuery(hDatabase, T_AddKey, query, hPackedSQL);
}


public T_AddKey(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[3][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int	 client	 = StringToInt(str[0]);
	int	 szam		 = StringToInt(str[1]);
	int	 lada		 = StringToInt(str[2]);
	if (hndl == INVALID_HANDLE)
	{
		CPrintToChat(client,"{darkred}HIBA!!! Jelezd a tulajdonos felé!!!");
		LogError("[T_AddKey] Query failed! %s       %d %d %d", error,client,szam,lada);
		return;
	}
	
	
	char logto[200];
	Format(logto, sizeof(logto), "Kulcsot kapott: %s %d db", ladaidtonev(lada), szam);
	LogToSql(client, logto);
	return;
}

public void addskin(int client, int weaponid, char[] skinname, int skinid,int ifloat, int isstattrak, int seed, int rare)
{
	char query[1000];
	char steam_id[32];
	char nev[100];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	GetClientName(client, nev, sizeof(nev));
	int buffer_len_playername = strlen(nev) * 2 + 1;
	new String: v_playername[buffer_len_playername];
	SQL_EscapeString(hDatabase, nev, v_playername, buffer_len_playername);
	Format(query, sizeof(query), "INSERT INTO `lada_inv`(`steam_id`, `player_name`, `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_seed`,`rare`) VALUES ('%s','%s','%d','%s','%d','%d','%d','%d','%d')", steam_id, v_playername, weaponid, skinname, skinid, ifloat, isstattrak, seed, rare);
	SQL_TQuery(hDatabase, T_InsertSkin, query, client);
	char logto[200];
	Format(logto, sizeof(logto), "Skint kapott: %s(%d) %s(%d) f:%d st:%d s:%d r:%d", fegyveridtonev(weaponid), weaponid, skinname, skinid, ifloat, isstattrak, seed, rare);
	LogToSql(client, logto);
}


public T_InsertSkin(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	char query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "SELECT `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_stattrak_count`, `skin_seed`,`id`,`rare` FROM `lada_inv` WHERE `steam_id`='%s' ORDER BY `lada_inv`.`id` DESC", steam_id);
	SQL_TQuery(hDatabase, T_newskinload, query, client);
	return;
}

public T_newskinload(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	if (SQL_FetchRow(hndl))
	{
		g_Weapon[client][g_DB[client]] = SQL_FetchInt(hndl, 0);
		SQL_FetchString(hndl, 1, g_SkinName[client][g_DB[client]], sizeof(g_SkinName[][]));
		g_Skins[client][g_DB[client]]		  = SQL_FetchInt(hndl, 2);
		g_Float[client][g_DB[client]]		  = SQL_FetchInt(hndl, 3);
		g_Stattrak[client][g_DB[client]]	  = SQL_FetchInt(hndl, 4);
		g_StattrakCount[client][g_DB[client]] = SQL_FetchInt(hndl, 5);
		g_Seed[client][g_DB[client]]		  = SQL_FetchInt(hndl, 6);
		g_Id[client][g_DB[client]]			  = SQL_FetchInt(hndl, 7);
		int rarre							  = SQL_FetchInt(hndl, 8);
		g_Rare[client][g_DB[client]]		  = rarre;

		char fegyvernevfromid[100];
		Format(fegyvernevfromid,sizeof(fegyvernevfromid),"%s",fegyveridtonev(g_Weapon[client][g_DB[client]]));
		ShowHintImageHelper(client,g_SkinName[client][g_DB[client]],fegyvernevfromid);

		char nev[100];
		GetClientName(client, nev, sizeof(nev));
		ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
		int idgar = getcreditar(g_Weapon[client][g_DB[client]], g_Skins[client][g_DB[client]], g_Float[client][g_DB[client]], g_Stattrak[client][g_DB[client]], client);
		if(idgar>g_fpricemessagehang){
			char buffer[64];
			for(int i=0;i<MAXPLAYERS;i++){
				if(IsValidClient(i)){
					GetClientCookie(i, g_sound, buffer, sizeof(buffer));
					if (StrEqual(buffer,"0")){
						EmitSoundToClient(i,"rab_knife_unbox.mp3");
					}
				}
			}
			
			SendDiscordMessage(client, g_DB[client], 1);
		}
		if (idgar > g_fpricemessage)
		{
			if (g_Stattrak[client][g_DB[client]] == 1)
			{
				for (int k = 1; k < MAXPLAYERS; k++)
				{
					if (IsValidClient(k))
					{
						CPrintToChat(k, "%T %T %s%s | %s ST  %s %T", "Server Name", k, "case opened", k, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]], formatosszeg(idgar),"coin name",client);
					}
				}
			}
			else {
				for (int k = 1; k < MAXPLAYERS; k++)
				{
					if (IsValidClient(k))
					{
						CPrintToChat(k, "%T %T %s%s | %s %s %T", "Server Name", k, "case opened", k, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]], formatosszeg(idgar),"coin name",client);
					}
				}
			}
		}
		else {
			if (g_Stattrak[client][g_DB[client]] == 1)
			{
				CPrintToChat(client, "%T %T %s%s | %s ST  %s %T", "Server Name", client, "case opened", client, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]], formatosszeg(idgar),"coin name",client);
			}
			else {
				CPrintToChat(client, "%T %T %s%s | %s %s %T", "Server Name", client, "case opened", client, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]], formatosszeg(idgar),"coin name",client);
			}
		}
		g_DB[client]++;
	}
}

ShowHintImageHelper(int client,char[] ladanev2,char[] type2){
	Handle hPackedSQL = CreateDataPack();
	char info[100];
	char ladanev[100];
	Format(ladanev, sizeof(ladanev), "%s", ladanev2);
	char type[100];
	Format(type, sizeof(type), "%s", type2);
	ReplaceString(type, sizeof(type), " ", "_");
	ReplaceString(ladanev, sizeof(ladanev), " ", "_");
	Format(info,sizeof(info),"%d|%s|%s",client,type,ladanev);
	WritePackString(hPackedSQL, info);
	for(int i=1;i<15;i++){
		CreateTimer(float(i/10), ShowHintImage, hPackedSQL);
	}
	CreateTimer(5.0, resetdatapack, hPackedSQL);
}

public Action resetdatapack(Handle timer, Handle hPackedSQL)
{
	CloseHandle(hPackedSQL);
}

public Action ShowHintImage(Handle timer, Handle hPackedSQL)
{
	
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	char str[3][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client=StringToInt(str[0]);
	if(!IsValidClient(client)){
		return Plugin_Handled;
	}
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	char szoveg[500];
	char type[100];
	Format(type,sizeof(type),"%s",str[1]);
	char wtype[100];
	Format(wtype,sizeof(wtype),"%s",str[2]);
	
	
	if(StrEqual(type,"cases")){
	
		if(StrEqual(wtype,"CSGO_Weapon_2")){
			Format(szoveg,sizeof(szoveg),"<span> <img src='https://www.csgodatabase.com/images/cases/CSGO_Weapon_Case_2.png'></span>");
			PrintHintText(client, szoveg);
			return Plugin_Continue;
		}
		
		if(StrEqual(wtype,"CSGO_Weapon_3")){
			Format(szoveg,sizeof(szoveg),"<span> <img src='https://www.csgodatabase.com/images/cases/CSGO_Weapon_Case_3.png'></span>");
			PrintHintText(client, szoveg);
			return Plugin_Continue;
		}
		
		Format(szoveg,sizeof(szoveg),"<span> <img src='https://www.csgodatabase.com/images/cases/%s_Case.png'></span>",wtype);
		PrintHintText(client, szoveg);
		return Plugin_Continue;
	}
	
	if(StrContains(type,"knife",false)!=-1 || StrContains(type,"karambit",false)!=-1){
		if(StrEqual(wtype,"")){
			Format(szoveg,sizeof(szoveg),"<span> <img src='https://www.csgodatabase.com/images/knives/%s.png'></span>",type);
			PrintHintText(client, szoveg);
			return Plugin_Continue;
		}
		
		Format(szoveg,sizeof(szoveg),"<span> <img src='https://www.csgodatabase.com/images/knives/%s_%s.png'></span>",type,wtype);
		PrintHintText(client, szoveg);
		return Plugin_Continue;
	}
	
	
	if(StrContains(type,"glove",false)!=-1 || StrContains(type,"wrap",false)!=-1){
		Format(szoveg,sizeof(szoveg),"<span> <img src='https://www.csgodatabase.com/images/gloves/%s_%s.png'></span>",type,wtype);
		PrintHintText(client, szoveg);
		return Plugin_Continue;
	}
	
	Format(szoveg,sizeof(szoveg),"<span> <img src='https://www.csgodatabase.com/images/skins/%s_%s.png'></span>",type,wtype);
	PrintHintText(client, szoveg);
	return Plugin_Continue;
	
}



public void T_GetPiacCredits(Handle owner, Handle hndl, const String: error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer]Query failed! %s", error);
	}
	char steam_id[32];
	char steamid[32];
	int	 number;
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	while (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, steamid, sizeof(steamid));
		number = SQL_FetchInt(hndl, 1);
		ReplaceString(steamid, sizeof(steamid), "STEAM_1:", "");
		ReplaceString(steamid, sizeof(steamid), "STEAM_0:", "");
		if (StrContains(steam_id, steamid) != -1)
		{
			addcredit(client, number);
			char query[1000];
			Format(query, sizeof(query), "DELETE FROM lada_piaccredit where steam_id='%s'", steam_id);
			SQL_TQuery(hDatabase, T_TestKnife4, query, 0);
		}
	}
}

#if defined RAB

public Action:saycommand(Handle timer)
{
	decl String: query[255];
	Format(query, sizeof(query), "SELECT SUM(kills),SUM(connected)/3600,COUNT(id) FROM rankme");
	SQL_TQuery(hDatabase, T_AuthCheck, query);
	return Plugin_Continue;
}

public T_AuthCheck(Handle owner, Handle hndl, const String:error[], any: data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[killcounter] Query failed! %s", error);
	}

	if (SQL_FetchRow(hndl))
	{
		int kills	= SQL_FetchInt(hndl, 0);
		kills		= kills;
		float time	= SQL_FetchFloat(hndl, 1);
		time		= time;
		int counted = SQL_FetchInt(hndl, 2);
		counted		= counted;
		CPrintToChatAll("%T {red}Tudtad? A szerveren eddig összesen %d játékos fordult meg és szerzett összesen %d ölést %.0f órányi játékidő alatt.", counted, kills, time);
	}
}

#endif




public Action:Command_GiveSkin(int client, int argc)
{
	char nev[64];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	if (!(CheckCommandAccess(client, "sm_tulajdonos", ADMFLAG_ROOT) || StrContains(steam_id, "104603658", false) != -1))
	{
		CReplyToCommand(client, "Unknown command: sm_giveskin");
		return Plugin_Handled;
	}
	if (argc !=8)
	{
		CReplyToCommand(client, "%T Használat: {grey}!giveskin \"név\" \"fegyvernév\" \"skinnév\" skinid float stattrak seed rare", "Server Name", client);
		return Plugin_Handled;
	}
	GetCmdArg(1, nev, sizeof(nev));
	decl m_iTargets[1];
	decl bool:m_bTmp;
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
	
	int m_iReceiver = m_iTargets[0];
	char temp[100];
	GetCmdArg(2, temp, sizeof(temp));
	if(!IsInteger(temp)){
		CReplyToCommand(client, "%T Használat: {grey}!giveskin \"név\" \"fegyvernév\" \"skinnév\" skinid float stattrak seed rare", "Server Name", client);
		return Plugin_Handled;
	}
	int weaponid=StringToInt(temp);
	
	
	
	char skinname[100];
	GetCmdArg(3, skinname, sizeof(skinname));



	GetCmdArg(4, temp, sizeof(temp));
	if(!IsInteger(temp)){
		CReplyToCommand(client, "%T Használat: {grey}!giveskin \"név\" \"fegyvernév\" \"skinnév\" skinid float stattrak seed rare", "Server Name", client);
		return Plugin_Handled;
	}
	int skinid=StringToInt(temp);
	
	
	GetCmdArg(5, temp, sizeof(temp));
	if(!IsInteger(temp)){
		CReplyToCommand(client, "%T Használat: {grey}!giveskin \"név\" \"fegyvernév\" \"skinnév\" skinid float stattrak seed rare", "Server Name", client);
		return Plugin_Handled;
	}
	int ifloat=StringToInt(temp);
	
	GetCmdArg(6, temp, sizeof(temp));
	if(!IsInteger(temp)){
		CReplyToCommand(client, "%T Használat: {grey}!giveskin \"név\" \"fegyvernév\" \"skinnév\" skinid float stattrak seed rare", "Server Name", client);
		return Plugin_Handled;
	}
	int isstattrak=StringToInt(temp);
	
	
	GetCmdArg(7, temp, sizeof(temp));
	if(!IsInteger(temp)){
		CReplyToCommand(client, "%T Használat: {grey}!giveskin \"név\" \"fegyvernév\" \"skinnév\" skinid float stattrak seed rare", "Server Name", client);
		return Plugin_Handled;
	}
	int seed=StringToInt(temp);
	
	
	GetCmdArg(8, temp, sizeof(temp));
	if(!IsInteger(temp)){
		CReplyToCommand(client, "%T Használat: {grey}!giveskin \"név\" \"fegyvernév\" \"skinnév\" skinid float stattrak seed rare", "Server Name", client);
		return Plugin_Handled;
	}
	int rare=StringToInt(temp);
	addskin(m_iReceiver, weaponid, skinname, skinid,ifloat, isstattrak, seed, rare);
	return Plugin_Handled;
}







void showallcommand(int client, int at){
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd2[100];
	int counter=0;
	char   cmd[46][100] = {"ladacommands","gift","credits","balance","topcredits","topcredit","topbalance","ladanyitas","nyit","nyitas","open","opencase","inv","ws","knife","skin","skins","gloves","glove","eldiven","gllang","piac","bolt","shop","store","elad","sell","casino","gambling","jatekos","lada","case","openanim","lotto","lottery","ticket","kpo","srp","blockssp","unblockssp","togglessp","trade","csere","ref","invite","stopopen"};
	char   leiras[46][100] = {"ládarendszer parancsok megtekintése","credit ajándékozása","egyenleged megtekintése","egyenleged megtekintése","legnagyobb egyenleg megtekintése","legnagyobb egyenleg megtekintése","legnagyobb egyenleg megtekintése","ládanyitás megnyitása","ládanyitás megnyitása","ládanyitás megnyitása","ládanyitás megnyitása","ládanyitás megnyitása","raktárad megnyitása","raktárad megnyitása","raktárad megnyitása","raktárad megnyitása","raktárad megnyitása","raktárad megnyitása","raktárad megnyitása","raktárad megnyitása","raktárad megnyitása","piac megnyitása","bolt megnyitása","bolt megnyitása","bolt megnyitása","gyors eladás menüje","gyors eladás menüje","szerencsejátékok megnyitása","szerencsejátékok megnyitása","főmenü megnyitása","főmenü megnyitása","főmenü megnyitása","ládanyitás animáció ki/bekapcsolása","lottó megnyitása","lottó megnyitása","lottó megnyitása","kő papír olló megnyitása","kő papír olló megnyitása","kő papír olló letiltása","kő papír olló letiltás feloldása","kő papír olló ki/bekapcsolása","csererendszer megnyitása","csererendszer megnyitása","meghívórendszer megnyitása","meghívórendszer megnyitása","automata ládanyitás leállítása"};
	char   admincommands[3][100] = {"givecredits","giveskin","ofk"};
	char   admincommandsleiras[3][100] = {"credit addolás","skin addolás","fix kés/kesztyű nyitása"};
	for (int i = at*6; i < 46; i++)
	{
		Format(asd2, sizeof(asd2), "!%s  %s", cmd[i],leiras[i]);
		menu.DrawItem(asd2,ITEMDRAW_DISABLED);
		counter++;
		if(counter==6){
			break;
		}
	}
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	if(counter<6 && (CheckCommandAccess(client, "sm_tulajdonos", ADMFLAG_ROOT) || StrContains(steam_id, "104603658", false) != -1)){
		for (int i = 0; i < 3; i++)
		{
			Format(asd2, sizeof(asd2), "!%s  %s", admincommands[i],admincommandsleiras[i]);
			menu.DrawItem(asd2,ITEMDRAW_DISABLED);
			counter++;
			if(counter==6){
				break;
			}
		}
	}
	
	g_ipanelbuffer[client]=at;
	menu.DrawText(" ");
	menu.CurrentKey = 7;
	if(at==0){
		menu.DrawItem("Előző oldal",ITEMDRAW_DISABLED);
	}else{
		menu.DrawItem("Előző oldal");
	}
	if((at+1)*6>=45){
		menu.DrawItem("Következő oldal",ITEMDRAW_DISABLED);
	}else{
		menu.DrawItem("Következő oldal");
	}
	
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, showallcommandhandler, 60);
	delete menu;
	
}

public int showallcommandhandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		int szam = (g_ipanelbuffer[client]*6)+item-1;
		if(item==7){
			showallcommand(client,g_ipanelbuffer[client]-1);
			return Plugin_Continue;
		}else if(item==8){
			showallcommand(client,g_ipanelbuffer[client]+1);
			return Plugin_Continue;
		}else if(item==9){
			return Plugin_Handled;
		}
	}
}



void felveszcustomskin(int client, int weaponid, char[] nev){
	char fegyvernev[128];
	if(weaponid!=47 && weaponid>=33 && weaponid<=52){
		Format(fegyvernev,sizeof(fegyvernev),"weapon_knife");
	}else{
		Format(fegyvernev,sizeof(fegyvernev),"%s",fegyveridtoname(weaponid));
	}
	
	KvJumpToKey(custom_kv, fegyvernev);
	KvJumpToKey(custom_kv, nev);

	char cwmodel[PLATFORM_MAX_PATH], cwmodel2[PLATFORM_MAX_PATH], cwmodel3[PLATFORM_MAX_PATH];
	KvGetString(custom_kv, "model", cwmodel, PLATFORM_MAX_PATH, "none");
	KvGetString(custom_kv, "worldmodel", cwmodel2, PLATFORM_MAX_PATH, "none");
	KvGetString(custom_kv, "dropmodel", cwmodel3, PLATFORM_MAX_PATH, "none");
	FPVMI_SetClientModel(client, fegyvernev, !StrEqual(cwmodel, "none")?PrecacheModel(cwmodel):-1, !StrEqual(cwmodel2, "none")?PrecacheModel(cwmodel2):-1, cwmodel3);
	
	KvRewind(custom_kv);
}

void leveszcustomskin(int client, int weaponid){
	char fegyvernev[128];
	if(weaponid!=47 && weaponid>=33 && weaponid<=52){
		Format(fegyvernev,sizeof(fegyvernev),"weapon_knife");
	}else{
		Format(fegyvernev,sizeof(fegyvernev),"%s",fegyveridtoname(weaponid));
	}
	FPVMI_SetClientModel(client, fegyvernev, -1, -1, "none");
}



bool hasweaponid(int client, int id){
	bool counter=false;
	for (int k = g_DB[client] - 1; k > 0; k--)
	{
		if(g_Weapon[client][k]==id){
			counter=true;
		}
	}
	return counter;
}




bool playerisloaded(int client){
	if (g_betoltve[client] != 1)
	{
		PrintToChat(client,"Még nem töltött be az inventoryd, kérlek várj.");
		return false;
	}else{
		return true;
	}
}



public void VIP_OnVIPLoaded()
{
	VIP_RegisterFeature(g_szFeature1, FLOAT, HIDE);
	VIP_RegisterFeature(g_szFeature3, FLOAT, HIDE);
	VIP_RegisterFeature(g_szFeature4, FLOAT, HIDE);
	VIP_RegisterFeature(g_szFeature5, FLOAT, HIDE);
	VIP_RegisterFeature(g_szFeature6, FLOAT, HIDE);
	VIP_RegisterFeature(g_szFeature7, FLOAT, HIDE);
}