public Action:Cmd_ref(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		char query[1000];
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		Format(query,sizeof(query),"SELECT code,status,invitedby,invitedcounter from lada_referal where steam_id='%s'",steam_id);
		SQL_TQuery(hDatabase, T_CheckReferal, query, client);
	
}



public T_CheckReferal(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	
	if(SQL_FetchRow(hndl)){
		char code[7];
		char name[32];
		SQL_FetchString(hndl, 0, code, sizeof(code));
		int status=SQL_FetchInt(hndl, 1);
		SQL_FetchString(hndl, 2, name, sizeof(name));
		int counter=SQL_FetchInt(hndl, 3);
		showreferalmenu(client,status,code,name,counter);
	}else{
		checkcode(client);
	}
	return;
}


void checkcode(int client){
	char code[7];
	Format(code,sizeof(code),"");
	int randomnumber;
	for(int i=0;i<6;i++){
		randomnumber=GetRandomInt(0, 62);
		Format(code,sizeof(code),"%s%c",code,referalcharacters[randomnumber]);
	}
	
	char query[1000];
	Format(query,sizeof(query),"Select * from lada_referal where code like '%s'",code);
	char info[100];
	Format(info, sizeof(info), "%d|%s", client, code);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	SQL_TQuery(hDatabase, T_CheckCode, query, hPackedSQL);
}

public T_CheckCode(Handle owner, Handle hndl, const String:error[],Handle hPackedSQL)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	
	if (SQL_FetchRow(hndl)){
		ResetPack(hPackedSQL);
		new String: info[100];
		ReadPackString(hPackedSQL, info, sizeof(info));
		char str[2][50];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		int	 client	 = StringToInt(str[0]);
	
		checkcode(client);
	}else{
		char steam_id[32];
		ResetPack(hPackedSQL);
		new String: info[100];
		ReadPackString(hPackedSQL, info, sizeof(info));
		char str[2][50];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		int	 client	 = StringToInt(str[0]);
		char query[1000];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		
		char code[7];
		Format(code,sizeof(code),"%s",str[1]);
		char  nev[50];
		GetClientName(client, nev, sizeof(nev));
		ReplaceString(nev, sizeof(nev), "'", "");
		ReplaceString(nev, sizeof(nev), "\"", "");
		ReplaceString(nev, sizeof(nev), ";", "");
		Format(query,sizeof(query),"INSERT INTO lada_referal(steam_id,code,status,invitedcounter,playername) values('%s','%s',0,0,'%s')",steam_id,code,nev);
		SQL_TQuery(hDatabase, T_CheckReferal, query, client);
		CreateTimer(2.0,showreferal,client);
	}
	CloseHandle(hPackedSQL);
	return;
}


public Action:showreferal(Handle timer, int client)
{
	Cmd_ref(client,0);
}


void showreferalmenu(int client, int status, char code[7],char name[32],int counter){

	char query[1000];
	Format(query,sizeof(query),"SELECT playername from lada_referal where steam_id='%s'",name);
	char info[200];
	Format(info, sizeof(info), "%d|%d|%s|%d", client, status,code,counter);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	SQL_TQuery(hDatabase, T_CheckReferalName, query, hPackedSQL);
}


public T_CheckReferalName(Handle owner, Handle hndl, const String:error[],Handle hPackedSQL)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	char name[50];
	if (SQL_FetchRow(hndl)){
		
		SQL_FetchString(hndl,0,name,sizeof(name));
	}
	
	
	ResetPack(hPackedSQL);
		new String: info[100];
		ReadPackString(hPackedSQL, info, sizeof(info));
		CloseHandle(hPackedSQL);
		char str[4][50];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		int	 client	 = StringToInt(str[0]);
		int	 status		 = StringToInt(str[1]);
		int	 counter		 = StringToInt(str[3]);
		
		
		Panel menu = new Panel();

		menu.SetTitle(" » MegoltElek ládarendszer « ");
		menu.DrawText(" ");
		char asd2[100];

		Format(asd2,sizeof(asd2),"%T %s","referal code",client,str[2]);
		menu.DrawText(asd2);
		menu.DrawText(" ");
		if(status==0){
			Format(asd2,sizeof(asd2),"%T","referal invite",client);
			menu.DrawItem(asd2);
		}else{
			Format(asd2,sizeof(asd2),"%T","referal already invited",client);
			menu.DrawItem(asd2,ITEMDRAW_DISABLED);
			Format(asd2,sizeof(asd2),"%T %s","referal invited by",client,name);
			menu.DrawText(asd2);
		}
		
		
		Format(asd2,sizeof(asd2),"%T","referal use code",client);
		menu.DrawText(" ");
		menu.DrawText(asd2);
		menu.DrawText(" ");
		Format(asd2,sizeof(asd2),"%T %d","referal invited counter",client,counter);
		menu.DrawText(asd2);
		menu.DrawText(" ");
		menu.CurrentKey = 9;
		char exit2[50];
		Format(exit2, sizeof(exit2), "%T", "exit", client);
		menu.DrawItem(exit2);
		menu.Send(client, showreferalmenuhandler, 60);
		delete menu;
	return;
}


public int showreferalmenuhandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==1){
			CPrintToChat(client,"%T %T","Server Name",client,"referal chat message",client);
			g_usereferal[client]=true;
		}
	}
}

void checkvalidcode(int client,char code[7]){
	char query[1000];
	Format(query,sizeof(query),"SELECT steam_id from lada_referal where code='%s'",code);
	SQL_TQuery(hDatabase, T_CheckValidCode, query, client);
}



public T_CheckValidCode(Handle owner, Handle hndl, const String:error[],int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	
	if (SQL_FetchRow(hndl)){
		char steam_id[32];
		char steam_id2[32];
		SQL_FetchString(hndl, 0, steam_id2, sizeof(steam_id2));
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		char query[1000];
		if(StrEqual(steam_id,steam_id2)){
			CPrintToChat(client,"%T %T","Server Name",client,"referal error",client);
			return Plugin_Handled;
		}
		Format(query,sizeof(query),"UPDATE lada_referal set status=1,invitedby='%s' where steam_id='%s'",steam_id2,steam_id);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		addcredit(client,g_ireferalinvited);
		Format(query,sizeof(query),"UPDATE lada_playerlada set credits=credits+'%d' where steam_id='%s'",g_ireferalinviter,steam_id2);
		SQL_TQuery(hDatabase, T_TestKnife4, query, 0);
		Format(query,sizeof(query),"UPDATE lada_referal set invitedcounter=invitedcounter+1 where steam_id='%s'",steam_id2);
		SQL_TQuery(hDatabase, T_TestKnife4, query, 0);
		char szoveg[100];
		Format(szoveg,sizeof(szoveg),"%T","coin name",client);
		CPrintToChat(client,"%T %T","Server Name",client,"referal price",client,formatosszeg(g_ireferalinvited),szoveg);
	}else{
		CPrintToChat(client,"%T %T","Server Name",client,"referal error",client);
	}
	return;
}