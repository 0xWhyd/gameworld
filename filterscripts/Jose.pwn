//Fs Configurarada para GameWorld
//Los Comandos /creargarage /borrargarage solo iran si estas logeado con la Rcon

#include <a_samp> 
#include <dini> 
#include <streamer> 
#include <sscanf2>
#include <zcmd> 


#define MAX_GARAGES 500
#define GARAGE_OWNED_PICKUP 1239 
#define GARAGE_FREE_PICKUP 1318 
#define GARAGE_OWNED_TEXT "Propietario: %s\nBloqueado: %s" 
#define GARAGE_FREE_TEXT "En Venta!\n Precio: %d\n\nUse /comprarg para comprar.\n Usa /entrarg para ingresar"
#define DD 20.0 
#define TXTCOLOR 0xF9C50FFF 
#define COLOR_USAGE 0xBB4D4DFF 
#define COLOR_SUCCESS 0x00AE00FF 
#define COLOR_ERROR 0xFF0000FF 
#define COLOR_ORANGE 0xFFA500FF
#define COLOR_LIGHTBLUE 0xADD8E6FF 


#define SCRIPT_VERSION "V1.0b"

enum garageInfo{

	Owner[24],
	Owned, 
	Locked, 
	Price, 
	Float:PosX, 
	Float:PosY, 
	Float:PosZ, 
	Interior, 
 	UID 
}


//=== NEWS ===//
new gInfo[MAX_GARAGES][garageInfo]; 
new garageCount; 
new Float:GarageInteriors[][] = 
{
	{616.4642, -124.4003, 997.5993, 90.0, 3.0}, 
    {617.0011, -74.6962, 997.8426, 90.0, 2.0}, 
    {606.4268, -9.9375, 1000.7485, 270.0, 1.0} 

};
new Text3D:garageLabel[MAX_GARAGES];
new garagePickup[MAX_GARAGES]; 
new lastGarage[MAX_PLAYERS]; 



public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	printf(" Garage %s by Joseito//Love Cargados..",SCRIPT_VERSION);
	print("--------------------------------------\n");
	Load_Garages();
	return 1;
}

public OnFilterScriptExit()
{
	Save_Garages();
	Remove_PickupsAndLabels();
	return 1;
}

