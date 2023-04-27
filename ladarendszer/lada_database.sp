StartSQL()
{
	SQL_TConnect(GotDatabase);
}

public GotDatabase(Handle owner, Handle hndl, const String: error[], any: data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Database Connection Error: %s", error);
	}
	else {
		hDatabase = hndl;
		if (betoltve == 0)
		{
			LoadServerLada();
			betoltve = 1;
		}
	}
}

bool  VerifyTable()
{
	decl String: error[255];
	decl String: query[5000];

	Handle db = SQL_Connect("default", true, error, sizeof(error));
	if (db == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Could Not Connect to Database, error: %s", error);
		return false;
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_inv` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `player_name` varchar(65) NOT NULL,",
		   "  `fegyver_id` int(11) NOT NULL,",
		   "  `skin_name` varchar(100) NOT NULL,",
		   "  `skin_id` int(11) NOT NULL,",
		   "  `skin_float` float(11) NOT NULL,",
		   "  `skin_stattrak` int(1) NOT NULL,",
		   "  `skin_stattrak_count` int(11) NOT NULL,",
		   "  `skin_nametag` varchar(32) NOT NULL default '',",
		   "  `skin_seed` int(11) NOT NULL,",
		   "  `skin_locked` int(1) NOT NULL default '0',",
		   "  `skin_last` int(1) NOT NULL default '0',",
		   "  `rare` int(11) NOT NULL,",
		   "  `timestamp` timestamp NOT NULL default '0000-00-00 00:00:00' on update CURRENT_TIMESTAMP,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	bool  success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_inv table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_ladaskin` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `ladaid` int(11) NOT NULL,",
		   "  `fegyverid` int(11) NOT NULL,",
		   "  `skin_name` varchar(100) NOT NULL,",
		   "  `skin_id` int(11) NOT NULL,",
		   "  `chance` int(11) NOT NULL,",
		   "  `rare` int(11) NOT NULL,",
		   "  `fn` int(11) NOT NULL default '0',",
		   "  `mw` int(11) NOT NULL default '0',",
		   "  `ft` int(11) NOT NULL default '0',",
		   "  `ww` int(11) NOT NULL default '0',",
		   "  `bs` int(11) NOT NULL default '0',",
		   "  `fn_s` int(11) NOT NULL default '0',",
		   "  `mw_s` int(11) NOT NULL default '0',",
		   "  `ft_s` int(11) NOT NULL default '0',",
		   "  `ww_s` int(11) NOT NULL default '0',",
		   "  `bs_s` int(11) NOT NULL default '0',",
		   "  `casino_ban` int(11) NOT NULL default '0',",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_ladaskin table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_playerlada` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `credits` int(32) NOT NULL default '0',",
		   "  `player_name` text,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_playerlada table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_freelada` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `timestamp` int(11) NOT NULL,",
		   "  `counter` int(11) NOT NULL default '0',",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_freelada table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_stats` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `openedlada` int(11) NOT NULL default '0',",
		   "  `opened1` int(11) NOT NULL default '0',",
		   "  `opened2` int(11) NOT NULL default '0',",
		   "  `opened3` int(11) NOT NULL default '0',",
		   "  `opened4` int(11) NOT NULL default '0',",
		   "  `opened6` int(11) NOT NULL default '0',",
		   "  `allcredit` int(11) NOT NULL default '0',",
		   "  `opened7` int(11) NOT NULL default '0',",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_stats table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_piac` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `credit` int(32) NOT NULL default '0',",
		   "  `fegyver_id` int(11) NOT NULL,",
		   "  `skin_name` varchar(100) NOT NULL,",
		   "  `skin_id` int(11) NOT NULL,",
		   "  `skin_float` float(11) NOT NULL,",
		   "  `skin_stattrak` int(1) NOT NULL,",
		   "  `skin_stattrak_count` int(11) NOT NULL,",
		   "  `skin_seed` int(11) NOT NULL,",
		   "  `rare` int(11) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_piac table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_log` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `action` varchar(200) NOT NULL,",
		   "  `timestamp` int(11) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_log table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_quest` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `weapon` int(11) NOT NULL,",
		   "  `head` int(1) NOT NULL,",
		   "  `kills` int(11) NOT NULL,",
		   "  `ckills` int(11) NOT NULL,",
		   "  `win1` int(11) NOT NULL,",
		   "  `win1db` int(11) NOT NULL,",
		   "  `win2` int(11) NOT NULL,",
		   "  `win2db` int(11) NOT NULL,",
		   "  `winc` int(11) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_quest table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_questtime` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `timestamp` int(11) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_questtime table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_vip` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `timestamp` int(11) NOT NULL,",
		   "  `type` varchar(32) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_vip table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_viptags` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `ChatTag` text,",
		   "  `ChatColor` varchar(400),",
		   "  `NameColor` varchar(400),",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_viptags table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_blockopen` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `open` int(1) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_blockopen table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_lotto` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `number` int(11) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_lotto table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_lottotimer` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `timestamp` int(11) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_lottotimer table:%s", error);
	}

	Format(query, sizeof(query), "%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_ado` (",
		   "  `id` int(11) NOT NULL auto_increment,",
		   "  `number` int(11) NOT NULL,",
		   "  PRIMARY KEY  (`id`),",
		   "  UNIQUE KEY `id` (`id`)",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_ado table:%s", error);
	}
	
	
	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_cases` (",
		   "  `id` int(11) NOT NULL,",
		   "  `nev` varchar(50) NOT NULL,",
		   "  `can_drop_kill` int(1) NOT NULL default '0',",
		   "  `can_drop_mapend` int(1) NOT NULL default '0',",
		   "  `can_drop_adminadd` int(1) NOT NULL default '0',",
		   "  `can_buy_lada` int(1) NOT NULL default '0',",
		   "  `can_buy_kulcs` int(1) NOT NULL default '0',",
		   "  `kulcs_price` int(11) NOT NULL default '210',",
		   "  `flags_to_open` varchar(32) NOT NULL default '',",
		   "  `lada_price` int(11) NOT NULL default '0'",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_cases table:%s", error);
	}
	
	
	Format(query, sizeof(query), "%s%s%s%s%s%s%s%s%s",
		   "CREATE TABLE IF NOT EXISTS `lada_referal` (",
		   "  `id` int(11) NOT NULL,",
		   "  `steam_id` varchar(32) NOT NULL,",
		   "  `code` varchar(6) NOT NULL,",
		   "  `invitedby` varchar(32) NOT NULL,",
		   "  `invitedcounter` int(11) NOT NULL default '0',",
		   "  `playername` varchar(32) NOT NULL,",
		   "  `status` int(1) NOT NULL default '0'",
		   ") ENGINE=MyISAM DEFAULT CHARSET=utf8; ");

	success = SQL_FastQuery(db, query);
	if (!success)
	{
		SQL_GetError(db, error, sizeof(error));
		LogError("[Ladarendszer] Unable to verify lada_referal table:%s", error);
	}
	
	return true;
}