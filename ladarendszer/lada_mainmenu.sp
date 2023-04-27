

public Cmd_mainmenu(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char asd2[100];
	Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client,formatosszeg(g_credits[client]));
	menu.DrawText(asd2);
	menu.DrawText(" ");
	Format(asd2, sizeof(asd2), "%T", "daily free", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "open case", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "inventory", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "referal", client);
	menu.DrawItem(asd2);
	menu.DrawItem("Parancsok");
	menu.DrawText(" ");
	menu.CurrentKey = 9;
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, MainMenu, 60);
	delete menu;
}

public int MainMenu(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
			if (item == 2)
			{
				ladanyitmenu(client);
			}
			else if (item == 3)
			{
				showplayeritems(client);
			}
			else if (item == 1)
			{
				napifree(client);
			}else if(item==4){
				Cmd_ref(client,0);
			}else if(item==5){
				showallcommand(client,0);
			}
		
	}
}

showegyeb(client)
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
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "send", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "quicksell", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "shop", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "trade", client);
	menu.DrawItem(asd2);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, EgyebMenu, 60);
	delete menu;
}

public int EgyebMenu(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
			if (item == 1)
			{
				showpiac(client);
			}
			else if (item == 2) {
				showpiacrend(client);
			}
			else if (item == 3)
			{
				targykuld(client);
			}
			else if (item == 4) {
				eladmenu(client);
			}
			else if (item == 5) {
				openshop(client);
			}else if(item==6){
				showtrade(client);
			}else {
				Cmd_premainmenu(client, 0);
			}
		
	}
}