stock GetPlayerNameEx(playerid)
{
	new pName[24];
	GetPlayerName(playerid,pName,24);
	return pName;
}
stock Load_Garages()
{
	garageCount = 1;
	new path[128];
	for(new i=0; i < MAX_GARAGES; i++)
	{
	    format(path,sizeof(path),"garages/%d.ini",i); 
	    if(dini_Exists(path)) 
	    {
	        format(gInfo[i][Owner],24,"%s",dini_Get(path,"Owner"));
	        gInfo[i][Owned] = dini_Int(path,"Owned");
	        gInfo[i][Locked] = dini_Int(path,"Locked");
	        gInfo[i][Price] = dini_Int(path,"Price");
		    gInfo[i][PosX] = dini_Float(path,"PosX");
		    gInfo[i][PosY] = dini_Float(path,"PosY");
		    gInfo[i][PosZ] = dini_Float(path,"PosZ");
		    gInfo[i][UID] = dini_Int(path,"UID");
		    UpdateGarageInfo(i);
		    garageCount++;
		}
	}
	printf("[Sistema Garages GW]: Loaded %d garages.",garageCount);
	garageCount++; 
}
stock Save_Garages() 
{
	new path[128];
	for(new i=0; i < garageCount+1; i++)
	{
	    format(path,sizeof(path),"garages/%d.ini",i); 
	    if(dini_Exists(path))
	    {
	        dini_Set(path,"Owner",gInfo[i][Owner]);
			dini_IntSet(path,"Owned",gInfo[i][Owned]);
			dini_IntSet(path,"Locked",gInfo[i][Locked]);
			dini_IntSet(path,"Price",gInfo[i][Price]);
			dini_FloatSet(path,"PosX",gInfo[i][PosX]);
			dini_FloatSet(path,"PosY",gInfo[i][PosY]);
			dini_FloatSet(path,"PosZ",gInfo[i][PosZ]);
			dini_IntSet(path,"UID",gInfo[i][UID]);
		}
	}
}
stock Save_Garage(gid) 
{
	new path[128];
	format(path,sizeof(path),"garages/%d.ini",gid); 
	if(dini_Exists(path)) 
    {
        dini_Set(path,"Owner",gInfo[gid][Owner]);
		dini_IntSet(path,"Owned",gInfo[gid][Owned]);
		dini_IntSet(path,"Locked",gInfo[gid][Locked]);
		dini_IntSet(path,"Price",gInfo[gid][Price]);
		dini_FloatSet(path,"PosX",gInfo[gid][PosX]);
		dini_FloatSet(path,"PosY",gInfo[gid][PosY]);
		dini_FloatSet(path,"PosZ",gInfo[gid][PosZ]);
		dini_IntSet(path,"UID",gInfo[gid][UID]);
	}

}
stock UpdateGarageInfo(gid) 
{

	DestroyDynamic3DTextLabel(garageLabel[gid]);
	DestroyDynamicPickup(garagePickup[gid]);

	
	new ltext[128];
	if(gInfo[gid][Owned] == 1)
	{
	    format(ltext,128,GARAGE_OWNED_TEXT,gInfo[gid][Owner],GetLockedStatus(gInfo[gid][Locked]));
	    garageLabel[gid] = CreateDynamic3DTextLabel(ltext, TXTCOLOR, gInfo[gid][PosX],gInfo[gid][PosY],gInfo[gid][PosZ]+0.1,DD);
	    garagePickup[gid] = CreateDynamicPickup(GARAGE_OWNED_PICKUP,1,gInfo[gid][PosX],gInfo[gid][PosY],gInfo[gid][PosZ]+0.2);
	}
	if(gInfo[gid][Owned] == 0)
	{
	    format(ltext,128,GARAGE_FREE_TEXT,gInfo[gid][Price]);
	    garageLabel[gid] = CreateDynamic3DTextLabel(ltext, TXTCOLOR, gInfo[gid][PosX],gInfo[gid][PosY],gInfo[gid][PosZ]+0.1,DD);
	    garagePickup[gid] = CreateDynamicPickup(GARAGE_FREE_PICKUP,1,gInfo[gid][PosX],gInfo[gid][PosY],gInfo[gid][PosZ]);
	}
}
stock GetLockedStatus(value)
{
	new out[64];
	if(value == 1)
	{
	    out = "Abierto";
	}
	else
	{
	    out = "Cerrado";
	}
	return out;
}
stock Remove_PickupsAndLabels()
{
	for(new i=0; i < garageCount+1; i++)
	{
	    DestroyDynamic3DTextLabel(garageLabel[i]);
	    DestroyDynamicPickup(garagePickup[i]);
	}
}
CMD:ayudagarage(playerid,params[])
{
	SendClientMessage(playerid, COLOR_ORANGE, "Sistema Garages GW commands:");
	if(!IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "/entrarg | /salirg | /segurog | /comprarg | /vendergarage");
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "/creargarage | /borrargarage | /garagetypes | /entrarg | /salirg | /segurog | /comprarg | /vendergarage");
	}
	return 1;
}
CMD:tipog(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
    SendClientMessage(playerid, COLOR_ORANGE, "Sistema Garages GW info - Garage types");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type 0: Small garage");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Type 1: Medium garage");
	return 1;
}
CMD:creargarage(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	if(garageCount == MAX_GARAGES) return SendClientMessage(playerid, COLOR_USAGE, "El max. se alcanza la cantidad de garajes.");
	new price, type;
	if(sscanf(params,"dd",price, type)) return SendClientMessage(playerid, COLOR_USAGE, "Usage: /creargarage <price> <1(Pequeño) - 2(Grande)>  || Usa /garagetypes para obtener una lista de tipos de garaje.");
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X,Y,Z);
	format(gInfo[garageCount][Owner],24,"the State");
	gInfo[garageCount][Owned] = 0;
	gInfo[garageCount][Price] = price;
	gInfo[garageCount][Interior] = type;
	gInfo[garageCount][UID] = garageCount;
	gInfo[garageCount][PosX] = X;
	gInfo[garageCount][PosY] = Y;
	gInfo[garageCount][PosZ] = Z;
	gInfo[garageCount][Locked] = 1;
	new path[128];
	format(path,sizeof(path),"garages/%d.ini",garageCount); //Format the path with the filenumber
	dini_Create(path);
	Save_Garage(garageCount);
	UpdateGarageInfo(garageCount);
	garageCount++;
	SendClientMessage(playerid,COLOR_SUCCESS,"Garage creado!");
	return 1;
}
CMD:borrargarage(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) return 0;
    for(new i=0; i < garageCount+1; i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
	    {
	        format(gInfo[i][Owner],24,"REMOVED");
			gInfo[i][Owned] = -999;
			gInfo[i][Price] = -999;
			gInfo[i][Interior] = -999;
			gInfo[i][UID] = -999;
			gInfo[i][PosX] = -999;
			gInfo[i][PosY] = -999;
			gInfo[i][PosZ] = -999;
			gInfo[i][Locked] = -999;
			DestroyDynamic3DTextLabel(garageLabel[i]);
	    	DestroyDynamicPickup(garagePickup[i]);
			new path[128];
			format(path,sizeof(path),"garages/%d.ini",i); //Format the path with the filenumber
			dini_Remove(path);
			SendClientMessage(playerid, COLOR_SUCCESS, "Garage Borrado.");
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_ERROR,"Error: Usted no está cerca de ningún garaje.");
	return 1;
}
CMD:entrarg(playerid,params[])
{
	for(new i=0; i < garageCount+1; i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
	    {
	    
	        if(gInfo[i][Locked] == 1 && strcmp(GetPlayerNameEx(playerid),gInfo[i][Owner])) return SendClientMessage(playerid,COLOR_ERROR,"Error: No eres el dueño de este garaje. Está cerrada, no se puede entrar.");
	        new gtype = gInfo[i][Interior];
	       	if(!IsPlayerInAnyVehicle(playerid))
			{
				SetPlayerVirtualWorld(playerid,gInfo[i][UID]);
				SetPlayerInterior(playerid,floatround(GarageInteriors[gtype][4]));
				SetPlayerPos(playerid,GarageInteriors[gtype][0],GarageInteriors[gtype][1],GarageInteriors[gtype][2]);
				lastGarage[playerid] = i;
			}
			else
			{
				new vid = GetPlayerVehicleID(playerid);
			    LinkVehicleToInterior(vid,floatround(GarageInteriors[gtype][4]));
			    SetVehicleVirtualWorld(vid,gInfo[i][UID]);
                SetPlayerVirtualWorld(playerid,gInfo[i][UID]);
				SetPlayerInterior(playerid,floatround(GarageInteriors[gtype][4]));
				SetVehiclePos(vid,GarageInteriors[gtype][0],GarageInteriors[gtype][1],GarageInteriors[gtype][2]);
				lastGarage[playerid] = i;
			}
			return 1;

		}
	}
	SendClientMessage(playerid,COLOR_ERROR,"Error: Usted no está cerca de ningún garage'. ");
	return 1;
}
CMD:salirg(playerid,params[])
{
	if(lastGarage[playerid] >= 0)
 	{
	    new lg = lastGarage[playerid];
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
	    	SetPlayerPos(playerid,gInfo[lg][PosX],gInfo[lg][PosY],gInfo[lg][PosZ]);
	    	SetPlayerInterior(playerid,0);
	    	SetPlayerVirtualWorld(playerid,0);
		}
		else
		{
		    new vid = GetPlayerVehicleID(playerid);
			LinkVehicleToInterior(vid,0);
			SetVehicleVirtualWorld(vid,0);
			SetVehiclePos(vid,gInfo[lg][PosX],gInfo[lg][PosY],gInfo[lg][PosZ]);
		    SetPlayerVirtualWorld(playerid,0);
		    SetPlayerInterior(playerid,0);
		}
		lastGarage[playerid] = -999;
	}
	else return SendClientMessage(playerid,COLOR_ERROR,"Error: No estás en un garaje.");
	return 1;
}
		    
