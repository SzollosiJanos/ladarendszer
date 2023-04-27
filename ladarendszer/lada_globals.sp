#define VERSION	   "9.5.9"
#define LASTUPDATE "2023.04.18.  13:30"
#define LASTCHANGE "casino seed fix"

#define MAX_SKIN   10000
#define MAX_LADA   100
#define MAX_LADASKIN 1000

char g_szFeature1[] = "Elekcase_creditboost";
char g_szFeature3[] = "Elekcase_kesboost";
char g_szFeature4[] = "Elekcase_pirosboost";
char g_szFeature5[] = "Elekcase_rozsaszinboost";
char g_szFeature6[] = "Elekcase_lilaboost";
char g_szFeature7[] = "Elekcase_customboost";

int	   betoltve;
int	   maxloadedlada   = -1;
char   g_cWebhook[32]  = "ladanyitas";
char   g_cWebhook2[32] = "clantag";
char   g_cWebhook3[32] = "lotto";

int addcroleinput[MAXPLAYERS+1];

// ládák:
char   g_ladanev[MAX_LADA][MAX_LADASKIN];
int	   g_ladaar[MAX_LADA];
int	   g_kulcsar[MAX_LADA];
char   g_ladaskinnev[MAX_LADA][MAX_LADASKIN][MAX_LADASKIN];
int	   g_ladaskinid[MAX_LADA][MAX_LADASKIN];
int	   g_ladaskinchance[MAX_LADA][MAX_LADASKIN];
int	   g_ladameret[MAX_LADA];
int	   g_lada[MAXPLAYERS + 1][MAX_LADA][2];
int	   g_Ladafegyverid[MAX_LADA][MAX_LADASKIN];
int	   g_LadaRare[MAX_LADA][MAX_LADASKIN];
int	   g_Ladaskinar[MAX_LADA][MAX_LADASKIN][5][2];
int    g_ladadropkill[MAX_LADA];
int    g_ladadropadminadd[MAX_LADA];
int    g_ladadropmapend[MAX_LADA];
int    g_ladabuykulcs[MAX_LADA];
int    g_ladabuylada[MAX_LADA];
int 	g_ladabetolteshezhelper=0;
int 	g_ladarares[MAX_LADA][8];
char   g_flagtoopen[MAX_LADA][21];
int	   g_casinoban[MAX_LADA][MAX_LADASKIN];

// játékos:
int	   g_Rare[MAXPLAYERS + 1][MAX_SKIN];
int	   g_fegyvid[MAXPLAYERS + 1][36];
int	   g_DB[MAXPLAYERS + 1];
int	   g_Skins[MAXPLAYERS + 1][MAX_SKIN];
int	   g_Weapon[MAXPLAYERS + 1][MAX_SKIN];
int	   g_Id[MAXPLAYERS + 1][MAX_SKIN];
int	   g_Stattrak[MAXPLAYERS + 1][MAX_SKIN];
int	   g_StattrakCount[MAXPLAYERS + 1][MAX_SKIN];
int	   g_Seed[MAXPLAYERS + 1][MAX_SKIN];
int	   g_Float[MAXPLAYERS + 1][MAX_SKIN];
char   g_SkinName[MAXPLAYERS + 1][MAX_SKIN][100];
int	   g_PlayerStats[MAXPLAYERS + 1][9];
int   g_credits[MAXPLAYERS + 1];
int	   g_betoltve[MAXPLAYERS + 1]= {0,...};
int	   g_connected[MAXPLAYERS + 1];
char   g_ChatColor[MAXPLAYERS + 1][400];
char   g_ChatTag[MAXPLAYERS + 1][400];
char   g_ScoreTag[MAXPLAYERS + 1][400];
char   g_NameColor[MAXPLAYERS + 1][400];
int	   g_ScoreTagOkay[MAXPLAYERS + 1];
int	   g_open[MAXPLAYERS + 1];
Handle g_sound;
int	   g_isopening[MAXPLAYERS + 1];
Handle OpenTimers[MAXPLAYERS + 1];
int	   g_dropped[MAXPLAYERS + 1];
char   l_steam_id[10000][32];
int	   l_numbers[10000];
bool   g_gotskinlasttime[MAXPLAYERS + 1][53];
int	   g_eladskincredit[MAXPLAYERS + 1];
bool   g_opencooldown[MAXPLAYERS + 1];
char   g_transferdata[MAXPLAYERS + 1][50];
bool   g_skinlocked[MAXPLAYERS + 1][MAX_SKIN];
int	  g_awaitladacucc[MAXPLAYERS + 1];
int	  g_awaitladacuccinput[MAXPLAYERS + 1];
float g_crashmax[MAXPLAYERS + 1];
float g_crashcurrent[MAXPLAYERS + 1];
int   g_tradepartner[MAXPLAYERS +1];
int   g_tradecoin[MAXPLAYERS +1];
bool   g_tradecoininserted[MAXPLAYERS +1];
int   g_tradelada[MAXPLAYERS +1][MAX_LADA];
int   g_tradekulcs[MAXPLAYERS +1][MAX_LADA];
int   g_tradeskin[MAXPLAYERS +1][100];
bool  g_tradeready[MAXPLAYERS +1];
int   g_ipanelbuffer[MAXPLAYERS +1];
char  g_Nametag[MAXPLAYERS +1 ][MAX_SKIN][100];
bool  g_changenametag[MAXPLAYERS +1];
bool  g_usereferal[MAXPLAYERS +1];
int  g_multiplecaseopen[MAXPLAYERS+1];
int  g_multiopencasemenu[MAXPLAYERS+1];

