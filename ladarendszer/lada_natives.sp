public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("MegoltElek_Ladarendszer");
	CreateNative("lada_addcredit", Native_lada_addcredit);
	CreateNative("lada_addcase", Native_lada_addcase);
	CreateNative("lada_addkey", Native_lada_addkey);
	CreateNative("lada_formatcredit", Native_lada_formatcredit);
	CreateNative("lada_getplayercredit", Native_lada_getplayercredit);
	return APLRes_Success;
}

any Native_lada_addcredit(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int credit = GetNativeCell(2);
	addcredit(client, credit);
}

any Native_lada_addcase(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int lada = GetNativeCell(2);
	int number = GetNativeCell(3);
	addlada(client,lada,number);
}

any Native_lada_addkey(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int lada = GetNativeCell(2);
	int number = GetNativeCell(3);
	addkey(client,lada,number);
}

any Native_lada_formatcredit(Handle plugin, int numParams)
{
	int len;
	GetNativeStringLength(1, len);
	int credit = GetNativeCell(2);
	if (len <= 0)
	{
		return;
	}
	
	char[] str = new char[len + 1];
	GetNativeString(1, str, len + 1);
	
	char osszeg[20];
	Format(osszeg,sizeof(osszeg),"%s",formatosszeg(credit));
	
	ReplaceString(str,len+1,"{CREDIT}",osszeg);
	
	SetNativeString(1, str, len+1, false);
}



int Native_lada_getplayercredit(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	return g_credits[client];
}


formatosszeg(int credit){
	char str[50];
	//Format(str,sizeof(str),"%d",credit / 100);
	Format(str,sizeof(str),"%d.%s%d",credit/100,credit%100<10?"0":"",credit%100);
	
	return str;
}