CMD:comprarg(playerid, params[])
{
    for(new i=0; i < garageCount+1; i++)
	{
  		if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
  		{
			if(gInfo[i][Owned] == 1) return SendClientMessage(playerid, COLOR_ERROR,"Error: Este garaje ya fue comprado.");
			if(GetPlayerMoney(playerid) < gInfo[i][Price]) return SendClientMessage(playerid,COLOR_ERROR,"Error: Usted no tiene suficiente dinero para comprar este garaje.");
			GivePlayerMoney(playerid,-gInfo[i][Price]);
			gInfo[i][Price]-= random(5000); //Take some money off of the original price
			format(gInfo[i][Owner],24,"%s",GetPlayerNameEx(playerid));
			gInfo[i][Owned] = 1;
			Save_Garage(i);
			UpdateGarageInfo(i);
			SendClientMessage(playerid,COLOR_SUCCESS,"Usted ha comprado con éxito este garaje.");
			return 1;
  		}
	}
	SendClientMessage(playerid,COLOR_ERROR,"Error: Usted no está cerca de ningún garaje.");
	return 1;
}
CMD:segurog(playerid,params[])
{
	for(new i=0; i < garageCount+1; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
  		{
			if(strcmp(gInfo[i][Owner],GetPlayerNameEx(playerid))) return SendClientMessage(playerid,COLOR_ERROR,"Error: You're not the owner of this garage.");
			if(gInfo[i][Locked] == 1)
			{
			    gInfo[i][Locked] = 0;
			    UpdateGarageInfo(i);
			    Save_Garage(i);
                SendClientMessage(playerid,COLOR_SUCCESS,"Usted ha desbloqueado su garaje.");
			    return 1;
			}
			else
			{
			    gInfo[i][Locked] = 1;
			    UpdateGarageInfo(i);
                Save_Garage(i);
                SendClientMessage(playerid,COLOR_SUCCESS,"Usted ha bloqueado su garaje.");
			    return 1;
			}
	 	}
	}
	SendClientMessage(playerid,COLOR_ERROR,"Error: Usted no está cerca de ningún garaje.");
	return 1;
}
CMD:vendergarage(playerid,params[])
{
	for(new i=0; i < garageCount+1; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, gInfo[i][PosX], gInfo[i][PosY], gInfo[i][PosZ]))
    	{
			if(strcmp(gInfo[i][Owner],GetPlayerNameEx(playerid))) return SendClientMessage(playerid,COLOR_ERROR,"Error: No eres el dueño de este garaje.");
			GivePlayerMoney(playerid,gInfo[i][Price]-random(500));
			gInfo[i][Owned] = 0;
			format(gInfo[i][Owner],24,"the State");
			gInfo[i][Locked] = 1;
			UpdateGarageInfo(i);
			Save_Garage(i);
			SendClientMessage(playerid, COLOR_SUCCESS,"Usted ha vendido con éxito su garaje.");
		   	return 1;
		  }
	}
	SendClientMessage(playerid, COLOR_ERROR,"Usted no está cerca de ningún garaje.");
	return 1;
}