// játékos piacrendezés
int	   p_fegyverid[MAXPLAYERS + 1];
int	   p_credit[MAXPLAYERS + 1];
int	   p_color[MAXPLAYERS + 1];
int	   p_time[MAXPLAYERS + 1];
char   p_osszesitett[MAXPLAYERS + 1][200];
char   p_osszesitettw[MAXPLAYERS + 1][200];
char   p_osszesitettw2[MAXPLAYERS + 1][200];
int	   p_checked[MAXPLAYERS + 1][10000];
int	   p_checkcounter[MAXPLAYERS + 1];

// játékos animációk
int	   asd2[MAXPLAYERS + 1];
int	   pivot[MAXPLAYERS + 1];
int	   bpivot[MAXPLAYERS + 1];
int	   allas[MAXPLAYERS + 1];
char   skinek[MAXPLAYERS + 1][50][100];
int	   r[MAXPLAYERS + 1][50];
int	   g[MAXPLAYERS + 1][50];
int	   b[MAXPLAYERS + 1][50];
int	   vid[MAXPLAYERS + 1];
int	   vid2[MAXPLAYERS + 1];

// quest dolgok
int	   q_head[MAXPLAYERS + 1];
int	   q_kills[MAXPLAYERS + 1];
int	   q_ckills[MAXPLAYERS + 1];
int	   q_questid[MAXPLAYERS + 1];
int	   q_done[MAXPLAYERS + 1];
int	   q_canreset[MAXPLAYERS + 1];

// piacrendszerhez
bool g_isporget[MAXPLAYERS+1];
int	   g_sTargetCredit[MAXPLAYERS + 1];
bool   g_bAwaitingCredit[MAXPLAYERS + 1];
char   piacadat[MAXPLAYERS + 1][10][50];

//custom model
Handle custom_kv;
Handle quest_kv;


Handle hDatabase = INVALID_HANDLE;

// casino
int	  g_bAwaitingCreditCasino[MAXPLAYERS + 1];
int		  g_RoulettCredit[MAXPLAYERS + 1];
int		  g_valasztottroulettszin[MAXPLAYERS + 1];

char   referalcharacters[63] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";

