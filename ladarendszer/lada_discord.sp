SendDiscordMessage(int client, int index, int type)
{
	char szoveg[500];
	Format(szoveg, sizeof(szoveg), "%s", g_swebhookmessageopen);
	char nev[100];
	GetClientName(client, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	int buffer_len_playername = strlen(nev) * 2 + 1;
	new String: v_playername[buffer_len_playername];
	SQL_EscapeString(hDatabase, nev, v_playername, buffer_len_playername);
	ReplaceString(szoveg, sizeof(szoveg), "{NICKNAME}", v_playername);
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	ReplaceString(szoveg, sizeof(szoveg), "{STEAMID}", steam_id);
	char fegyvernev[200];
	if (g_Stattrak[client][index] == 1)
	{
		Format(fegyvernev, sizeof(fegyvernev), "%s | %s ST %s", fegyveridtonev(g_Weapon[client][index]), g_SkinName[client][index], GetKopottsagFromFloatRovid(g_Float[client][index]));
	}
	else {
		Format(fegyvernev, sizeof(fegyvernev), "%s | %s %s", fegyveridtonev(g_Weapon[client][index]), g_SkinName[client][index], GetKopottsagFromFloatRovid(g_Float[client][index]));
	}
	ReplaceString(szoveg, sizeof(szoveg), "{FEGYVER}", fegyvernev);
	float idg = float(g_Float[client][index]);
	idg		  = idg / 100000;
	char floats[10];
	Format(floats, sizeof(floats), "%.5f", idg);
	ReplaceString(szoveg, sizeof(szoveg), "{FLOAT}", floats);
	Format(floats, sizeof(floats), "%d", g_Seed[client][index]);
	ReplaceString(szoveg, sizeof(szoveg), "{SEED}", floats);
	char tipus[100];
	switch (type)
	{
		case 1:
		{
			Format(tipus, sizeof(tipus), "%s", "Gratulálunk! Nyitottak egy");
		}
		case 2:
		{
			Format(tipus, sizeof(tipus), "%s (%s %T)", "Levette a piacról.", formatosszeg(g_sTargetCredit[client]), "coin name", client);
		}
		case 3:
		{
			Format(tipus, sizeof(tipus), "%s (%s %T)", "Kirakta a piacra.", formatosszeg(g_sTargetCredit[client]), "coin name", client);
		}
		case 4:
		{
			Format(tipus, sizeof(tipus), "%s (%s %T)", "Megvette a piacról.", formatosszeg(g_sTargetCredit[client]), "coin name", client);
		}
	}
	ReplaceString(szoveg, sizeof(szoveg), "{MENTION}", tipus);
	switch (type)
	{
		case 1:
		{
			Format(tipus, sizeof(tipus), "%s", "#ff008f");
		}
		case 2:
		{
			Format(tipus, sizeof(tipus), "%s", "#0000ff");
		}
		case 3:
		{
			Format(tipus, sizeof(tipus), "%s", "#00ff00");
		}
		case 4:
		{
			Format(tipus, sizeof(tipus), "%s", "#ff0000");
		}
	}
	ReplaceString(szoveg, sizeof(szoveg), "{COLOR}", tipus);
	char szoveg2[30];
	Format(szoveg2,sizeof(szoveg2),"%s",formatosszeg(getcreditar(g_Weapon[client][index], g_Skins[client][index], g_Float[client][index], g_Stattrak[client][index], client)));
	ReplaceString(szoveg, sizeof(szoveg), "{PRICE}", szoveg2);
	Discord_SendMessage(g_cWebhook, szoveg);
}

/*
SendDiscordMessageClanTag(int client)
{
	char szoveg[500];
	Format(szoveg,sizeof(szoveg),"%s",MSG_CLANTAG);
	char nev[100];
	GetClientName(client,nev,sizeof(nev));
		ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	int buffer_len_playername = strlen(nev) * 2 + 1;
	new String: v_playername[buffer_len_playername];
	SQL_EscapeString(hDatabase, nev, v_playername, buffer_len_playername);
	ReplaceString(szoveg,sizeof(szoveg),"{NICKNAME}",v_playername);
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	ReplaceString(szoveg,sizeof(szoveg),"{STEAMID}",steam_id);
	ReplaceString(szoveg,sizeof(szoveg),"{CLANTAG}",g_ScoreTag[client]);
	Discord_SendMessage(g_cWebhook2, szoveg);
}
*/

SendDiscordMessageLotto(char name[100], int number)
{
	char szoveg[500];
	Format(szoveg, sizeof(szoveg), "%s", g_swebhookmessagelotto);
	char szam[11];
	Format(szam, sizeof(szam), "%d", number * (g_ilottoar - g_iquickselllotto));
	ReplaceString(szoveg, sizeof(szoveg), "{WINNER}", name);
	ReplaceString(szoveg, sizeof(szoveg), "{AMOUNT}", szam);
	ReplaceString(szoveg, sizeof(szoveg), "{MENTION}", "");
	Discord_SendMessage(g_cWebhook3, szoveg);
}