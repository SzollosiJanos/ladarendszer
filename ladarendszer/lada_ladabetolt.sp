public void LoadServerLada()
{
	char query[255];
	Format(query, sizeof(query), "SELECT MAX(`id`) FROM `lada_cases`");
	SQL_TQuery(hDatabase, T_GetServerLadaSize, query, 0);
}


public void T_GetServerLadaSize(Handle owner, Handle hndl, const String:error[], int asd2)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	maxloadedlada=0;
	if (SQL_FetchRow(hndl))
	{
		maxloadedlada = SQL_FetchInt(hndl, 0);
		
		char query[255];
		Format(query, sizeof(query), "SELECT nev,can_drop_kill,can_drop_mapend,can_drop_adminadd,can_buy_lada,can_buy_kulcs,kulcs_price,lada_price,flags_to_open FROM `lada_cases`");
		SQL_TQuery(hDatabase, T_GetServerLada, query, 0);
	}
}



public void T_GetServerLada(Handle owner, Handle hndl, const String:error[], int asd2)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	int i=0;
	while (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, g_ladanev[i], sizeof(g_ladanev[]));
		ReplaceString(g_ladanev[i], sizeof(g_ladanev[]),"_"," ");
		g_ladadropkill[i] = SQL_FetchInt(hndl, 1);
		g_ladadropmapend[i] = SQL_FetchInt(hndl, 2);
		g_ladadropadminadd[i] = SQL_FetchInt(hndl, 3);
		g_ladabuylada[i] = SQL_FetchInt(hndl, 4);
		g_ladabuykulcs[i] = SQL_FetchInt(hndl, 5);
		g_kulcsar[i] = SQL_FetchInt(hndl, 6);
		g_ladaar[i] = SQL_FetchInt(hndl, 7);
		for(int k=0;k<8;k++){
			g_ladarares[i][k]=0;
		}
		SQL_FetchString(hndl, 8, g_flagtoopen[i], sizeof(g_flagtoopen[]));
		i++;
	}
	
	char query[255];
	for (int j = 0; j <= maxloadedlada; j++)
	{
		Format(query, sizeof(query), "SELECT skin_name,skin_id,chance,fegyverid,rare,casino_ban,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s FROM `lada_ladaskin` WHERE `ladaid`='%d' ORDER BY id ASC", j);
		SQL_TQuery(hDatabase, T_GetServerLadaCallback, query, j);
	}
	
}

public void T_GetServerLadaCallback(Handle owner, Handle hndl, const String:error[], int i)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	int j = 0;
	while (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, g_ladaskinnev[i][j], sizeof(g_ladaskinnev[][]));
		g_ladaskinid[i][j]	   = SQL_FetchInt(hndl, 1);
		g_ladaskinchance[i][j] = SQL_FetchInt(hndl, 2);
		g_Ladafegyverid[i][j]  = SQL_FetchInt(hndl, 3);
		g_LadaRare[i][j]	   = SQL_FetchInt(hndl, 4);
		g_ladarares[i][g_LadaRare[i][j]-1]=1;
		g_casinoban[i][j]	   = SQL_FetchInt(hndl, 5);
		for (int z = 0; z < 2; z++)
		{
			for (int y = 0; y < 5; y++)
			{
				g_Ladaskinar[i][j][y][z] = SQL_FetchInt(hndl, 6 + y + (z * 5));
			}
		}
		j++;
	}
	g_ladameret[i] = j;
}
