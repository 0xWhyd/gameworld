/*
********************************************************
*********** Sistema Anti-Bot 1.0 By N3tB4utu$ ***********
/////////// www.WorldRol.net \\\\\\\\\\\\\\\\\\\\\\\\
********************************************************
********************************************************
*/


#include <a_samp>

public OnPlayerConnect(playerid)
{
if(strfind(Nome(playerid),"123456789$",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"123456789",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"clock$",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"prn",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Carl",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"con",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"SgtPepper",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Pepe",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"nul",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Pepno",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Pepsi",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Rocky",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Carl",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Vino_Toro",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Zoquete",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"AquilesBrinco",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Azucar",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Manfrey",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Papirola",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"[ViP]Labrik",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Sony",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Pacman",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"Batman",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"aux",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com1",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com2",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com3",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com4",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com5",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com6",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com7",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com8",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"com9",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"lpt1",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"lpt2",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"lpt3",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"lpt4",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"lpt5",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"lpt6",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"lpt8",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"lpt9",true) != -1) 
{
Ban(playerid);
}
if(strfind(Nome(playerid),"PRUEBEN_LAIPNUEVA",true) != -1) 
{
Ban(playerid);
}
if(strfind(Nome(playerid),"174_138.163.173_7001",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"ENTRENA_LAIP",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"WORLDROL_CIERRA",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"WORLDROL_",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"78_129_221_58_7787",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"87_98_229_188_7232",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"87_98_229_188_7232",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"46_105_239_117_8888",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"66_7_194_75_5555",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"173_192_22_150_7777",true) != -1)
{
Ban(playerid);
}
if(strfind(Nome(playerid),"66_7_194_75_9990",true) != -1)
{
Ban(playerid);
}
return 1;
}

stock Nome(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}
