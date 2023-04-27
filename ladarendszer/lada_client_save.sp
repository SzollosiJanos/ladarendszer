

public void OnClientDisconnect(int client)
{
	g_betoltve[client]		 = 0;
	addcroleinput[client]=-1;
	if (IsValidClient(client) && g_connected[client] == 1)
	{
		char logto[200];
		Format(logto, sizeof(logto), "Disconnected: %d", g_credits[client]);
		LogToSql(client, logto);
		g_credits[client] = 0;
	}
	resetPlayerVars(client);
	int target = GetClientOfUserId(g_iOponent[client]);
	if (isValidClient(target) && (g_bInGame[client] || g_bInAccept[client]))
	{
		CPrintToChat(target, "%t", "opponentDisconnect", ttag);
		g_bInGame[target]	  = false;
		g_eSSPItem[target]	  = None;
		g_iOponent[target]	  = -1;
		g_iGameAmount[target] = -1;
		g_bInAccept[target]	  = false;
	}
	g_bInGame[client]				 = false;
	g_eSSPItem[client]				 = None;
	g_iOponent[client]				 = -1;
	g_iGameAmount[client]			 = -1;
	g_bInAccept[client]				 = false;
	g_bIgnoringInvites[client]		 = false;
	g_iIgnoringInvitesBellow[client] = 0;
	g_eladskincredit[client]		 = 0;
	g_multiplecaseopen[client]=-1;
	g_multiopencasemenu[client]=0;
}

public T_TestKnife4(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	return;
}