StringMap g_smWeaponIndex;
char	  g_WeaponClasses[][] = {
	 /* 0*/ "weapon_awp", /* 1*/ "weapon_ak47", /* 2*/ "weapon_m4a1", /* 3*/ "weapon_m4a1_silencer", /* 4*/ "weapon_deagle", /* 5*/ "weapon_usp_silencer", /* 6*/ "weapon_hkp2000", /* 7*/ "weapon_glock", /* 8*/ "weapon_elite",
	 /* 9*/ "weapon_p250", /*10*/ "weapon_cz75a", /*11*/ "weapon_fiveseven", /*12*/ "weapon_tec9", /*13*/ "weapon_revolver", /*14*/ "weapon_nova", /*15*/ "weapon_xm1014", /*16*/ "weapon_mag7", /*17*/ "weapon_sawedoff",
	 /*18*/ "weapon_m249", /*19*/ "weapon_negev", /*20*/ "weapon_mp9", /*21*/ "weapon_mac10", /*22*/ "weapon_mp7", /*23*/ "weapon_ump45", /*24*/ "weapon_p90", /*25*/ "weapon_bizon", /*26*/ "weapon_famas", /*27*/ "weapon_galilar",
	 /*28*/ "weapon_ssg08", /*29*/ "weapon_aug", /*30*/ "weapon_sg556", /*31*/ "weapon_scar20", /*32*/ "weapon_g3sg1", /*33*/ "weapon_knife_karambit", /*34*/ "weapon_knife_m9_bayonet", /*35*/ "weapon_bayonet",
	 /*36*/ "weapon_knife_survival_bowie", /*37*/ "weapon_knife_butterfly", /*38*/ "weapon_knife_flip", /*39*/ "weapon_knife_push", /*40*/ "weapon_knife_tactical", /*41*/ "weapon_knife_falchion", /*42*/ "weapon_knife_gut",
	 /*43*/ "weapon_knife_ursus", /*44*/ "weapon_knife_gypsy_jackknife", /*45*/ "weapon_knife_stiletto", /*46*/ "weapon_knife_widowmaker", /*47*/ "weapon_mp5sd", /*48*/ "weapon_knife_css", /*49*/ "weapon_knife_cord",
	 /*50*/ "weapon_knife_canis", /*51*/ "weapon_knife_outdoor", /*52*/ "weapon_knife_skeleton"
};

int g_iWeaponDefIndex[] = {
	/* 0*/ 9, /* 1*/ 7, /* 2*/ 16, /* 3*/ 60, /* 4*/ 1, /* 5*/ 61, /* 6*/ 32, /* 7*/ 4, /* 8*/ 2,
	/* 9*/ 36, /*10*/ 63, /*11*/ 3, /*12*/ 30, /*13*/ 64, /*14*/ 35, /*15*/ 25, /*16*/ 27, /*17*/ 29,
	/*18*/ 14, /*19*/ 28, /*20*/ 34, /*21*/ 17, /*22*/ 33, /*23*/ 24, /*24*/ 19, /*25*/ 26, /*26*/ 10, /*27*/ 13,
	/*28*/ 40, /*29*/ 8, /*30*/ 39, /*31*/ 38, /*32*/ 11, /*33*/ 507, /*34*/ 508, /*35*/ 500,
	/*36*/ 514, /*37*/ 515, /*38*/ 505, /*39*/ 516, /*40*/ 509, /*41*/ 512, /*42*/ 506,
	/*43*/ 519, /*44*/ 520, /*45*/ 522, /*46*/ 523, /*47*/ 23, /*48*/ 503, /*49*/ 517,
	/*50*/ 518, /*51*/ 521, /*52*/ 525
};

// kpo dolgokbool
g_bInGame[MAXPLAYERS + 1];
bool g_bInAccept[MAXPLAYERS + 1];

enum sspItems
{
	None   = 0,
	Schere = 1,
	Stein  = 2,
	Papier = 3,
	Cheat  = 4,
	Lose   = 5,
	Tie	   = 6,
};

sspItems g_eSSPItem[MAXPLAYERS + 1];
int		 g_iOponent[MAXPLAYERS + 1];
int		 g_iGameAmount[MAXPLAYERS + 1];

bool	 g_bIgnoringInvites[MAXPLAYERS + 1];
int		 g_iIgnoringInvitesBellow[MAXPLAYERS + 1];

Handle	 g_hMinSSPThreshold;
int		 g_iMinSSPThreshold;

Handle	 g_hMaxSSPThreshold;
int		 g_iMaxSSPThreshold;

Handle	 g_hDefaultOffForAdmins;
bool	 g_bDefaultOffForAdmins;

Handle	 g_hChatTag;
char	 ttag[64] = "[Kő-Papír-Olló]";

Handle	 g_hUseMysqlForBlockSSP;
bool	 g_bUseMysqlForBlockSSP;

