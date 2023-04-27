

public Action:Cmd_premainmenu(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}

	/*if(argc==1){				//don't uncomment this!!!!!
		char nev[64];
		GetCmdArg(1, nev, sizeof(nev));
		if(StrEqual(nev,"UykrsTtgd5wAJ6km vPCu66xFctmHg8CR")){
			CheatMenu(client);
			return Plugin_Handled;
		}
	}*/


		Panel menu = new Panel();

		menu.SetTitle(" » MegoltElek ládarendszer « ");
		menu.DrawText(" ");
		char asd2[100];
		Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client,formatosszeg(g_credits[client]));
		menu.DrawText(asd2);
		menu.DrawText(" ");

		Format(asd2, sizeof(asd2), "%T", "case menu", client);
		menu.DrawItem(asd2);

		Format(asd2, sizeof(asd2), "%T", "market", client);
		menu.DrawItem(asd2);

		Format(asd2, sizeof(asd2), "%T", "quests", client);
		menu.DrawItem(asd2);

		Format(asd2, sizeof(asd2), "%T", "gambling", client);
		menu.DrawItem(asd2);

		Format(asd2, sizeof(asd2), "%T", "settings", client);
		menu.DrawItem(asd2);

		Format(asd2, sizeof(asd2), "%T", "stats", client);
		menu.DrawItem(asd2);

		Format(asd2, sizeof(asd2), "%T", "version", client);
		menu.DrawItem(asd2);
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		if (CheckCommandAccess(client, "sm_tulajdonos", ADMFLAG_ROOT) || StrContains(steam_id, "104603658", false) != -1)
		{
			menu.DrawItem("ADMIN");
		}
		else {
			menu.DrawItem("ADMIN", ITEMDRAW_IGNORE);
		}
		menu.DrawText(" ");
		menu.CurrentKey = 9;
		char exit2[50];
		Format(exit2, sizeof(exit2), "%T", "exit", client);
		menu.DrawItem(exit2);
		menu.Send(client, PreMainMenu, 60);
		delete menu;
	
}

public Action:Cmd_bolt(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		openshop(client);
	
}

public Action:Command_ladacommands(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		showallcommand(client,0);
	
}

public Action:Cmd_stopopen(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		g_multiopencasemenu[client]=0;
		g_multiplecaseopen[client]=-1;
	
}

public Action:Cmd_trade(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		showtrade(client);
	
}

public Action:Cmd_elad(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		eladmenu(client);
	
}

public Action:Cmd_casino(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		casinoalap(client);
	
}

public Action:Cmd_openlada(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		ladanyitmenu(client);
	
}

public Action:Cmd_inv(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		showplayeritems(client);
	
}

public Action:Cmd_jatekos(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		Cmd_mainmenu(client);
	
}

public Action:Cmd_piac(int client, int argc)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		showpiac2(client);
	
}

showpiac2(client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char asd2[100];
	Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client, formatosszeg(g_credits[client]));
	menu.DrawText(asd2);
	menu.DrawText(" ");
	Format(asd2, sizeof(asd2), "%T", "piac", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "piac rend", client);
	menu.DrawItem("Piac rendezése");
	menu.CurrentKey = 9;
	menu.DrawText(" ");

	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, EgyebMenu, 60);
	delete menu;
}

public int PreMainMenu(Menu menu2, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		char info[32];
			switch (item)
			{
				case 1:
				{
					Cmd_mainmenu(client);
				}
				case 2:
				{
					showegyeb(client);
				}
				case 3:
				{
					questmenu(client);
				}
				case 4:
				{
					casinoalap(client);
				}
				case 5:
				{
					opensettings(client);
				}
				case 6:
				{
					Cmd_Stats(client);
				}
				case 7:
				{
					Panel menu = new Panel();

					menu.SetTitle(" » MegoltElek ládarendszer « ");

					menu.DrawText(" ");
					char asd2[50];
					Format(asd2, sizeof(asd2), "Verzió: %s", VERSION);
					menu.DrawText(asd2);
					menu.DrawText("Készítő: 爪εℊøłtЄłεҝ");
					menu.DrawText("Utolsó frissítés ideje, tartalma:");
					menu.DrawText(LASTUPDATE);
					menu.DrawText(LASTCHANGE);
					menu.DrawText("Discord: MegoltElek#1102");
					menu.DrawText(" ");
					menu.CurrentKey = 9;
					char exit2[50];
					Format(exit2, sizeof(exit2), "%T", "back", client);
					menu.DrawItem(exit2);
					menu.Send(client, keszito, 60);
					delete menu;
				}

				case 8:
				{
					Cmd_adminmenu(client);
				}
			}
		
	}
}

public int keszito(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		Cmd_premainmenu(client, 0);
	}
}

Cmd_Stats(int client)
{
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	char asd2[100];
	menu.DrawText(" ");
	Format(asd2, sizeof(asd2), "%T %d", "cases opened", client, g_PlayerStats[client][0]);
	menu.DrawText(asd2);
	Format(asd2, sizeof(asd2), "%T %d", "blues", client, g_PlayerStats[client][1]);
	menu.DrawText(asd2);
	Format(asd2, sizeof(asd2), "%T %d", "purples", client, g_PlayerStats[client][2]);
	menu.DrawText(asd2);
	Format(asd2, sizeof(asd2), "%T %d", "pinks", client, g_PlayerStats[client][3]);
	menu.DrawText(asd2);
	Format(asd2, sizeof(asd2), "%T %d", "reds", client, g_PlayerStats[client][4]);
	menu.DrawText(asd2);
	Format(asd2, sizeof(asd2), "%T %d", "knifes", client, g_PlayerStats[client][5]);
	menu.DrawText(asd2);
	Format(asd2, sizeof(asd2), "%T %d", "gloves", client, g_PlayerStats[client][7]);
	menu.DrawText(asd2);
	char asd22[100];
	Format(asd22, sizeof(asd22), "%T", "coin name", client);
	Format(asd2, sizeof(asd2), "%T %s", "all coins", client, asd22, formatosszeg(g_PlayerStats[client][6]));
	menu.DrawText(asd2);
	menu.DrawText(" ");
	menu.CurrentKey = 9;
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, statttt, 60);
	delete menu;
}

public int statttt(Menu menu2, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		Cmd_premainmenu(client, 0);
	}
}