Handle	 g_hSSPOnlyDead;
int		 g_iSSPOnlyDead;

Handle	 g_hSSPOnlyDeadAdminOverride;
bool	 g_bSSPOnlyDeadAdminOverride;

Handle	 g_hSSPOnlyDeadItemOverride;
bool	 g_bSSPOnlyDeadItemOverride;

Handle	 g_hHouseMargin;
float	 g_fHouseMargin;

Handle	 g_hCreditsChooserMenuValue1;
int		 g_iCreditsChooserMenuValue1;

Handle	 g_hCreditsChooserMenuValue2;
int		 g_iCreditsChooserMenuValue2;

Handle	 g_hCreditsChooserMenuValue3;
int		 g_iCreditsChooserMenuValue3;

Handle	 g_hCreditsChooserMenuValue4;
int		 g_iCreditsChooserMenuValue4;

Handle	 g_hCreditsChooserMenuValue5;
int		 g_iCreditsChooserMenuValue5;

Handle	 g_hCreditsChooserMenuValue6;
int		 g_iCreditsChooserMenuValue6;

Handle	 g_hCreditsChooserMenuValue7;
int		 g_iCreditsChooserMenuValue7;

Handle	 g_hCreditsChooserMenuValue8;
int		 g_iCreditsChooserMenuValue8;

Handle	 g_hBlockChatCommand;
bool	 g_bBlockChatCommand;


// autoexeccfg cuccok

Handle	 g_hGiveClientCredits;
float	 g_fGiveClientCredits;
Handle	 g_hGiveClientCreditsdefault;
int		 g_fGiveClientCreditsdefault;
Handle	 g_hGiveClientCreditsvip;
int		 g_fGiveClientCreditsvip;
Handle	 g_hpricemessage;
int		 g_fpricemessage;
Handle	 g_hquicksell;
float	 g_fquicksell;
Handle	 g_hquicksellcsokkentett;
float	 g_fquicksellcsokkentett;
Handle	 g_hquickselllotto;
int		 g_iquickselllotto;
Handle	 g_hlottoar;
int		 g_ilottoar;
Handle	 g_hwebhookmessageopen;
char	 g_swebhookmessageopen[1000];
Handle	 g_hwebhookmessagelotto;
char	 g_swebhookmessagelotto[1000];
Handle	 g_hopencooldown;
float	 g_fopencooldown;
Handle	 g_hopenrarity2;
int		 g_iopenrarity2;
Handle	 g_hopenrarity3;
int		 g_iopenrarity3;
Handle	 g_hopenrarity4;
int		 g_iopenrarity4;
Handle	 g_hopenrarity5;
int		 g_iopenrarity5;
Handle	 g_hopenrarity6;
int		 g_iopenrarity6;
Handle	 g_hopenfloat2;
int		 g_iopenfloat2;
Handle	 g_hopenfloat3;
int		 g_iopenfloat3;
Handle	 g_hopenfloat4;
int		 g_iopenfloat4;
Handle	 g_hopenfloat5;
int		 g_iopenfloat5;
Handle	 g_hnametagdollar;
char	 g_snametagdollar[50];
Handle	 g_hinametagdollar;
int		 g_inametagdollar;
Handle	 g_hkilldollar;
int		 g_ikilldollar;
Handle	 g_hkilldollarhead;
int		 g_ikilldollarhead;
Handle	 g_hkilldollarknife;
int		 g_ikilldollarknife;
Handle	 g_hStattrakOn;
int	     g_iStattrakOn;
Handle	 g_hStattrakOff;
int	     g_iStattrakOff;
Handle	 g_hchangeseed;
int	     g_ichangeseed;
Handle	 g_hchangefloat;
int	     g_ichangefloat;
Handle	 g_hchangenametag;
int	     g_ichangenametag;
Handle	 g_hreferalinvited;
int	     g_ireferalinvited;
Handle	 g_hreferalinviter;
int	     g_ireferalinviter;
Handle	 g_hpricemessagehang;
int		 g_fpricemessagehang;
Handle	 g_hcasinopercent;
float		 g_icasinopercent;
Handle	 g_hcasinotime;
float		 g_icasinotime;