/*

    :::       ::: :::::::::: :::::::::  ::::::::::: :::::::: 
   :+:       :+: :+:        :+:    :+:     :+:    :+:    :+: 
  +:+       +:+ +:+        +:+    +:+     +:+    +:+    +:+  
 +#+  +:+  +#+ +#++:++#   +#++:++#:      +#+    +#+    +:+   
+#+ +#+#+ +#+ +#+        +#+    +#+     +#+    +#+    +#+    
#+#+# #+#+#  #+#        #+#    #+#     #+#    #+#    #+#     
###   ###   ########## ###    ### ########### ########   

*/

@___AntiDeAMX();
@___AntiDeAMX()
{
  	#emit stack 0x7FFFFFFF
  	#emit inc.s cellmax
  	static const ___[][] = {"lorem", "ipsum"};
  	#emit retn
  	#emit load.s.pri    ___
  	#emit proc
  	#emit proc
  	#emit fill cellmax
  	#emit proc
  	#emit stack 1
  	#emit stor.alt ___
  	#emit strb.i 2
  	#emit switch 0
  	#emit retn
	L1:
  	#emit jump L1
  	#emit zero cellmin
}

#include <a_samp>
#include <a_http>

#define STREAMER_REMOVE_TEXT3D_TAG
#include "../include/streamer"

#include "../include/ysf"
#include "../include/pawncmd"
#include "../include/sscanf2"

const INFINITY = 0x7F800000;
const Float:DEFAULT_DRAW_DISTANCE = 15.0;
const EXP_MULTIPLIER = 1;
const DEFAULT_EXPIRE_TIME = 5000;
const HOSPITALIZATION_PRICE = 250;

#pragma warning disable 239

#define DEFAULT_3D_TEXT_COLOR 0xFFFFFFEE

#define COLOR_RED 0xff0048ff
#define H_COLOR_RED "{ff0048}"

#define COLOR_WHITE 0xffffffff
#define H_COLOR_WHITE "{ffffff}"

#define COLOR_GREEN 0x00db49ff
#define H_COLOR_GREEN "{00db49}"

#define COLOR_PINK 0xdeaaffff
#define H_COLOR_PINK "{deaaff}"

#define COLOR_BLUE 0x4361eeff
#define H_COLOR_BLUE "{4361ee}"

#define COLOR_GRAY 0x8d99aeff
#define H_COLOR_GRAY "{8d99ae}"

#define rand(%0,%1) random(%1 - %0) + %0

#define SetBitTrue(%1,%2) %1|=(1<<%2)
#define SetBitFalse(%1,%2) %1&=~(1<<%2)
#define GetBitValue(%1,%2) ((1<<%2)&%1?1:0)
#define ClearBits(%1) %1=0

#define Settings_SetTrue(%0,%1) SetBitTrue(gPlayers[%0][Player_Settings], %1)
#define Settings_SetFalse(%0,%1) SetBitFalse(gPlayers[%0][Player_Settings], %1)
#define Settings_GetValue(%0,%1) GetBitValue(gPlayers[%0][Player_Settings], %1)

#define IsKeyPressed(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define enumSizeof(%0,%1) sizeof(empty_%0[%1])

#define playername(%0) gPlayers[%0][Player_NameTag]
#define playeruid(%0) gPlayers[%0][Player_Uid]
#define playermoney(%0) gPlayers[%0][Player_Money]

#define TRUE true
#define FALSE false

#define SendClientMessageEx SendClientMessagef

#define _sscanf:%0,%1; EXTRN%1;unformat(_:EXTRZ:EXTRV:EXTRX:%0,#,%1,,);

// #define addBit(%1)              %1=-1

#define foreach(%0) \
	for(new _i = 0, %0 = currentPlayers[_i]; _i != totalPlayers; %0 = currentPlayers[++_i])

forward OnPlayerUseItem(playerid, itemid);
forward OnPlayerDropItem(playerid, itemid);
forward OnPlayerPickupItem(playerid, itemid);

#undef 	MAX_PLAYERS
#define MAX_PLAYERS 50

enum // Dialogs ID
{
	DIALOG_EMPTY,
	DIALOG_REGISTRATION,
	DIALOG_SELECT_GENDER,
	DIALOG_AUTHORIZATION,
	DIALOG_ACHIEVEMENTS,
	DIALOG_ACHIEVE_INFO,
	DIALOG_PLAYER_ITEMS,
	DIALOG_BUY_ITEMS_FOR_VENDING,
	DIALOG_PLRITEMS_ACTION,
	DIALOG_VEHICLE_ITEMS,
	DIALOG_VEHICLE_RADIO,
};

enum // Dynamic areas ID
{
	AREA_TYPE_VENDING = 1200,
	AREA_TYPE_DROPPED_ITEM,
};

enum // Achievements ID
{
	ACHIEVE_BUY_SODA_VENDING,
	ACHIEVE_BUY_SNACK_VENDING,
};

enum E_ACHIEVE_DATA
{
	Achieve_Exp,
	Achieve_Title[32],
	Achieve_Description[256],
};

new gAchievements[][E_ACHIEVE_DATA] =
{
	{ 20, "Поп-ыт", "Купите вендинговый автомат с содовой" },
	{ 20, "Перекус", "Купите вендинговый автомат со снэками" }
};

const MAX_ACHIEVEMENTS = sizeof gAchievements;

enum // Items ID
{
	EMPTY_FUEL_CAN,
	FUEL_CAN,
	SMALL_MEDIC_KIT,
	BOX_SPRUNK,
	BOX_COKOPOPS,
	MIDLAND_GTX_PRO_CB
};

enum E_ITEMS_DATA
{
	Item_Modelid,
	Float:Item_Height,
	Float:Item_Weight,
	Item_Title[32],
	Item_Description[256]
};

new gItems[][E_ITEMS_DATA] = 
{
	{ 1650, 0.32, 1.5, "Пустая канистра", "Чтобы наполнить канистру подойдите к заправке и введите команду /fill" },
	{ 1650, 0.32, 16.4, "Канистра с безином", "При помощи канистры вы можете заправить любой автомобиль, \
		у которого есть бензобак. Для заправки подойдите к лючку бензобака и введите команду /fuel, либо используйте канистру из инвентаря" },
	{ 11736, 0.05, 0.7, "Маленькая аптечка", "Маленькая аптечка восстанавливает 15%% здоровья. \
		Для использования введите команду /healme или используйте аптечку из инвентаря" },
	{ 2900, 1.35, 4.2, "Коробка с содовой \"Sprunk\"", "" },
	{ 2900, 1.35, 2.1, "Коробка со снэками \"Cokopops\"", "" },
	{ 2966, 0.04, 0.25, "Рация Midland GXT PRO", "" }
};

const MAX_ITEMS = sizeof gItems;

enum E_RADIOSTATION_DATA
{
	Radio_Title[32],
	Radio_Genre[32],
	Radio_Url[128]
};

new gRadios[][E_RADIOSTATION_DATA] = 
{
	{ "Pink Pop Radio", "Pop, Electro", "https://ais-edge09-live365-dal02.cdnstream.com/a75226" },
	{ "WROD 1340 AM", "Oldies", "https://ice7.securenetsystems.net/WROD" },
	{ "102.7 KIIS FM", "Charts, Hits", "https://stream.revma.ihrhls.com/zc185/hls.m3u8" }
};

const MAX_RADIOS = sizeof gRadios;

new gRadiosString[(MAX_RADIOS * 64 + 4) + 16];

enum E_VEHICLE_DATA
{
	Vehicle_Items[MAX_ITEMS],
	bool:Vehicle_IsBootUsed,
	Vehicle_ArrowObject,
	bool:Vehicle_IsBeaconsOn,

	Vehicle_FLBeacon,
	Vehicle_FRBeacon,
	Vehicle_RLBeacon,
	Vehicle_RRBeacon,

	Vehicle_RadioWave
};

new gVehicles[MAX_VEHICLES][E_VEHICLE_DATA];

enum E_PLAYER_DATA
{
	Player_Settings,
	Player_Name[MAX_PLAYER_NAME],
	Player_NameTag[MAX_PLAYER_NAME],
	Player_PasswordHash[64 + 1],
	Player_PasswordSalt[10 + 1],
	Player_Uid,
	Player_Gender,
	Player_Skin,
	Player_Ip[16 + 1],
	Player_PreviousClassid,
	Player_SkinsArrayIndex,
	Player_Money,
	Player_Exp,
	Player_CurrentInGameTime,
	Player_TotalInGameTime,
	Player_NameText,
	Float:Player_DeathPosX,
	Float:Player_DeathPosY,
	Float:Player_DeathPosZ,
	Float:Player_DeathPosA,
	Player_GlobalTimer,
	Player_DeathTimer,
	Player_DeathToken,
	Player_DeathActorid,
	Player_DeathTextid,
	Player_Debt,
	Player_OneSecondTimer,
	bool:Player_Achievements[MAX_ACHIEVEMENTS],
	Player_LastVendingUseTime,
	Player_Items[MAX_ITEMS],
	bool:Player_IsSpawned,
	bool:Player_IsLogged,
	bool:Player_IsDead,
	bool:Player_IsPassedOut,
	bool:Player_IsAnimPreloaded,
	bool:Player_IsVendingWarnShowed,

	bool:Player_IsCarryingSodaBox,
	bool:Player_IsCarryingSnackBox,

	bool:Player_IsCarryingVndngItmsBox,

	Player_Fraction,
	Player_Rank,
	bool:Player_IsLeader,

	Player_CBChannel,
};

new gPlayers[MAX_PLAYERS][E_PLAYER_DATA];
new empty_gPlayers[E_PLAYER_DATA];

enum
{
	FRACTION_NONE,
	FRACTION_LSPD
};

const MAX_FRACTIONS = 1;

new gFractionNames[][] = 
{
	"",
	"LSPD"
};

new gFractionRanks[][][32] = 
{
	{ "", "", "", "", "", "", "", "", "" },
	{ "", "Recruit", "Officer", "Sergeant", "Lieutenant", "Captain", "Colonel", "Sheriff Deputy", "Sheriff" }
};

new const MAX_RANKS[] = { 0, 8 };

new gFractionMaleSkins[][] = 
{
	{ -1, -1, -1, -1, -1, -1, -1, -1 },
	{ -1, 300, 280, 281, 311, 310, 302, 282, 283 }
};

new gFractionFemaleSkins[][] = 
{
	{ -1, -1, -1, -1, -1, -1, -1, -1 },
	{ -1, 306, 306, 306, 306, 306, 306, 306, 309 }
};

new DB:dbHandle;

new const 
			Float:DEFAULT_SPAWN_X = 821.0570,
			Float:DEFAULT_SPAWN_Y = -1341.5322,
			Float:DEFAULT_SPAWN_Z = 13.5207,
			Float:DEFAULT_SPAWN_A = 90.0;

new const 
			SKINS_MALE[] = 		{ 2, 6, 7, 21, 22, 24, 36, 48, 67 },
			SKINS_FEMALE[] = 	{ 13, 65, 69, 192, 193, 195, 226 };

enum 
{
	PLAYER_GENDER_FEMALE = 0,
	PLAYER_GENDER_MALE
};

enum 
{
	DIALOG_CAPTION,
	DIALOG_INFO,
	DIALOG_BUTTON_1,
	DIALOG_BUTTON_2
};

new const DIALOG_REGISTRATION_STRING[][] = {
	""H_COLOR_WHITE"Регистрация "H_COLOR_GREEN"(1/2)",
	""H_COLOR_WHITE"\nДобро пожаловать на сервер! Ваш аккаунт не зарегистрирован.\nДля регистрации придумайте и введите Ваш пароль в поле ниже.\n\n\
	Примечания:\n\n- Пароль может быть длиной от 6 до 32 символов\n- Пароль может содержать как латиницу, так и кирилицу\
	\n- Пароль может содержать любые символы\n\n",
	""H_COLOR_WHITE"Далее",
	""H_COLOR_RED"Отмена"
};

new const DIALOG_SELECT_GENDER_STRING[][] = {
	""H_COLOR_WHITE"Регистрация "H_COLOR_GREEN"(2/2)",
	""H_COLOR_WHITE"\nВы можете отыгрывать как мужского, так и женского персонажа.\nВыберите желаемый пол персонажа, используя кнопки ниже\n\n\
	Примечания:\n\n- Пол персонажа нельзя будет изменить в дальнейшем\n- От Выбраного пола зависит скин персонажа, действия и т.д.\n\n",
	""H_COLOR_WHITE"Мужской",
	""H_COLOR_WHITE"Женский"
};

new const DIALOG_AUTHORIZATION_STRING[][] = {
	""H_COLOR_WHITE"Авторизация",
	""H_COLOR_WHITE"\nДобро пожаловать на сервер!\nВаш аккаунт зарегистрирован.\nДля входа введите Ваш пароль в поле ниже.\n\n",
	""H_COLOR_WHITE"Войти",
	""H_COLOR_RED"Отмена"
};

new currentPlayers[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... }, totalPlayers;

enum
{
	VENDING_TYPE_SODA,
	VENDING_TYPE_SNACK
};

enum E_VENDING_DATA
{
	Vending_Uid,
	Vending_Type,
	bool:Vending_IsOwned,
	Vending_Owner,
	Vending_Cash,
	Vending_ItemCount,
	Vending_ItemPrice,
	Float:Vending_PosX,
	Float:Vending_PosY,
	Float:Vending_PosZ,
	Float:Vending_PosRX,
	Float:Vending_PosRY,
	Float:Vending_PosRZ,

	bool:Vending_IsCreated,
	Vending_Objectid,
	Vending_Textid,
	Vending_Areaid
};

const MAX_VENDINGS = 100;

new gVendings[MAX_VENDINGS][E_VENDING_DATA];
new empty_gVendings[E_VENDING_DATA];
new totalVendings;

new DEFAULT_VENDING_MODELID[] = 	{ 1775, 1776 },
	DEFAULT_VENDING_NAME[][32] = 	{ "Автомат с содовой", "Автомат со снэками" },
	DEFAULT_VENDING_BUY_PRICE[] = 	{ 2550, 3800 },
	DEFAULT_VENDING_ITEM_PRICE[] = 	{ 1, 2 };

// new vendingItemsBuyPickup;

new gVehicleNames[][] = 
{ 
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perennial", "Sentinel", "Dumper", "Fire Truck", "Trashmaster", "Stretch", "Manana", 
   	"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", 
   	"Mr. Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", 
   	"Trailer 1", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", 
   	"Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", 
   	"Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", 
   	"Quadbike", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", 
   	"Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring Racer", "Sandking", 
   	"Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer 3", "Hotring Racer 2", "Bloodring Banger", 
   	"Rancher Lure", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stuntplane", "Tanker", "Roadtrain", "Nebula", 
   	"Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Towtruck", "Fortune", "Cadrona", "FBI Truck", 
   	"Willard", "Forklift", "Tractor", "Combine Harvester", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", 
   	"Bullet", "Clover", "Sadler", "Fire Truck Ladder", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility Van", 
   	"Nevada", "Yosemite", "Windsor", "Monster 2", "Monster 3", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", 
   	"Tahoma", "Savanna", "Bandito", "Freight Train Flatbed", "Streak Train Trailer", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", 
   	"AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer (Tanker Commando)", "Emperor", "Wayfarer", "Euros", "Hotdog", 
   	"Club", "Box Freight", "Trailer 3", "Andromada", "Dodo", "RC Cam", "Launch", "Police LS", "Police", "Police SF", "Police LV", "Police Ranger", 
   	"Ranger", "Picador", "S.W.A.T.", "Alpha", "Phoenix", "Glendale Damaged", "Sadler", "Sadler Damaged", "Baggage Trailer (covered)", 
   	"Baggage Trailer (Uncovered)", "Trailer (Stairs)", "Boxville Mission", "Farm Trailer", "Street Clean Trailer"
};

// new arrow;

new gHour, gMinute, gClockTimer;

enum
{
	METAL_GOLD,
	METAL_SILVER,
	METAL_PLATINUM,
	METAL_PALLADIUM
};

enum E_METAL_DATA
{
	Metal_Count,
	Metal_DefaultPrice,
	Metal_OldPrice,
	Metal_CurrentPrice,
	Metal_OldSales,
	Metal_CurrentSales,
	Float:Metal_CalculatedCost,
	Metal_Title[32],
	Metal_StockTitle[16]
};

new gMetals[][E_METAL_DATA] = 
{
	{ 0, 1700, 0, 0, 0, 0, 0.0, "Золото", "GLD" },
	{ 0, 25, 0, 0, 0, 0, 0.0, "Серебро", "SLVR" },
	{ 0, 970, 0, 0, 0, 0, 0.0, "Платина", "PLTNM" },
	{ 0, 2250, 0, 0, 0, 0, 0.0, "Палладий", "PLLDM" }
};

const MAX_METALS = sizeof gMetals;

new gMetals3DText,
	bool:isMetalBuyAviable = false;

#pragma unused isMetalBuyAviable

enum E_CREATE_VEHICLE_DATA
{
	modelid,
	Float:spawnPosX,
	Float:spawnPosY,
	Float:spawnPosZ,
	Float:rotation,
	mainColor,
	secondaryColor,
	respawnDelay
};

new gLSPDVehicles[][E_CREATE_VEHICLE_DATA] =
{
	{ 599, 1546.2800, -1667.9664, 5.9980, 89.4600, -1, -1, 100 },
	{ 599, 1546.3622, -1672.0637, 5.9980, 90.0000, -1, -1, 100 },
	{ 599, 1546.3984, -1676.1021, 5.9980, 88.9200, -1, -1, 100 },
	{ 599, 1546.3123, -1680.4230, 5.9980, 90.7800, -1, -1, 100 },
	{ 599, 1546.2764, -1684.6050, 5.9980, 88.8000, -1, -1, 100 },
	{ 596, 1583.5389, -1711.6639, 5.5944, -0.4200, -1, -1, 100 },
	{ 596, 1587.5378, -1711.5656, 5.5944, 0.3000, -1, -1, 100 },
	{ 596, 1591.3510, -1711.6300, 5.5944, 0.3000, -1, -1, 100 },
	{ 596, 1595.6510, -1711.5537, 5.5944, 0.3000, -1, -1, 100 },
	{ 426, 1578.6487, -1711.4916, 5.5944, -0.2400, -1, -1, 100 },
	{ 426, 1574.4731, -1711.5157, 5.5944, -0.7200, -1, -1, 100 },
	{ 426, 1570.4729, -1711.5176, 5.5944, 0.0000, -1, -1, 100 },
	{ 420, 1558.8254, -1711.5359, 5.5944, 0.0600, -1, -1, 100 },
	{ 427, 1538.8225, -1644.9321, 5.8749, 180.0000, -1, -1, 100 },
	{ 427, 1534.5834, -1644.9386, 5.8749, 179.4600, -1, -1, 100 },
	{ 427, 1530.6472, -1644.8917, 5.8749, 180.1200, -1, -1, 100 },
	{ 427, 1526.8676, -1644.9066, 5.8749, 179.5200, -1, -1, 100 },
	{ 523, 1548.4662, -1650.8915, 5.3613, 179.0400, -1, -1, 100 },
	{ 523, 1546.9873, -1650.8362, 5.3613, 179.8200, -1, -1, 100 },
	{ 523, 1545.4703, -1650.8167, 5.3613, 179.1000, -1, -1, 100 },
	{ 523, 1543.9092, -1650.8462, 5.3613, 178.8600, -1, -1, 100 },
	{ 523, 1542.4874, -1650.8683, 5.3613, 179.6400, -1, -1, 100 },
	{ 523, 1542.4181, -1655.0465, 5.3613, 178.2601, -1, -1, 100 },
	{ 523, 1543.9570, -1655.0725, 5.3613, 179.2800, -1, -1, 100 },
	{ 523, 1545.5653, -1655.0569, 5.3613, 177.4201, -1, -1, 100 },
	{ 523, 1547.0192, -1655.1542, 5.3613, 178.6801, -1, -1, 100 },
	{ 523, 1548.4211, -1655.1068, 5.3613, 178.0801, -1, -1, 100 },
	{ 437, 1534.6301, -1666.2716, 5.8631, 180.0000, -1, -1, 100 },
	{ 596, 1602.5007, -1704.2838, 5.5944, 90.0000, -1, -1, 100 },
	{ 596, 1602.4642, -1700.1063, 5.5944, 90.4800, -1, -1, 100 },
	{ 596, 1602.5886, -1696.2074, 5.5944, 89.1600, -1, -1, 100 },
	{ 596, 1602.5769, -1692.0806, 5.5944, 89.8200, -1, -1, 100 },
	{ 596, 1602.5621, -1687.8308, 5.5944, 89.3400, -1, -1, 100 },
	{ 596, 1602.6427, -1684.1614, 5.5944, 90.1200, -1, -1, 100 },
	{ 601, 1528.8585, -1687.9762, 5.6332, 270.1800, -1, -1, 100 },
	{ 528, 1528.4535, -1683.9047, 5.8847, 270.0000, -1, -1, 100 }
};

new gLSPDVehicle[sizeof gLSPDVehicles];

enum
{
	CAR_POLICE_LS,
	CAR_POLICE_RANGER,
	CAR_POLICE_ENFORCER
};

new Float:gLightBeaconsPos[][][] =
{
	{
		{ -0.52900, -0.38400, 0.97380 },
		{ 0.4910, -0.3840, 0.9738 },
		{ 0.4085, 2.4057, -0.0464 },
		{ -0.4315, 2.4057, -0.0464 }
	},
	{
		{ -0.4766, 0.0405, 1.2158 },
		{ 0.5034, 0.0405, 1.2158 },
		{ -0.5715, 2.4657, -0.0464 },
		{ 0.5885, 2.4657, -0.0464 }
	},
	{
		{ -0.3486, 1.1262, 1.5018 },
		{ 0.3314, 1.1262, 1.5018 },
		{ -1.1748, -3.8145, -0.3166 },
		{ 1.1738, -3.8241, -0.3166 }
	}
};

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

stock bool:IsBeaconLightsAviable(vehicleid)
{
	new vehiclemodel = GetVehicleModel(vehicleid);

	switch(vehiclemodel)
	{
		case 427, 596, 599: return true;
		default: return false;
	}
	return false;
}

stock bool:IsVehicleRadioAviable(vehicleid)
{
	new bool:isAviable = false;

	new vehiclemodel = GetVehicleModel(vehicleid);

	switch(vehiclemodel)
	{
		case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 
		425, 417, 487, 488, 497, 563, 447, 469, 472, 473, 493, 595, 484, 
		430, 453, 452, 446, 454, 581, 509, 781, 462, 521, 463, 510, 522, 
		461, 448, 468, 586, 485, 523, 432, 601, 572: isAviable = false;
		default: isAviable = true;
	}

	return isAviable;
}

@_GLOBAL_TIMER();
@_GLOBAL_TIMER()
{
	SetTimer("@_GLOBAL_TIMER", 250, false);
	new currentTime = gettime();

	if(gClockTimer <= currentTime && gClockTimer != 0)
	{
		gClockTimer = currentTime + 1;

		gMinute++;

		if(gMinute == 60) gHour++, gMinute = 0;
		if(gHour == 24) gHour = 0;

		foreach(i) SetPlayerTime(i, gHour, gMinute);

		// if(gHour == 0 && gMinute == 0) UpdateMetalPrice();

		if(gMinute % 10 == 0) UpdateMetalPrice();
		// if(gHour == 15 && gMinute == 0) UpdateMetalPrice();

		// if(gHour == 10 && gMinute == 15) 
		// 	SendClientMessageToAll(COLOR_GREEN, "AMEX: "H_COLOR_WHITE"Утренние торги по ценным металлам начнутся через 15 минут.");
		// if(gHour == 14 && gMinute == 45) 
		// 	SendClientMessageToAll(COLOR_GREEN, "AMEX: "H_COLOR_WHITE"Вечерние торги по ценным металлам начнутся через 15 минут.");
	}
	return 1;
}

@_PLAYER_TIMER(playerid);
@_PLAYER_TIMER(playerid)
{
	gPlayers[playerid][Player_GlobalTimer] = -1;
	gPlayers[playerid][Player_GlobalTimer] = SetTimerEx("@_PLAYER_TIMER", 250, false, "i", playerid);
	new currentTime = gettime();

	if(gPlayers[playerid][Player_OneSecondTimer] <= currentTime && gPlayers[playerid][Player_OneSecondTimer] != 0)
	{
		gPlayers[playerid][Player_OneSecondTimer] = currentTime + 1;
		gPlayers[playerid][Player_CurrentInGameTime]++;
	}

	if(gPlayers[playerid][Player_DeathTimer] <= currentTime && gPlayers[playerid][Player_DeathTimer] != 0)
	{
		gPlayers[playerid][Player_DeathTimer] = 0;

		SendClientMessage(playerid, -1, "Вас никто не возродил");

		// if(ChangePlayerMoney(playerid, -HOSPITALIZATION_PRICE) == 0)
		//  ChangePlayerMoney(playerid, -gPlayers[playerid][Player_Money]);

		// if(gPlayers[playerid][Player_Money] == 0)
		// {
		// 	gPlayers[playerid][Player_Debt] += 250;

		// 	SendClientMessage(playerid, -1, "Государством было оплачено "H_COLOR_GREEN"$250");
		// 	SendClientMessageEx(playerid, -1, "Теперь ваш долг составляет "H_COLOR_GREEN"$%i", gPlayers[playerid][Player_Debt]);
		// }
		// else 
		// {
		// 	SendClientMessageEx(playerid, -1, "За услуги госпитализации с вас взяли "H_COLOR_GREEN" $%i", HOSPITALIZATION_PRICE);

		// 	if(HOSPITALIZATION_PRICE != 250)
		// 	{
		// 		HOSPITALIZATION_PRICE = 250 - HOSPITALIZATION_PRICE;
		// 		SendClientMessageEx(playerid, -1, "Государством было оплачено "H_COLOR_GREEN"$%i", HOSPITALIZATION_PRICE);
		// 		gPlayers[playerid][Player_Debt] += HOSPITALIZATION_PRICE;
		// 		SendClientMessageEx(playerid, -1, "Теперь ваш долг составляет "H_COLOR_GREEN"$%i", gPlayers[playerid][Player_Debt]);
		// 	}
		// }

		SetPlayerHealth(playerid, 100.0);

		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, 1182.3363, -1323.8298, 13.5797);
		SetPlayerFacingAngle(playerid, 270.0);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, true);

		gPlayers[playerid][Player_IsDead] = false;
		gPlayers[playerid][Player_IsPassedOut] = false;

		DestroyDynamicActor(gPlayers[playerid][Player_DeathActorid]);
		DestroyDynamic3DTextLabel(gPlayers[playerid][Player_DeathTextid]);

		gPlayers[playerid][Player_DeathActorid] = -1;
		gPlayers[playerid][Player_DeathTextid] = -1;
		gPlayers[playerid][Player_DeathToken] = -1;
	}
	return 1;
}

public OnGameModeInit()
{
	dbHandle = db_open("data.db");	

	if(dbHandle != DB:0) print("SQLite: подключено");
	else print("SQLite: ошибка"), SendRconCommand("exit");

	SetGameModeText("werio");

	AddPlayerClass(7, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, DEFAULT_SPAWN_A, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(7, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, DEFAULT_SPAWN_A, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(7, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, DEFAULT_SPAWN_A, 0, 0, 0, 0, 0, 0);

	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	ManualVehicleEngineAndLights();
	LimitPlayerMarkerRadius(50.0);
	EnableStuntBonusForAll(false);
	DisableInteriorEnterExits();
	ShowNameTags(0);

	SetTimer("@_GLOBAL_TIMER", 250, false);

	CreateDynamicPickup(19198, 23, 2171.7600, -2262.9177, 13.3237);
	CreateDynamic3DTextLabel("Продажа напитков и закусок\n\"ALT\" для взаимодействия", 
		DEFAULT_3D_TEXT_COLOR, 2171.7600, -2262.9177, 13.3237, DEFAULT_DRAW_DISTANCE);

	// arrow = CreateDynamicObject(19134, 807.6777,-1336.8499,13.5469, 0.0, 90.0, 0.0);

	gHour = 10;
	gMinute = 0;
	gClockTimer = gettime() + 1;

	// LoadVendings();
	LoadMetalPrice();

	CreateFractionVehicles(FRACTION_LSPD);

	new Float:interiorEnterPos[][] = 
	{
		{ 1555.3005, -1675.5986, 16.1953 },
		{ 1568.6495, -1689.9702, 6.2188 },
		{ 1481.0411, -1772.3118, 18.7958 }
	};

	new Float:interiorExitPos[][] = 
	{
		{ 246.7776, 62.3232, 1003.6406 },
		{ 246.3997, 88.0091, 1003.6406 },
		{ 390.7695, 173.8212, 1008.3828 }
	};

	for(new i = 0; i != sizeof interiorEnterPos; i++)

		CreateDynamic3DTextLabel("Нажмите \"F\",\nчтобы войти", 
			DEFAULT_3D_TEXT_COLOR, 
			interiorEnterPos[i][0], 
			interiorEnterPos[i][1], 
			interiorEnterPos[i][2], 
			DEFAULT_DRAW_DISTANCE
		);

	for(new i = 0; i != sizeof interiorExitPos; i++)

		CreateDynamic3DTextLabel("Нажмите \"F\",\nчтобы выйти", 
			DEFAULT_3D_TEXT_COLOR, 
			interiorExitPos[i][0], 
			interiorExitPos[i][1], 
			interiorExitPos[i][2], 
			DEFAULT_DRAW_DISTANCE
		);

	// LSPD раздевалка
	CreateDynamicPickup(1275, 23, 254.3685, 77.6037, 1003.6406);
	CreateDynamic3DTextLabel("Нажмите \"F\",\nчтобы переодеться", DEFAULT_3D_TEXT_COLOR, 254.3685, 77.6037, 1003.6406, DEFAULT_DRAW_DISTANCE);

	CreateDynamicMapIcon(1555.3005, -1675.5986, 16.1953, 30, 0); // LSPD
	CreateDynamicMapIcon(1481.0411, -1772.3118, 18.7958, 19, 0); // Мэрия

	for(new i = 0; i != MAX_RADIOS; i++) 
		format(gRadiosString, sizeof gRadiosString, "%s%s\t%s\n", gRadiosString, gRadios[i][Radio_Title], gRadios[i][Radio_Genre]);

	strins(gRadiosString, "Радиостанция\tЖанр\n", 0);
	return 1;
}

stock CreateFractionVehicles(fractionid)
{
	new numberplate[7], numberplateColored[20];

	switch(fractionid)
	{
		case FRACTION_LSPD:
		{
			for(new i = 0; i != sizeof gLSPDVehicles; i++)
			{
				gLSPDVehicle[i] = CreateVehicle(
					gLSPDVehicles[i][modelid], 
					gLSPDVehicles[i][spawnPosX], 
					gLSPDVehicles[i][spawnPosY], 
					gLSPDVehicles[i][spawnPosZ], 
					gLSPDVehicles[i][rotation], 
					75, 138, 
					-1, 
					1
				);

				for(new j = 0; j != 6; j++)
				{
					numberplate[j] = rand(65, 90);
					if(random(2)) numberplate[j] = rand(48, 57);
				}

				if(random(2)) numberplate[3] = 32;

				numberplate[6] = EOS;

				format(numberplateColored, sizeof numberplateColored, "{000000}%s", numberplate);

				SetVehicleNumberPlate(gLSPDVehicle[i], numberplateColored);
				SetVehicleToRespawn(gLSPDVehicle[i]);
			}	
		}
	}
	return 1;
}

public OnGameModeExit()
{
	SaveMetalPrice();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(bool:gPlayers[playerid][Player_IsSpawned] == TRUE)
	{
		SetSpawnInfo(playerid, NO_TEAM, gPlayers[playerid][Player_Skin], 
			DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, DEFAULT_SPAWN_A, 
			0, 0, 0, 0, 0, 0
		);

		SpawnPlayer(playerid);
		return 1;
	}

	SetPlayerInterior(playerid, 14);
	SetPlayerPos(playerid, 259.3214, -41.5247, 1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid, 256.5642, -39.5611, 1003.2145);
	SetPlayerCameraLookAt(playerid, 257.2122, -40.3208, 1002.9697);

	new previousClassID = gPlayers[playerid][Player_PreviousClassid];
	new arrayIndex = gPlayers[playerid][Player_SkinsArrayIndex];
	new gender = gPlayers[playerid][Player_Gender];

	switch(classid)
	{
		case 0: arrayIndex = previousClassID == 2 ? ++arrayIndex : --arrayIndex;
		case 1: arrayIndex = previousClassID == 0 ? ++arrayIndex : --arrayIndex;
		case 2: arrayIndex = previousClassID == 1 ? ++arrayIndex : --arrayIndex;
	}

	if(arrayIndex >= (gender ? sizeof SKINS_MALE : sizeof SKINS_FEMALE)) arrayIndex = 0;
	if(arrayIndex == -1) arrayIndex = (gender ? sizeof SKINS_MALE : sizeof SKINS_FEMALE) - 1;

	new skinid = gender ? SKINS_MALE[arrayIndex] : SKINS_FEMALE[arrayIndex];

	SetPlayerSkin(playerid, skinid);

	gPlayers[playerid][Player_PreviousClassid] = classid;
	gPlayers[playerid][Player_SkinsArrayIndex] = arrayIndex;
	gPlayers[playerid][Player_Skin] = skinid;
	return 1;
}

public OnPlayerConnect(playerid)
{
	TogglePlayerControllable(playerid, false);
	TogglePlayerSpectating(playerid, true);
	SetPlayerVirtualWorld(playerid, playerid + 1000);

	gPlayers[playerid] = empty_gPlayers;

	GetPlayerName(playerid, gPlayers[playerid][Player_Name], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, gPlayers[playerid][Player_Ip], enumSizeof(gPlayers, Player_Ip));

	if(!IsValidName(gPlayers[playerid][Player_Name]))
	{
		Kick(playerid);
		return 1;
	}

	strins(gPlayers[playerid][Player_NameTag], gPlayers[playerid][Player_Name], 0, MAX_PLAYER_NAME);
	new underscorePos = strfind(gPlayers[playerid][Player_NameTag], "_");
	gPlayers[playerid][Player_NameTag][underscorePos] = 32;

	new query[75 + MAX_PLAYER_NAME];
	format(query, sizeof query, "SELECT PASSWORD_HASH, PASSWORD_SALT FROM PLAYERS WHERE PLAYERNAME = '%q'", gPlayers[playerid][Player_Name]);

	new DBResult:dbResult;
	dbResult = db_query(dbHandle, query);

	if(db_num_rows(dbResult))
	{

		db_get_field_assoc(dbResult, "PASSWORD_HASH", gPlayers[playerid][Player_PasswordHash], enumSizeof(gPlayers, Player_PasswordHash));
	 	db_get_field_assoc(dbResult, "PASSWORD_SALT", gPlayers[playerid][Player_PasswordSalt], enumSizeof(gPlayers, Player_PasswordSalt));

	 	ShowPlayerDialog(playerid, DIALOG_AUTHORIZATION, DIALOG_STYLE_INPUT,
	 		DIALOG_AUTHORIZATION_STRING[DIALOG_CAPTION],
	 		DIALOG_AUTHORIZATION_STRING[DIALOG_INFO],
	 		DIALOG_AUTHORIZATION_STRING[DIALOG_BUTTON_1],
	 		DIALOG_AUTHORIZATION_STRING[DIALOG_BUTTON_2]
	 	);
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_REGISTRATION, DIALOG_STYLE_INPUT,
			DIALOG_REGISTRATION_STRING[DIALOG_CAPTION],
			DIALOG_REGISTRATION_STRING[DIALOG_INFO],
			DIALOG_REGISTRATION_STRING[DIALOG_BUTTON_1],
			DIALOG_REGISTRATION_STRING[DIALOG_BUTTON_2]
		);
	}
	db_free_result(dbResult);

	gPlayers[playerid][Player_NameText] = CreateDynamic3DTextLabel(playername(playerid), 
		DEFAULT_3D_TEXT_COLOR, 0.0, 0.0, 0.2, DEFAULT_DRAW_DISTANCE, playerid, .testlos = 1);

	gPlayers[playerid][Player_GlobalTimer] = SetTimerEx("@_PLAYER_TIMER", 250, false, "i", playerid);
	gPlayers[playerid][Player_OneSecondTimer] = gettime() + 1;

	gPlayers[playerid][Player_DeathActorid] = -1;
	gPlayers[playerid][Player_DeathTextid] = -1;
	gPlayers[playerid][Player_DeathToken] = -1;

	RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 20000.0); // CJ_EXT_SPRUNK
	RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 20000.0); // CJ_EXT_CANDY
	RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 20000.0); // vendmach
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 20000.0); // vendmachfd
	RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 20000.0); // CJ_SPRUNK1
	RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 20000.0); // CJ_CANDYVENDOR
	RemoveBuildingForPlayer(playerid, 1977, 0.0, 0.0, 0.0, 20000.0); // vendin3
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DestroyDynamic3DTextLabel(gPlayers[playerid][Player_NameText]);

	for(new i = totalPlayers; i != -1; i--)
	{
		if(currentPlayers[i] != playerid) continue;
		currentPlayers[i] = currentPlayers[totalPlayers];
		currentPlayers[totalPlayers--] = INVALID_PLAYER_ID;
		break;
	}

	if(gPlayers[playerid][Player_DeathActorid] != -1) DestroyDynamicActor(gPlayers[playerid][Player_DeathActorid]);
	if(gPlayers[playerid][Player_DeathTextid] != -1) DestroyDynamic3DTextLabel(gPlayers[playerid][Player_DeathTextid]);

	SavegPlayers(playerid);
	SavePlayerAchievements(playerid);
	SavePlayerItems(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(bool:gPlayers[playerid][Player_IsLogged] == FALSE) return Kick(playerid);

	if(bool:gPlayers[playerid][Player_IsAnimPreloaded] == FALSE)
	{
		gPlayers[playerid][Player_IsAnimPreloaded] = true;
		PreloadAnimations(playerid);
	}

	if(bool:gPlayers[playerid][Player_IsDead] == TRUE)
	{
		if(bool:gPlayers[playerid][Player_IsPassedOut] == FALSE)
			SendClientMessage(playerid, -1, "От болевого шока вы потеряли сознание. Вас еще могут спасти, использовав дефибрилятор.");

		gPlayers[playerid][Player_IsDead] = false;
		gPlayers[playerid][Player_IsPassedOut] = true;

		SetPlayerPos(playerid, 
			gPlayers[playerid][Player_DeathPosX], 
			gPlayers[playerid][Player_DeathPosY], 
			gPlayers[playerid][Player_DeathPosZ] - 10.0
		);

		TogglePlayerControllable(playerid, false);

		SetPlayerHealth(playerid, INFINITY);

		SetPlayerCameraPos(playerid,
			gPlayers[playerid][Player_DeathPosX], 
			gPlayers[playerid][Player_DeathPosY], 
			gPlayers[playerid][Player_DeathPosZ] - 0.9
		);

		SetPlayerCameraLookAt(playerid,
			gPlayers[playerid][Player_DeathPosX], 
			gPlayers[playerid][Player_DeathPosY], 
			gPlayers[playerid][Player_DeathPosZ] + 10.0,
			CAMERA_CUT
		);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	gPlayers[playerid][Player_IsDead] = true;

	if(bool:gPlayers[playerid][Player_IsPassedOut] == TRUE) return 1;

	GetPlayerPos(playerid, 
		gPlayers[playerid][Player_DeathPosX], 
		gPlayers[playerid][Player_DeathPosY], 
		gPlayers[playerid][Player_DeathPosZ]
	);
	GetPlayerFacingAngle(playerid, gPlayers[playerid][Player_DeathPosA]);

	new textString[10 + 3 + 1];
	format(textString, sizeof textString, "/revive %i", playerid);

	gPlayers[playerid][Player_DeathTextid] = CreateDynamic3DTextLabel(textString, DEFAULT_3D_TEXT_COLOR, 
		gPlayers[playerid][Player_DeathPosX], gPlayers[playerid][Player_DeathPosY], gPlayers[playerid][Player_DeathPosZ] - 0.8,
		DEFAULT_DRAW_DISTANCE, .testlos = 1
	);

	new skinid = GetPlayerSkin(playerid);

	gPlayers[playerid][Player_DeathActorid] = CreateDynamicActor(skinid,
		gPlayers[playerid][Player_DeathPosX], gPlayers[playerid][Player_DeathPosY], gPlayers[playerid][Player_DeathPosZ], 
		gPlayers[playerid][Player_DeathPosA]
	);

	ApplyDynamicActorAnimation(gPlayers[playerid][Player_DeathActorid], "CRACK", "CRCKIDLE2", 4.1, true, true, true, true, 0);

	gPlayers[playerid][Player_DeathTimer] = gettime() + 15;

	gPlayers[playerid][Player_DeathToken] = rand(111111, 999999);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new atSymbolPos = strfind(text, "@"),
		spacePos = -1,
		bool:isValid = true;

	if(atSymbolPos != -1)
	{
		for(new i = atSymbolPos; i != strlen(text); i++)
		{
			switch(text[i])
			{
				case 48..57: continue;
				case 32, EOS:
				{
					spacePos = i;
					break;
				}
				default:
				{
					isValid = false;
					break;
				}
			}
		}

		if(spacePos - atSymbolPos == 0) isValid = false;
		if(spacePos - atSymbolPos >= 4) isValid = false;

		if(isValid == TRUE)
		{
			new targetid,
				targetidString[5];
			strmid(targetidString, text, atSymbolPos + 1, spacePos);

			targetid = strval(targetidString);

			if(targetid != INVALID_PLAYER_ID && IsPlayerConnected(targetid))
			{
				strdel(text, atSymbolPos, spacePos);
				strins(text, playername(targetid), atSymbolPos, 144);
			}
		}
	}

	

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	
	foreach(i)
	{
		if(!IsPlayerInRangeOfPoint(i, DEFAULT_DRAW_DISTANCE, x, y, z)) continue;
		if(GetPlayerInterior(playerid) != GetPlayerInterior(i)) continue;
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;
		SendClientMessageEx(i, COLOR_WHITE, "- %s, "H_COLOR_GRAY"сказал %s", text, playername(playerid));
	}

	SetPlayerChatBubble(playerid, text, DEFAULT_3D_TEXT_COLOR, DEFAULT_DRAW_DISTANCE, DEFAULT_EXPIRE_TIME);
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	// printf("%i %i %i", playerid, vehicleid, ispassenger);
	// if((gLSPDVehicle[0] <= vehicleid <= gLSPDVehicle[sizeof gLSPDVehicle - 1]) && gPlayers[playerid][Player_Fraction] == FRACTION_LSPD)
	// {
	// 	new engine, lights, alarm, doors, bonnet, boot, objective;
	// 	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	// 	SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);

	// 	SetPlayerChatBubble(playerid, "открыл(-а) служебный автомобиль", COLOR_PINK, DEFAULT_DRAW_DISTANCE, DEFAULT_EXPIRE_TIME);
	// }
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	// if((gLSPDVehicle[0] <= vehicleid <= gLSPDVehicle[sizeof gLSPDVehicle - 1]) && gPlayers[playerid][Player_Fraction] == FRACTION_LSPD)
	// {
	// 	new engine, lights, alarm, doors, bonnet, boot, objective;
	// 	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	// 	SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);

	// 	SetPlayerChatBubble(playerid, "закрыл(-а) служебный автомобиль", COLOR_PINK, DEFAULT_DRAW_DISTANCE, DEFAULT_EXPIRE_TIME);
	// }
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_ONFOOT)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsVehicleRadioAviable(vehicleid) == true && gVehicles[vehicleid][Vehicle_RadioWave] == -1) 
			SendClientMessage(playerid, COLOR_GRAY, "В этом автомобиле доступно радио. Используйте команду /radio");
	}

	if((newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) && oldstate == PLAYER_STATE_ONFOOT)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsVehicleRadioAviable(vehicleid) == true && gVehicles[vehicleid][Vehicle_RadioWave] != -1)
		{
			SendClientMessage(playerid, COLOR_GRAY, "В этом автомобиле играет радио. Если Вы не слышите его - проверьте настройки звука игры");
			PlayAudioStreamForPlayer(playerid, gRadios[gVehicles[vehicleid][Vehicle_RadioWave]][Radio_Url]);
		}
	}

	if(newstate == PLAYER_STATE_ONFOOT && (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER))
	{
		StopAudioStreamForPlayer(playerid);
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	SetSpawnInfo(playerid, NO_TEAM, gPlayers[playerid][Player_Skin], 
		DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, DEFAULT_SPAWN_A, 
		0, 0, 0, 0, 0, 0
	);

	SpawnPlayer(playerid);

	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetCameraBehindPlayer(playerid);

	gPlayers[playerid][Player_IsSpawned] = true;

	new query[56 + 3 + 1 + 9 + 1];
	format(query, sizeof query, "UPDATE PLAYERS SET SKIN = %i, GENDER = %i WHERE UID = %i",
		gPlayers[playerid][Player_Skin],
		gPlayers[playerid][Player_Gender],
		gPlayers[playerid][Player_Uid]
	);
	db_free_result(db_query(dbHandle, query));
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, STREAMER_TAG_PICKUP:pickupid)
{
	// if(pickupid == vendingItemsBuyPickup)
	// {
	// 	if(gPlayers[playerid][Player_IsCarryingVndngItmsBox] == TRUE) return
	// 		SendClientMessage(playerid, COLOR_RED, "Вы что-то держите в руках");

	// 	ShowPlayerDialog(playerid, DIALOG_BUY_ITEMS_FOR_VENDING, DIALOG_STYLE_TABLIST_HEADERS, "Что Вы хотите приобрести?", 
	// 		"Описание\tКол-во в коробке\tСтоимость\n
	// 		Содовая Sprunk\t36\t$15\n
	// 		Снэки Cokopops\t50\t$18", 
	// 		"Купить", "Закрыть"
	// 	);
	// }
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	
	if(IsKeyPressed(KEY_SUBMISSION) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);

		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		if(engine == VEHICLE_PARAMS_UNSET) engine = VEHICLE_PARAMS_OFF;

		if(engine == VEHICLE_PARAMS_OFF && gLSPDVehicle[0] <= vehicleid <= gLSPDVehicle[sizeof gLSPDVehicle - 1])
		{
			if(gPlayers[playerid][Player_Fraction] != FRACTION_LSPD) return
				SendClientMessage(playerid, COLOR_RED, "У Вас нет ключей от этого транспорта");
		}

		engine = !engine;
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	}

	if(IsKeyPressed(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2171.7600, -2262.9177, 13.3237))
		{
			if(gPlayers[playerid][Player_IsCarryingVndngItmsBox] == TRUE) return
				SendClientMessage(playerid, COLOR_RED, "Вы что-то держите в руках");

			ShowPlayerDialog(playerid, DIALOG_BUY_ITEMS_FOR_VENDING, DIALOG_STYLE_TABLIST_HEADERS, "Что Вы хотите приобрести?", 
				"Описание\tКол-во в коробке\tСтоимость\n\
				Содовая Sprunk\t36\t$15\n\
				Снэки Cokopops\t50\t$18", 
				"Купить", "Закрыть"
			);			
		}
	}

	if(IsKeyPressed(KEY_CTRL_BACK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		new vendingid = GetPlayerVendingid(playerid);

		if(vendingid == -1) return 1;

		if(gPlayers[playerid][Player_LastVendingUseTime] > gettime())
		{
			if(bool:gPlayers[playerid][Player_IsVendingWarnShowed] == FALSE)
			{
				SendClientMessage(playerid, COLOR_RED, "Вы можете воспользоваться вендинговым автоматом один раз в 10 секунд");
				gPlayers[playerid][Player_IsVendingWarnShowed] = true;
			}
			return 1;
		}

		gPlayers[playerid][Player_LastVendingUseTime] = gettime() + 10;
		gPlayers[playerid][Player_IsVendingWarnShowed] = false;

		if(gVendings[vendingid][Vending_IsOwned] == FALSE) return
			SendClientMessage(playerid, COLOR_RED, "Этим вендинговым автоматом нельзя воспользоваться");

		if(gVendings[vendingid][Vending_ItemCount] == 0) return
			SendClientMessage(playerid, COLOR_RED, "Этот вендинговый автомат временно неработает");

		if(!ChangePlayerMoney(playerid, -gVendings[vendingid][Vending_ItemPrice])) return
			SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег");

		if(chance(5)) return
			SendClientMessageEx(playerid, -1, "Вендинговый автомат не выдал %s и забрал деньги",
				gVendings[vendingid][Vending_Type] ? "снэк" : "содовую"
			);

		SendClientMessageEx(playerid, COLOR_GREEN, "Вы купили %s в вендинговом автомате за $%i",
			gVendings[vendingid][Vending_Type] ? "снэк" : "содовую",
			gVendings[vendingid][Vending_ItemPrice]
		);

		new textString[34 + MAX_PLAYER_NAME + 7 + 1];
		format(textString, sizeof textString, "%s купил(-а) %s в вендинговом автомате", 
			playername(playerid),  gVendings[vendingid][Vending_Type] ? "снэк" : "содовую");

		SendRPMessage(playerid, textString);

		format(textString, sizeof textString, "купил(-а) %s в вендинговом автомате", 
			gVendings[vendingid][Vending_Type] ? "снэк" : "содовую");

		SetPlayerChatBubble(playerid, textString, COLOR_PINK, DEFAULT_DRAW_DISTANCE, DEFAULT_EXPIRE_TIME);

		gVendings[vendingid][Vending_ItemCount]--;

		new Float:angle = gVendings[vendingid][Vending_PosRZ];
		SetPlayerFacingAngle(playerid, angle);
	}
	// if(IsKeyPressed(KEY_YES & KEY_CTRL_BACK))
	if ((newkeys & (KEY_YES | KEY_CTRL_BACK)) == (KEY_YES | KEY_CTRL_BACK) && (oldkeys & (KEY_YES | KEY_CTRL_BACK)) != (KEY_YES | KEY_CTRL_BACK))
	{
		SendClientMessage(playerid, COLOR_GREEN, "A B O B A");
		PC_EmulateCommand(playerid, "/pickup");
	}

	if(IsKeyPressed(KEY_SECONDARY_ATTACK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		const 	Float:DEFAULT_ENTER_RANGE = 5.0,
				DEFAULT_VIRTUAL_WOLRD = 200;

		new bool:isDressingRoom;

		// LSPD вход с улицы
		if(IsPlayerInRangeOfPoint(playerid, DEFAULT_ENTER_RANGE, 1555.3005, -1675.5986, 16.1953))
		{
			SetPlayerPos(playerid, 246.7776, 62.3232, 1003.6406);
			SetPlayerFacingAngle(playerid, 0.0);
			SetPlayerInterior(playerid, 6);
			SetPlayerVirtualWorld(playerid, DEFAULT_VIRTUAL_WOLRD);
		}

		// LSPD выход с участка
		if(IsPlayerInRangeOfPoint(playerid, DEFAULT_ENTER_RANGE, 246.7776, 62.3232, 1003.6406))
		{
			SetPlayerPos(playerid, 1555.3005, -1675.5986, 16.1953);
			SetPlayerFacingAngle(playerid, 90.0);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
		}

		// LSPD выход с участка в гараж
		if(IsPlayerInRangeOfPoint(playerid, DEFAULT_ENTER_RANGE, 246.3997, 88.0091, 1003.6406))
		{
			SetPlayerPos(playerid, 1568.6495, -1689.9702, 6.2188);
			SetPlayerFacingAngle(playerid, 180.0);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
		}

		// LSPD вход с гаража в участок
		if(IsPlayerInRangeOfPoint(playerid, DEFAULT_ENTER_RANGE, 1568.6495, -1689.9702, 6.2188))
		{
			SetPlayerPos(playerid, 246.3997, 88.0091, 1003.6406);
			SetPlayerFacingAngle(playerid, 180.0);
			SetPlayerInterior(playerid, 6);
			SetPlayerVirtualWorld(playerid, DEFAULT_VIRTUAL_WOLRD);
		}

		if(IsPlayerInRangeOfPoint(playerid, DEFAULT_ENTER_RANGE, 254.3685, 77.6037, 1003.6406))
		{
			if(gPlayers[playerid][Player_Fraction] != FRACTION_LSPD) return 1;

			isDressingRoom = true;

			new playerRank = gPlayers[playerid][Player_Rank],
				textString[39 + MAX_PLAYER_NAME];

			if(GetPlayerSkin(playerid) != gPlayers[playerid][Player_Skin])
			{
				SetPlayerSkin(playerid, gPlayers[playerid][Player_Skin]);
				format(textString, sizeof textString, "%s переоделся(-ась) в гражданскую одежду", playername(playerid));
			}
			else 
			{
				SetPlayerSkin(playerid, 
					gPlayers[playerid][Player_Gender] ? gFractionMaleSkins[FRACTION_LSPD][playerRank] : gFractionFemaleSkins[FRACTION_LSPD][playerRank]
				);

				format(textString, sizeof textString, "%s переоделся(-ась) в рабочую форму", playername(playerid));
			}

			SendRPMessage(playerid, textString);
			
		}

		// Мэрия вход
		if(IsPlayerInRangeOfPoint(playerid, DEFAULT_ENTER_RANGE, 1481.0411, -1772.3118, 18.7958))
		{
			SetPlayerPos(playerid, 390.7695, 173.8212, 1008.3828);
			SetPlayerFacingAngle(playerid, 90.0);
			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, DEFAULT_VIRTUAL_WOLRD);
		}

		// Мэрия выход
		if(IsPlayerInRangeOfPoint(playerid, DEFAULT_ENTER_RANGE, 390.7695, 173.8212, 1008.3828))
		{
			SetPlayerPos(playerid, 1481.0411, -1772.3118, 18.7958);
			SetPlayerFacingAngle(playerid, 0.0);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
		}	

		if(!isDressingRoom) SetCameraBehindPlayer(playerid);
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	// new Float:x, Float:y, Float:z;
	// GetPlayerPos(playerid, x, y, z);

	// new Float:objX, Float:objY, Float:objZ;
	// GetDynamicObjectPos(arrow, objX, objY, objZ);

	// new quart;

	// if(x > objX && y > objY) quart = 1;
	// if(x > objX && y < objY) quart = 2;
	// if(x < objX && y < objY) quart = 3;
	// if(x < objX && y > objY) quart = 4;

	// SendClientMessageEx(playerid, COLOR_GREEN, "QUART %i", quart);

	// new Float:a, Float:b, Float:angle;

	// switch(quart)
	// {
	// 	case 1:
	// 	{
	// 		a = y - objY;
	// 		b = x - objX;
	// 		angle = atan(b / a);
	// 	}
	// 	case 2:
	// 	{
	// 		a = x - objX;
	// 		b = objY - y;
	// 		angle = atan(b / a) + 90.0;
	// 	}
	// 	case 3:
	// 	{
	// 		a = objY - y;
	// 		b = objX - x;
	// 		angle = atan(b / a) + 180.0;
	// 	}
	// 	case 4:
	// 	{
	// 		a = x - objX;
	// 		b = objY - y;
	// 		angle = atan(b / a) + 270.0;
	// 	}
	// }

	// SendClientMessageEx(playerid, COLOR_GREEN, "ANGLE %f", angle);

	// angle = (angle * (-1)) + 90.0;

	// SetDynamicObjectRot(arrow, 0.0, 90.0, angle);
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_REGISTRATION:
		{
			if(!response) return Kick(playerid);


			if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
			{
				SendClientMessage(playerid, COLOR_RED, "Пароль может быть длиной от 6 до 32 символов");

				ShowPlayerDialog(playerid, DIALOG_REGISTRATION, DIALOG_STYLE_INPUT,
					DIALOG_REGISTRATION_STRING[DIALOG_CAPTION],
					DIALOG_REGISTRATION_STRING[DIALOG_INFO],
					DIALOG_REGISTRATION_STRING[DIALOG_BUTTON_1],
					DIALOG_REGISTRATION_STRING[DIALOG_BUTTON_2]
				);

				return 1;
			}

			for(new i = 0; i != 10; i++)
			{
				switch(rand(1, 6))
				{
					case 1: gPlayers[playerid][Player_PasswordSalt][i] = rand(48, 57);
					case 2: gPlayers[playerid][Player_PasswordSalt][i] = rand(33, 47);
					case 3: gPlayers[playerid][Player_PasswordSalt][i] = rand(65, 90);
					case 4: gPlayers[playerid][Player_PasswordSalt][i] = rand(97, 122);
					case 5: gPlayers[playerid][Player_PasswordSalt][i] = rand(58, 64);
					case 6: gPlayers[playerid][Player_PasswordSalt][i] = rand(123, 126);
					default: gPlayers[playerid][Player_PasswordSalt][i] = rand(91, 95);
				}
			}

			SHA256_PassHash(
				inputtext, 
				gPlayers[playerid][Player_PasswordSalt], gPlayers[playerid][Player_PasswordHash], 
				enumSizeof(gPlayers, Player_PasswordHash)
			);

			gPlayers[playerid][Player_Uid] = GeneratePlayerUid();
			gPlayers[playerid][Player_Gender] = PLAYER_GENDER_MALE;
			gPlayers[playerid][Player_Skin] = SKINS_MALE[random(sizeof SKINS_MALE)];

			new query[160 + 9 + MAX_PLAYER_NAME + 64 + 10 + 1 + 3 + 16 + 16 + 1];
			format(query, sizeof query, "INSERT INTO \
				PLAYERS (UID, PLAYERNAME, PASSWORD_HASH, PASSWORD_SALT, GENDER, SKIN, REG_IP, LAST_IP) \
				VALUES (%i, '%q', '%q', '%q', %i, %i, '%q', '%q')",
				gPlayers[playerid][Player_Uid],
				gPlayers[playerid][Player_Name],
				gPlayers[playerid][Player_PasswordHash],
				gPlayers[playerid][Player_PasswordSalt],
				gPlayers[playerid][Player_Gender],
				gPlayers[playerid][Player_Skin],
				gPlayers[playerid][Player_Ip],
				gPlayers[playerid][Player_Ip]
			);

			db_free_result(db_query(dbHandle, query));

			ShowPlayerDialog(playerid, DIALOG_SELECT_GENDER, DIALOG_STYLE_MSGBOX,
				DIALOG_SELECT_GENDER_STRING[DIALOG_CAPTION],
				DIALOG_SELECT_GENDER_STRING[DIALOG_INFO],
				DIALOG_SELECT_GENDER_STRING[DIALOG_BUTTON_1],
				DIALOG_SELECT_GENDER_STRING[DIALOG_BUTTON_2]
			);

			gPlayers[playerid][Player_IsLogged] = true;

			currentPlayers[totalPlayers++] = playerid;
		}
		case DIALOG_SELECT_GENDER:
		{
			response = clamp(response, 0, 1);
			gPlayers[playerid][Player_Gender] = response;

			TogglePlayerSpectating(playerid, false);
		}
		case DIALOG_AUTHORIZATION:
		{
			if(!response) return Kick(playerid);

			if(strlen(inputtext) < 6 || strlen(inputtext) > 32) return

				ShowPlayerDialog(playerid, DIALOG_AUTHORIZATION, DIALOG_STYLE_INPUT,
			 		DIALOG_AUTHORIZATION_STRING[DIALOG_CAPTION],
			 		DIALOG_AUTHORIZATION_STRING[DIALOG_INFO],
			 		DIALOG_AUTHORIZATION_STRING[DIALOG_BUTTON_1],
			 		DIALOG_AUTHORIZATION_STRING[DIALOG_BUTTON_2]
			 	);

			new passwordHash[64 + 1];
			SHA256_PassHash(inputtext, gPlayers[playerid][Player_PasswordSalt], passwordHash, sizeof passwordHash);

			if(strcmp(passwordHash, gPlayers[playerid][Player_PasswordHash], false))
			{
				SendClientMessage(playerid, COLOR_RED, "Вы ввели неверный пароль, попробуйте еще раз");
				// SendClientMessageEx(playerid, COLOR_RED, "Попытка %i из 3", gPlayers[playerid][Player_PasswordEnterAttempt]);

				ShowPlayerDialog(playerid, DIALOG_AUTHORIZATION, DIALOG_STYLE_INPUT,
			 		DIALOG_AUTHORIZATION_STRING[DIALOG_CAPTION],
			 		DIALOG_AUTHORIZATION_STRING[DIALOG_INFO],
			 		DIALOG_AUTHORIZATION_STRING[DIALOG_BUTTON_1],
			 		DIALOG_AUTHORIZATION_STRING[DIALOG_BUTTON_2]
			 	);

				return 1;
			}

			LoadgPlayers(playerid);
			LoadPlayerItems(playerid);

			SetSpawnInfo(playerid, NO_TEAM, gPlayers[playerid][Player_Skin],
				DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z, DEFAULT_SPAWN_A,
				0, 0, 0, 0, 0, 0
			);

			SpawnPlayer(playerid);

			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);

			TogglePlayerSpectating(playerid, false);

			gPlayers[playerid][Player_IsLogged] = true;
			gPlayers[playerid][Player_IsSpawned] = true;

			UpdatePlayerLastIp(playerid);

			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid, gPlayers[playerid][Player_Money]);

			new playerLevel = gPlayers[playerid][Player_Exp]/100;
			SetPlayerScore(playerid, playerLevel);

			LoadPlayerAchievements(playerid);

			currentPlayers[totalPlayers++] = playerid;
		}
		case DIALOG_ACHIEVEMENTS:
		{
			if(!response) return 1;

			new achievementid;

			for(new i = 0; i != MAX_ACHIEVEMENTS; i++)
			{
				if(gPlayers[playerid][Player_Achievements][i] == FALSE) continue;

				if(achievementid != listitem)
				{
					achievementid++;
					continue;
				}

				achievementid = i;
				break;
			}

			new dialogString[32 + 128 + 32];
			format(dialogString, sizeof dialogString, ""H_COLOR_GREEN"%s\n"H_COLOR_WHITE"%s", 
				gAchievements[achievementid][Achieve_Title],
				gAchievements[achievementid][Achieve_Description]
			);
			ShowPlayerDialog(playerid, DIALOG_ACHIEVE_INFO, DIALOG_STYLE_MSGBOX, "Информация о достижении", dialogString, "Закрыть", "");
		}
		case DIALOG_ACHIEVE_INFO: PC_EmulateCommand(playerid, "/myachievements");
		case DIALOG_VEHICLE_ITEMS:
		{
			new vehicleid = GetPVarInt(playerid, "ItemsVehicleid");
			DeletePVar(playerid, "ItemsVehicleid");

			if(!response) 
			{
				gVehicles[vehicleid][Vehicle_IsBootUsed] = false;
				return 1;
			}

			new itemid;

			for(new i = 0; i != MAX_ITEMS; i++)
			{
				if(gVehicles[vehicleid][Vehicle_Items][i] == 0) continue;

				if(itemid != listitem)
				{
					itemid++;
					continue;
				}

				itemid = i;
				break;
			}

			if(gVehicles[vehicleid][Vehicle_Items][itemid] == 0) return
				SendClientMessage(playerid, COLOR_RED, "Этого предмета нет в багажнике");

			AddPlayerItem(playerid, itemid, 1);
			gVehicles[vehicleid][Vehicle_Items][itemid]--;

			SendClientMessageEx(playerid, COLOR_WHITE, "Вы взяли предмет "H_COLOR_GREEN"%s "H_COLOR_WHITE"из багажника автомобиля "H_COLOR_GREEN"%s",
				gItems[itemid][Item_Title], gVehicleNames[GetVehicleModel(vehicleid) - 400]
			);

			PC_EmulateCommand(playerid, "/vehicleitems");
		}
		case DIALOG_PLAYER_ITEMS:
		{
			if(!response) return 1;

			new itemid;

			for(new i = 0; i != MAX_ITEMS; i++)
			{
				if(GetPlayerItem(playerid, i) == 0) continue;

				if(itemid != listitem)
				{
					itemid++;
					continue;
				}

				itemid = i;
				break;
			}

			// SendClientMessageEx(playerid, -1, "Вы выбрали предмет "H_COLOR_GREEN"%s", gItems[itemid][Item_Title]);

			ShowPlayerDialog(playerid, DIALOG_PLRITEMS_ACTION, DIALOG_STYLE_LIST, gItems[itemid][Item_Title], "Использовать\nВыбросить\nИнформация", "Выбрать", "Отмена");

			SetPVarInt(playerid, "Items_CurrentItemID", itemid);
		}
		case DIALOG_PLRITEMS_ACTION:
		{
			if(!response) return 1;

			new itemid = GetPVarInt(playerid, "Items_CurrentItemID");
			DeletePVar(playerid, "Items_CurrentItemID");

			enum
			{
				ITEM_ACTION_USE,
				ITEM_ACTION_DROP,
				ITEM_ACTION_SHOW_INFO
			};

			switch(listitem)
			{
				case ITEM_ACTION_USE: 
				{
					switch(itemid)
					{
						case BOX_SPRUNK, BOX_COKOPOPS:
						{
							new vendingid = GetPlayerVendingid(playerid);

							if(vendingid == -1) return SendClientMessage(playerid, COLOR_RED, "Вам необходимо находиться рядом с вендинговым автоматом");

							if(gVendings[vendingid][Vending_Owner] != gPlayers[playerid][Player_Uid]) return 
								SendClientMessage(playerid, COLOR_RED, "У Вас нет ключа от этого вендингового автомата");

							switch(itemid)
							{
								case BOX_SPRUNK: 
								{
									gVendings[vendingid][Vending_ItemCount] += 36;
									SendClientMessage(playerid, COLOR_GREEN, "Вы положили 36 банок газировки \"Sprunk\" в вендинговый автомат");
								}
								case BOX_COKOPOPS: 
								{
									gVendings[vendingid][Vending_ItemCount] += 20;
									SendClientMessage(playerid, COLOR_GREEN, "Вы положили 20 упаковок снэков \"Cokopops\" в вендинговый автомат");
								}
							}

							RemovePlayerItem(playerid, itemid, 1);
						}
						default: OnPlayerUseItem(playerid, itemid);
					}
				}
				case ITEM_ACTION_DROP: 
				{
					switch(itemid)
					{
						case BOX_SPRUNK, BOX_COKOPOPS: SendClientMessage(playerid, COLOR_RED, "Этот предмет невозможно выбросить");
						default: OnPlayerDropItem(playerid, itemid);
					}
				}
				case ITEM_ACTION_SHOW_INFO:
				{

				}
			}
		}
		case DIALOG_BUY_ITEMS_FOR_VENDING:
		{
			if(!response) return 1;

			// if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) return
			// 	SendClientMessage(playerid, COLOR_RED, "У Вас в руках что-то находится");

			enum
			{
				VNDNG_ITM_SPRUNK,
				VNDNG_ITM_COKOPOPS,
			};

			switch(listitem)
			{
				case VNDNG_ITM_SPRUNK:
				{
					if(GetPlayerMoneyCount(playerid) < 15) return SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег");

					AddPlayerItem(playerid, BOX_SPRUNK, 1);

					SendClientMessage(playerid, COLOR_GREEN, "Вы приобрели коробку содовой за $15");
					SendClientMessage(playerid, COLOR_GRAY, "Предмет находится в вашем инвентаре");
				}
				case VNDNG_ITM_COKOPOPS:
				{
					if(GetPlayerMoneyCount(playerid) < 15) return SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег");

					AddPlayerItem(playerid, BOX_COKOPOPS, 1);

					SendClientMessage(playerid, COLOR_GREEN, "Вы приобрели коробку снэков за $18");
					SendClientMessage(playerid, COLOR_GRAY, "Предмет находится в вашем инвентаре");
				}
			}

			// switch(listitem)
			// {
			// 	case VNDNG_ITM_SPRUNK:
			// 	{
			// 		if(!ChangePlayerMoney(playerid, 15)) return
			// 			SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег");

			// 		AddPlayerItem(playerid, BOX_SPRUNK, 1);

			// 		gPlayers[playerid][Player_IsCarryingSodaBox] = true;
			// 	}
			// 	case VNDNG_ITM_COKOPOPS: 
			// 	{
			// 		if(!ChangePlayerMoney(playerid, 18)) return
			// 			SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег");

			// 		AddPlayerItem(playerid, BOX_COKOPOPS, 1);

			// 		gPlayers[playerid][Player_IsCarryingSnackBox] = true;
			// 	}
			// }

			// SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			// SetPlayerAttachedObject(playerid, 9, 2900, 1, 
			// 	-0.056999, 0.585000, -0.039000, 175.900146, 82.600036, -5.500002, 0.451999, 0.546999, 0.457999);

			// gPlayers[playerid][Player_IsCarryingVndngItmsBox] = true;

			// SendClientMessageEx(playerid, COLOR_GREEN, "Вы купили коробку %s", !listitem ? "газировки \"Sprunk\"" : "снэков \"Cokopops\"");
			// SendClientMessage(playerid, COLOR_WHITE, "Пока вы держите коробку в руках, вы не можете пользоваться предметами инвентаря");
			// SendClientMessage(playerid, COLOR_WHITE, "Вы можете выбросить коробку, или положить ее в багажник, как обычный предмет инвентаря");
		}
		case DIALOG_VEHICLE_RADIO:
		{
			if(!response) return 1;
	
			new vehicleid = GetPlayerVehicleID(playerid);

			gVehicles[vehicleid][Vehicle_RadioWave] = listitem;

			foreach(i)
			{
				printf("тест игрока %i", i);
				if(!IsPlayerInVehicle(i, vehicleid)) continue;
				print("Игрок в нужной машине");
				PlayAudioStreamForPlayer(i, gRadios[listitem][Radio_Url]);
			}
		}
	}
	return 1;
}

public OnPlayerUseItem(playerid, itemid)
{
	if(gPlayers[playerid][Player_IsCarryingVndngItmsBox] == TRUE && (itemid != BOX_SPRUNK && itemid != BOX_COKOPOPS))
	{
		SendClientMessage(playerid, COLOR_RED, "Вы не можете использовать предметы инвентаря, пока держите коробку");
		return 1;
	}

	switch(itemid)
	{
		case BOX_SPRUNK, BOX_COKOPOPS:
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) return
				SendClientMessage(playerid, COLOR_RED, "Ваши руки заняты");

			SetPlayerAttachedObject(playerid, 9, 2900, 1, 
				-0.056999, 0.585000, -0.039000, 175.900146, 82.600036, -5.500002, 0.451999, 0.546999, 0.457999);

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

			switch(itemid)
			{
				case BOX_SPRUNK: gPlayers[playerid][Player_IsCarryingSodaBox] = true;
				case BOX_COKOPOPS: gPlayers[playerid][Player_IsCarryingSnackBox] = true;
			}

			gPlayers[playerid][Player_IsCarryingVndngItmsBox] = true;
		}
	}
	return 1;
}

public OnPlayerDropItem(playerid, itemid)
{
	if(GetPlayerNearestVehicle(playerid) != -1)
	{
		new vehicleid, engine, lights, alarm, doors, bonnet, boot, objective;

		vehicleid = GetPlayerNearestVehicle(playerid);

		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

		if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return
			SendClientMessage(playerid, COLOR_RED, "Невозможно положить предмет в багажник");

		RemovePlayerItem(playerid, itemid, 1);

		gVehicles[vehicleid][Vehicle_Items][itemid]++;

		SendClientMessageEx(playerid, COLOR_WHITE, 
			"Вы положили предмет "H_COLOR_GREEN"%s "H_COLOR_WHITE"в багажник автомобиля "H_COLOR_GREEN"%s",
			gItems[itemid][Item_Title], gVehicleNames[GetVehicleModel(vehicleid) - 400]
		);
		return 1;
	}

	switch(itemid)
	{
		case BOX_SPRUNK, BOX_COKOPOPS:
		{
			if(gPlayers[playerid][Player_IsCarryingVndngItmsBox] == TRUE)
			{
				RemovePlayerAttachedObject(playerid, 9);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

				SendClientMessageEx(playerid, COLOR_WHITE, "Вы убрали предмет "H_COLOR_GREEN"%s "H_COLOR_WHITE"в инвентарь", gItems[itemid][Item_Title]);

				gPlayers[playerid][Player_IsCarryingVndngItmsBox] = false;

				switch(itemid)
				{
					case BOX_SPRUNK: gPlayers[playerid][Player_IsCarryingSodaBox] = false;
					case BOX_COKOPOPS: gPlayers[playerid][Player_IsCarryingSnackBox] = false;
				}
				return 1;
			}
			SendClientMessage(playerid, COLOR_RED, "Вы можете положить этот предмет только в багажник автомобиля");
			return 1;
		}
		default:
		{
			RemovePlayerItem(playerid, itemid, 1);

			new Float:x, Float:y, Float:z, Float:a;
			GetPosInFrontOfPlayer(playerid, 1.0, x, y, z);

			z = z - 1.0 + gItems[itemid][Item_Height];

			GetPlayerFacingAngle(playerid, a);

			CreateDroppedItem(itemid, x, y, z, a);

			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
			Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
			Streamer_Update(playerid, STREAMER_TYPE_AREA);
		}
	}
	return 1;
}

public OnPlayerPickupItem(playerid, itemid)
{
	AddPlayerItem(playerid, itemid, 1);
	SendClientMessageEx(playerid, -1, "Вы подняли предмет "H_COLOR_GREEN"%s", gItems[itemid][Item_Title]);
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(bool:gPlayers[playerid][Player_IsLogged] == FALSE) return 0;
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result == -1)
    {
        SendClientMessage(playerid, COLOR_RED, "Команда не найдена");
        return 0;
    }
    return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new bool:isPlayerEditVending = bool:GetPVarInt(playerid,"Vending_IsPlayerEditVending");

	if(isPlayerEditVending == TRUE && response == EDIT_RESPONSE_FINAL)
	{
		new vendingid = GetPVarInt(playerid, "Vending_Vendingid");

		DeletePVar(playerid, "Vending_Vendingid");
		DeletePVar(playerid, "Vending_IsPlayerEditVending");

		DestroyDynamicObject(gVendings[vendingid][Vending_Objectid]);

		gVendings[vendingid][Vending_PosX] = x,
		gVendings[vendingid][Vending_PosY] = y,
		gVendings[vendingid][Vending_PosZ] = z,
		gVendings[vendingid][Vending_PosRX] = rx,
		gVendings[vendingid][Vending_PosRY] = ry,
		gVendings[vendingid][Vending_PosRZ] = rz;

		CreateVending(vendingid);
		SaveVendingData(vendingid);
	}
	return 1;
}

stock CreateDroppedItem(itemid, Float:x, Float:y, Float:z, Float:a)
{
	new objectid = CreateDynamicObject(gItems[itemid][Item_Modelid], x, y, z, 0.0, 0.0, a);

	new textString[34 + 32 + 1];
	format(textString, sizeof textString, "%s\nНажмите H + Y, чтобы поднять");

	new textid = CreateDynamic3DTextLabel(textString, DEFAULT_3D_TEXT_COLOR, x, y, z, DEFAULT_DRAW_DISTANCE);

	new arrayData[4] = { AREA_TYPE_DROPPED_ITEM, -1, -1, -1 };

	arrayData[1] = itemid;
	arrayData[2] = objectid;
	arrayData[3] = textid;

	new areaid = CreateDynamicSphere(x, y, z, 1.5);

	Streamer_SetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, arrayData);
	return 1;
}

stock SaveMetalPrice()
{
	new query[96], DBResult:dbResult;

	for(new i = 0; i != MAX_METALS; i++)
	{
		if(gMetals[i][Metal_CurrentPrice] == 0) gMetals[i][Metal_CurrentPrice] = gMetals[i][Metal_DefaultPrice];

		format(query, sizeof query, "SELECT ID FROM METAL_PRICE WHERE TITLE = '%q'", gMetals[i][Metal_StockTitle]);
		dbResult = db_query(dbHandle, query);

		if(db_num_rows(dbResult)) 
			format(query, sizeof query, "UPDATE METAL_PRICE SET PRICE = %i, COUNT = %i WHERE TITLE = '%q'",
				gMetals[i][Metal_CurrentPrice],
				gMetals[i][Metal_Count],
				gMetals[i][Metal_StockTitle]
			);
		else
			format(query, sizeof query, "INSERT INTO METAL_PRICE (TITLE, PRICE, COUNT) VALUES ('%q', %i, %i)",
				gMetals[i][Metal_StockTitle],
				gMetals[i][Metal_Count],
				gMetals[i][Metal_CurrentPrice]
			);

		db_query(dbHandle, query);
		db_free_result(dbResult);
	}
	return 1;
}

stock LoadMetalPrice()
{
	print("Загрузка цен на ценные металлы...");

	new query[64], DBResult:dbResult;

	for(new i = 0; i != MAX_METALS; i++)
	{
		format(query, sizeof query, "SELECT * FROM METAL_PRICE WHERE TITLE = '%q'", gMetals[i][Metal_StockTitle]);
		dbResult = db_query(dbHandle, query);

		if(db_num_rows(dbResult)) 
		{
			gMetals[i][Metal_CurrentPrice] = db_get_field_assoc_int(dbResult, "PRICE");
			gMetals[i][Metal_Count] = db_get_field_assoc_int(dbResult, "COUNT");
			gMetals[i][Metal_OldPrice] = gMetals[i][Metal_CurrentPrice];			
		}

		else
		{
			gMetals[i][Metal_CurrentPrice] = gMetals[i][Metal_DefaultPrice];		
			gMetals[i][Metal_OldPrice] = gMetals[i][Metal_DefaultPrice];
			gMetals[i][Metal_Count] = 0;	
		}

		db_free_result(dbResult);

		printf("Загружено: %s (%s); Стоимость: %i", gMetals[i][Metal_Title], gMetals[i][Metal_StockTitle], gMetals[i][Metal_CurrentPrice]);
	}

	gMetals3DText = CreateDynamic3DTextLabel("AMEX: "H_COLOR_WHITE"Ожидание торгов", COLOR_GREEN, 354.0756, 173.8468, 1011.9585, DEFAULT_DRAW_DISTANCE);
	return 1;
}

stock UpdateMetalPrice()
{
	print("Изменение цены...");

	new textString[256];

	for(new i = 0; i != MAX_METALS; i++)
	{
		if(gMetals[i][Metal_CurrentPrice] == 0) gMetals[i][Metal_CurrentPrice] = gMetals[i][Metal_DefaultPrice];

		new demand = gMetals[i][Metal_CurrentSales] - gMetals[i][Metal_OldSales];

		gMetals[i][Metal_OldSales] = gMetals[i][Metal_CurrentSales]; // Итоги продаж за прошлый час
		gMetals[i][Metal_OldPrice] = gMetals[i][Metal_CurrentPrice]; // Стоимость за прошлый час

		gMetals[i][Metal_CurrentSales] = 0;

		if(demand < 0) 
		{
			new Float:pricePercent = float(gMetals[i][Metal_CurrentPrice]) * 0.2;
			gMetals[i][Metal_CurrentPrice] -= floatround(pricePercent);
			if(gMetals[i][Metal_CurrentPrice] <= 0) gMetals[i][Metal_CurrentPrice] = 1;
		}
		if(demand > 0) 
		{
			new Float:salesFloat = float(gMetals[i][Metal_OldSales]) == 0 ? 1.0 : float(gMetals[i][Metal_OldSales]);
			new Float:countFloat = float(gMetals[i][Metal_Count]) == 0 ? 1.0 : float(gMetals[i][Metal_Count]);
			new Float:demandFactor = salesFloat / (0.01 * countFloat);
			gMetals[i][Metal_CurrentPrice] += floatround(demandFactor);
		}
		if(demand == 0) 
		{
			new Float:pricePercent = float(gMetals[i][Metal_CurrentPrice]) * (float(rand(1, 50)) * 0.01);
			if(random(2)) pricePercent = pricePercent  * (-1);
			gMetals[i][Metal_CurrentPrice] += floatround(pricePercent);
			if(gMetals[i][Metal_CurrentPrice] <= 0) gMetals[i][Metal_CurrentPrice] = 1;
		}

		new Float:priceDifference = (float(gMetals[i][Metal_CurrentPrice]) / float(gMetals[i][Metal_OldPrice])) * 100.0;

		if(priceDifference < 100.0) priceDifference = (100.0 - priceDifference) * (-1);
		else priceDifference = priceDifference - 100.0;

		format(textString, sizeof textString, "%s"H_COLOR_WHITE"%s : $%i (%s%.3f%%"H_COLOR_WHITE")\n",
			textString,
			gMetals[i][Metal_StockTitle], 
			gMetals[i][Metal_CurrentPrice],
			priceDifference < 0 ? H_COLOR_RED : H_COLOR_GREEN,
			priceDifference
		);
	}

	UpdateDynamic3DTextLabelText(gMetals3DText, COLOR_WHITE, textString);
	
	isMetalBuyAviable = true;
	return 1;
}

stock SendRPMessage(playerid, const message[])
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	foreach(i)
	{
		if(!IsPlayerInRangeOfPoint(i, DEFAULT_DRAW_DISTANCE, x, y, z)) continue;
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;
		if(GetPlayerInterior(playerid) != GetPlayerInterior(i)) continue;
		SendClientMessage(i, COLOR_PINK, message);
	}
	return 1;
}

stock SaveVendingData(vendingid)
{
	new query[188 + 1 + 9 + 16 + 16 + 16 + 16 + 16 + 16 + 16 + 16 + 16 + 6 + 1];
	format(query, sizeof query, "UPDATE VENDINGS SET \
		IS_OWNED = %i, OWNER = %i, CASH = %i, ITEM_COUNT = %i, ITEM_PRICE = %i, \
		POS_X = %f, POS_Y = %f, POS_Z = %f, POS_RX = %f, POS_RY = %f, POS_RZ = %f WHERE UID = %i",
		gVendings[vendingid][Vending_IsOwned],
		gVendings[vendingid][Vending_Owner],
		gVendings[vendingid][Vending_Cash],
		gVendings[vendingid][Vending_ItemCount],
		gVendings[vendingid][Vending_ItemPrice],
		gVendings[vendingid][Vending_PosX],
		gVendings[vendingid][Vending_PosY],
		gVendings[vendingid][Vending_PosZ],
		gVendings[vendingid][Vending_PosRX],
		gVendings[vendingid][Vending_PosRY],
		gVendings[vendingid][Vending_PosRZ],
		gVendings[vendingid][Vending_Uid]
	);
	db_free_result(db_query(dbHandle, query));
	return 1;
}

stock CreateVending(vendingid)
{
	new Float:x = gVendings[vendingid][Vending_PosX],
		Float:y = gVendings[vendingid][Vending_PosY],
		Float:z = gVendings[vendingid][Vending_PosZ],
		Float:rx = gVendings[vendingid][Vending_PosRX],
		Float:ry = gVendings[vendingid][Vending_PosRY],
		Float:rz = gVendings[vendingid][Vending_PosRZ];

	new textString[100];

	gVendings[vendingid][Vending_IsCreated] = true;
	gVendings[vendingid][Vending_Objectid] = 
		CreateDynamicObject(DEFAULT_VENDING_MODELID[gVendings[vendingid][Vending_Type]], x, y, z, rx, ry, rz);

	if(gVendings[vendingid][Vending_IsOwned] == FALSE)
		format(textString, sizeof textString, "%s\nДоступен для покупки\nСтоимость $%i\n/buyvending",
			DEFAULT_VENDING_NAME[gVendings[vendingid][Vending_Type]],
			DEFAULT_VENDING_BUY_PRICE[gVendings[vendingid][Vending_Type]]
		);

	if(gVendings[vendingid][Vending_IsOwned] == TRUE)
		format(textString, sizeof textString, "%s\nСтоимость %s $%i\nДля покупки нажмите \"H\"",
			DEFAULT_VENDING_NAME[gVendings[vendingid][Vending_Type]],
			gVendings[vendingid][Vending_Type] ? "снэка" : "содовой",
			gVendings[vendingid][Vending_ItemPrice]
		);

	gVendings[vendingid][Vending_Textid] =
		CreateDynamic3DTextLabel(textString, DEFAULT_3D_TEXT_COLOR, x, y, z, DEFAULT_DRAW_DISTANCE);

	new Float:areaPosX, Float:areaPosY;

	rz = 180.0 - rz;
	
	areaPosX = x + 1.0 * floatsin(rz, degrees);
	areaPosY = y + 1.0 * floatcos(rz, degrees);
	
	gVendings[vendingid][Vending_Areaid] = CreateDynamicSphere(areaPosX, areaPosY, z, 1.0);

	new arrayData[2] = { AREA_TYPE_VENDING, -1 };
	arrayData[1] = vendingid;

	Streamer_SetArrayData(STREAMER_TYPE_AREA, gVendings[vendingid][Vending_Areaid], E_STREAMER_EXTRA_ID, arrayData);
	return 1;
}

stock IsValidName(const nickname[])
{
	new nicknameLenght = strlen(nickname),
		underscoreCount,
		uppercaseCount;

	for(new i = 0; i != nicknameLenght; i++) 
	{
		switch(nickname[i]) 
		{
			case 65..90, 95, 97..122: 
			{
				switch(nickname[i]) 
				{
					case 65..90: uppercaseCount++;
					case 95: underscoreCount++;
					default: continue;
				}
			}
			default: return 0;
		}
	}
	if(underscoreCount > 1 || uppercaseCount > 2) return 0;
	new underscorePos = strfind(nickname, "_");
	if(underscorePos < 2) return 0;
	switch(nickname[0]) 
	{
		case 65..90: {}
		default: return 0;
	}
	switch(nickname[underscorePos + 1]) 
	{
		case 65..90: {}
		default: return 0;
	}
	return 1;
}

stock GeneratePlayerUid()
{
	new bool:isUidUnique,
		query[64],
		DBResult:dbResult;

	new playerUid = rand(111111111, 999999999);

	while(isUidUnique == false)
	{
		format(query, sizeof query, "SELECT ID FROM PLAYERS WHERE UID = %i", playerUid);
		dbResult = db_query(dbHandle, query);
		if(!db_num_rows(dbResult)) isUidUnique = true;
		db_free_result(dbResult);
	}
	
	return playerUid;
}

stock LoadgPlayers(playerid)
{
	new query[45 + MAX_PLAYER_NAME + 1], DBResult:dbResult;
	format(query, sizeof query, "SELECT * FROM PLAYERS WHERE PLAYERNAME = '%q'", gPlayers[playerid][Player_Name]);
	dbResult = db_query(dbHandle, query);

	gPlayers[playerid][Player_Uid] = db_get_field_assoc_int(dbResult, "UID");
	gPlayers[playerid][Player_Money] = db_get_field_assoc_int(dbResult, "MONEY");
	gPlayers[playerid][Player_Exp] = db_get_field_assoc_int(dbResult, "EXP");
	gPlayers[playerid][Player_Gender] = db_get_field_assoc_int(dbResult, "GENDER");
	gPlayers[playerid][Player_Skin] = db_get_field_assoc_int(dbResult, "SKIN");
	gPlayers[playerid][Player_TotalInGameTime] = db_get_field_assoc_int(dbResult, "TOTAL_INGAME_TIME");
	gPlayers[playerid][Player_Debt] = db_get_field_assoc_int(dbResult, "DEBT");
	gPlayers[playerid][Player_IsLeader] = bool:db_get_field_assoc_int(dbResult, "IS_LEADER");
	gPlayers[playerid][Player_Fraction] = db_get_field_assoc_int(dbResult, "FRACTION");
	gPlayers[playerid][Player_Rank] = db_get_field_assoc_int(dbResult, "RANK");

	db_free_result(dbResult);
	return 1;
}

stock UpdatePlayerLastIp(playerid)
{
	new query[48 + 16 + 9 + 1];
	format(query, sizeof query, "UPDATE PLAYERS SET LAST_IP = '%q' WHERE UID = %i", gPlayers[playerid][Player_Ip], gPlayers[playerid][Player_Uid]);
	db_free_result(db_query(dbHandle, query));
	return 1;
}

stock ChangePlayerMoney(playerid, amount)
{
	if(amount < 0 && gPlayers[playerid][Player_Money] < (amount * -1)) return 0;

	gPlayers[playerid][Player_Money] += amount;

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, gPlayers[playerid][Player_Money]);

	new textString[16];
	format(textString, sizeof textString, "%c $%i", amount < 0 ? "-" : "+", floatabs(amount));

	SetPlayerChatBubble(playerid, textString, amount < 0 ? COLOR_RED : COLOR_GREEN, DEFAULT_DRAW_DISTANCE, DEFAULT_EXPIRE_TIME);
	return 1;
}

stock GetPlayerMoneyCount(playerid) return gPlayers[playerid][Player_Money];

stock ChangePlayerExp(playerid, amount)
{
	if(amount < 0 && gPlayers[playerid][Player_Exp] < amount) return 0;

	if(amount > 0) amount *= EXP_MULTIPLIER;

	gPlayers[playerid][Player_Exp] += amount;

	new playerLevel = gPlayers[playerid][Player_Exp]/100;
	SetPlayerScore(playerid, playerLevel);

	new textString[16];
	format(textString, sizeof textString, "%c %i EXP", amount < 0 ? "-" : "+", floatabs(amount));
	SetPlayerChatBubble(playerid, textString, amount < 0 ? COLOR_RED : COLOR_GREEN, DEFAULT_DRAW_DISTANCE, DEFAULT_EXPIRE_TIME);
	return 1;
}

stock PreloadAnimations(playerid)
{
	ApplyAnimation(playerid, "AIRPORT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "Attractors", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BAR", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BASEBALL", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BEACH", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "benchpress", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BF_injection", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BIKED", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BIKEH", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BIKELEAP", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BIKES", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BIKEV", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BIKE_DBZ", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BLOWJOBZ", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BMX", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BOMBER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BOX", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BSKTBALL", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BUDDY", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "BUS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CAMERA", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CAR", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CARRY", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CAR_CHAT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CASINO", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CHAINSAW", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CHOPPA", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CLOTHES", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "COACH", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "COLT45", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "COP_DVBYZ", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CRACK", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CRIB", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "DAM_JUMP", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "DANCING", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "DEALER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "DILDO", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "DODGE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "DOZER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "DRIVEBYS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FAT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FIGHT_B", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FIGHT_C", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FIGHT_D", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FIGHT_E", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FINALE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FINALE2", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FLAME", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "Flowers", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FOOD", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "Freeweights", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "GANGS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "GHANDS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "GHETTO_DB", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "goggles", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "GRAFFITI", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "GRAVEYARD", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "GRENADE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "GYMNASIUM", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "HAIRCUTS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "HEIST9", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "INT_HOUSE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "INT_OFFICE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "INT_SHOP", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "JST_BUISNESS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "KART", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "KISSING", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "KNIFE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "LAPDAN1", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "LAPDAN2", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "LAPDAN3", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "LOWRIDER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "MD_CHASE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "MD_END", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "MEDIC", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "MISC", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "MTB", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "MUSCULAR", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "NEVADA", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "ON_LOOKERS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "OTB", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "PARACHUTE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "PARK", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "PAULNMAC", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "ped", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "PLAYER_DVBYS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "PLAYIDLES", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "POLICE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "POOL", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "POOR", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "PYTHON", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "QUAD", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "QUAD_DBZ", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "RAPPING", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "RIFLE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "RIOT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "ROB_BANK", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "ROCKET", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "RUSTLER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "RYDER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SCRATCHING", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SHAMAL", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SHOP", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SHOTGUN", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SILENCED", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SKATE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SMOKING", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SNIPER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SPRAYCAN", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "STRIP", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SUNBATHE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SWAT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SWEET", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SWIM", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SWORD", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "TANK", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "TATTOOS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "TEC", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "TRAIN", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "TRUCK", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "UZI", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "VAN", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "VENDING", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "VORTEX", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "WAYFARER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "WEAPONS", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "WUZI", "null", 0.0, 0, 0, 0, 0, 0);
	return 1;
}

stock SavegPlayers(playerid)
{
	gPlayers[playerid][Player_TotalInGameTime] += gPlayers[playerid][Player_CurrentInGameTime];

	new query[140 + MAX_PLAYER_NAME + 16 + 3 + 16 + 16 + 16 + 9 + 1];
	format(query, sizeof query, 

		"UPDATE PLAYERS SET \
		PLAYERNAME = '%q',\
		MONEY = %i,\
		SKIN = %i,\
		EXP = %i,\
		TOTAL_INGAME_TIME = %i,\
		DEBT = %i, \
		IS_LEADER = %i, \
		FRACTION = %i, \
		RANK = %i \
		WHERE UID = %i",

		gPlayers[playerid][Player_Name],
		gPlayers[playerid][Player_Money],
		gPlayers[playerid][Player_Skin],
		gPlayers[playerid][Player_Exp],
		gPlayers[playerid][Player_TotalInGameTime],
		gPlayers[playerid][Player_Debt],
		gPlayers[playerid][Player_IsLeader],
		gPlayers[playerid][Player_Fraction],
		gPlayers[playerid][Player_Rank],
		gPlayers[playerid][Player_Uid]
	);

	db_free_result(db_query(dbHandle, query));
	return 1;
}

stock GivePlayerAchievement(playerid, achievementid)
{
	if(achievementid >= MAX_ACHIEVEMENTS) return 0;

	if(gPlayers[playerid][Player_Achievements][achievementid] == TRUE) return 0;

	gPlayers[playerid][Player_Achievements][achievementid] = true;

	SendClientMessageEx(playerid, COLOR_GREEN, "Новое достижение: "H_COLOR_WHITE"%s "H_COLOR_GREEN"(+ %i EXP)", 
		gAchievements[achievementid][Achieve_Title],
		gAchievements[achievementid][Achieve_Exp]
	);
	
	ChangePlayerExp(playerid, gAchievements[achievementid][Achieve_Exp]);
	return 1;
}

stock SavePlayerAchievements(playerid)
{
	new query[62 + 9 + 16 + 1], 
		DBResult:dbResult,
		rows;

	for(new i = 0; i != MAX_ACHIEVEMENTS; i++)
	{
		if(gPlayers[playerid][Player_Achievements][i] == FALSE) continue;

		format(query, sizeof query, "SELECT ID FROM ACHIEVEMENTS WHERE UID = %i AND ACHIEVE_ID = %i", 
			gPlayers[playerid][Player_Uid],
			i
		);

		dbResult = db_query(dbHandle, query);
		rows = db_num_rows(dbResult);
		db_free_result(dbResult);

		if(rows) continue;

		format(query, sizeof query, "INSERT INTO ACHIEVEMENTS (UID, ACHIEVE_ID) VALUES (%i, %i)", 
			gPlayers[playerid][Player_Uid],
			i
		);

		db_free_result(db_query(dbHandle, query));
	}
	return 1;
}

stock SavePlayerItems(playerid)
{
	new query[128], DBResult:dbResult;

	for(new i = 0; i != MAX_ITEMS; i++)
	{
		if(!GetPlayerItem(playerid, i)) continue;

		format(query, sizeof query, "SELECT ID FROM ITEMS WHERE UID = %i AND ITEM_ID = %i", playeruid(playerid), i);

		dbResult = db_query(dbHandle, query);

		if(db_num_rows(dbResult))
			format(query, sizeof query, "UPDATE ITEMS SET ITEM_ID = %i, COUNT = %i WHERE UID = %i",
				i,
				GetPlayerItem(playerid, i),
				playeruid(playerid)
			);
		else
			format(query, sizeof query, "INSERT INTO ITEMS (UID, ITEM_ID, COUNT) VALUES (%i, %i, %i)",
				playeruid(playerid),
				i,
				GetPlayerItem(playerid, i)		
			);

		db_free_result(dbResult);
		db_free_result(db_query(dbHandle, query));		
	}
	return 1;
}

stock LoadPlayerItems(playerid)
{
	new query[64], DBResult:dbResult;
	format(query, sizeof query, "SELECT * FROM ITEMS WHERE UID = %i", playeruid(playerid));

	dbResult = db_query(dbHandle, query);

	if(db_num_rows(dbResult))
	{
		new itemid, itemcount;

		do
		{
			itemid = db_get_field_assoc_int(dbResult, "ITEM_ID");
			itemcount = db_get_field_assoc_int(dbResult, "COUNT");

			AddPlayerItem(playerid, itemid, itemcount);
		}
		while(db_next_row(dbResult));
	}

	db_free_result(dbResult);
	return 1;
}

stock LoadPlayerAchievements(playerid)
{
	new query[41 + 9 + 1], DBResult:dbResult;

	format(query, sizeof query, "SELECT * FROM ACHIEVEMENTS WHERE UID = %i", gPlayers[playerid][Player_Uid]);

	dbResult = db_query(dbHandle, query);

	if(db_num_rows(dbResult))
	{
		new achievementid;

		do
		{
			achievementid = db_get_field_assoc_int(dbResult, "ACHIEVE_ID");

			gPlayers[playerid][Player_Achievements][achievementid] = true;
		}	
		while(db_next_row(dbResult));
	}

	db_free_result(dbResult);
	return 1;
}

stock Play3DSound(playerid, soundid, Float:radius)
{
	new Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach(i)
	{
		if(!IsPlayerInRangeOfPoint(i, radius, x, y, z)) continue;
		if(GetPlayerInterior(playerid) != GetPlayerInterior(i)) continue;
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;
		PlayerPlaySound(i, soundid, x, y, z);
	}
	return 1;
}

stock GetPosInFrontOfPlayer(playerid, Float:distance, &Float:x, &Float:y, &Float:z)
{
    if(GetPlayerPos(playerid, x, y, z))
    {
        new Float:z_angle;
        GetPlayerFacingAngle(playerid, z_angle);
 
        x += distance * floatsin(-z_angle, degrees);
        y += distance * floatcos(-z_angle, degrees);
 
        return 1;
    }
    return 0;
}

stock chance(percent)
{
	percent = clamp(percent, 1, 100);
	new Float:c = float(percent) / (100 + float(percent));
	new chanceStatus = rand(0, 9999) < (c * 10000);
	return bool:chanceStatus;
}

stock RemoveVending(vendingid)
{
	DestroyDynamicObject(gVendings[vendingid][Vending_Objectid]);
	DestroyDynamicArea(gVendings[vendingid][Vending_Areaid]);
	DestroyDynamic3DTextLabel(gVendings[vendingid][Vending_Textid]);

	new query[37 + 6 + 1];
	format(query, sizeof query, "DELETE FROM VENDINGS WHERE UID = %i", gVendings[vendingid][Vending_Uid]);
	db_free_result(db_query(dbHandle, query));

	gVendings[vendingid] = empty_gVendings;
	totalVendings--;
	return 1;
}

stock FindFreeVendingIndex()
{
	new freeIndex = -1;

	for(new i = 0; i != MAX_VENDINGS; i++) {
		if(gVendings[i][Vending_IsCreated] == true) continue;
		freeIndex = i;
		break;
	}
	return freeIndex;
}

stock LoadVendings()
{
	print("Загрузка вендингов...");

	new DBResult:dbResult;

	dbResult = db_query(dbHandle, "SELECT * FROM VENDINGS");

	if(db_num_rows(dbResult))
	{
		printf("Найдено %i записей", db_num_rows(dbResult));

		new vendingid;

		do
		{
			vendingid = totalVendings++;
			if((vendingid + 1) == MAX_VENDINGS) break;
			printf("Загрузка вендинга %i", vendingid);

			gVendings[vendingid][Vending_Uid] = db_get_field_assoc_int(dbResult, "UID");
			gVendings[vendingid][Vending_Type] = db_get_field_assoc_int(dbResult, "TYPE");
			gVendings[vendingid][Vending_Type] = clamp(gVendings[vendingid][Vending_Type], 0, 1);
			gVendings[vendingid][Vending_IsOwned] = bool:db_get_field_assoc_int(dbResult, "IS_OWNED");
			gVendings[vendingid][Vending_Owner] = db_get_field_assoc_int(dbResult, "IS_OWNER");
			gVendings[vendingid][Vending_Cash] = db_get_field_assoc_int(dbResult, "CASH");
			gVendings[vendingid][Vending_ItemCount] = db_get_field_assoc_int(dbResult, "ITEM_COUNT");
			gVendings[vendingid][Vending_ItemPrice] = db_get_field_assoc_int(dbResult, "ITEM_PRICE");

			gVendings[vendingid][Vending_PosX] = db_get_field_assoc_float(dbResult, "POS_X");
			gVendings[vendingid][Vending_PosY] = db_get_field_assoc_float(dbResult, "POS_Y");
			gVendings[vendingid][Vending_PosZ] = db_get_field_assoc_float(dbResult, "POS_Z");
			gVendings[vendingid][Vending_PosRX] = db_get_field_assoc_float(dbResult, "POS_RX");
			gVendings[vendingid][Vending_PosRY] = db_get_field_assoc_float(dbResult, "POS_RY");
			gVendings[vendingid][Vending_PosRZ] = db_get_field_assoc_float(dbResult, "POS_RZ");

			CreateVending(vendingid);
		}	
		while(db_next_row(dbResult));
	}
	else print("В базе данных записей не найдено");

	db_free_result(dbResult);
	return 1;
}

stock GetPlayerVendingid(playerid)
{
	new vendingid = -1;
	if(!IsPlayerInAnyDynamicArea(playerid)) return -1;

	new playerAreas[1];
	GetPlayerDynamicAreas(playerid, playerAreas);

	new areaid = playerAreas[0];

	if(!IsValidDynamicArea(areaid)) return -1;

	new areaType[1];
	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, areaType);

	if(areaType[0] != AREA_TYPE_VENDING) return -1;

	new arrayData[2];
	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, arrayData);

	vendingid = arrayData[1];
	return vendingid;
}

stock GetPlayerItem(playerid, itemid)
{
	if(itemid >= MAX_ITEMS) return -1;
	return gPlayers[playerid][Player_Items][itemid];
}

stock AddPlayerItem(playerid, itemid, count)
{
	itemid = clamp(itemid, 0, MAX_ITEMS - 1);
	gPlayers[playerid][Player_Items][itemid] += count;
	return 1;
}

stock RemovePlayerItem(playerid, itemid, count)
{
	itemid = clamp(itemid, 0, MAX_ITEMS - 1);
	if(gPlayers[playerid][Player_Items][itemid] < count) return 0;
	gPlayers[playerid][Player_Items][itemid] -= count;
	return 1;
}

stock GetVehicleBootPos(vehicleid, &Float:posX, &Float:posY, &Float:posZ)
{
	new vehiclemodel = GetVehicleModel(vehicleid);

	new Float:lenght, Float:width, Float:height;
	GetVehicleModelInfo(vehiclemodel, VEHICLE_MODEL_INFO_SIZE, width, lenght, height);

	new Float:x, Float:y, Float:z, Float:a;
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, a);

	new Float:fixedAngle = (360.0 - a) + 180.0;

	new Float:circleRadius = lenght / 2.0;

	posX = x + (circleRadius * floatsin(fixedAngle, degrees));
	posY = y + (circleRadius * floatcos(fixedAngle, degrees)); 
	posZ = z;
	return 1;
}

stock GetVehicleFuelCapPos(vehicleid, &Float:posX, &Float:posY, &Float:posZ)
{
	new vehiclemodel = GetVehicleModel(vehicleid);

	new Float:petrolCapPosX, Float:petrolCapPosY, Float:petrolCapPosZ;
	GetVehicleModelInfo(vehiclemodel, VEHICLE_MODEL_INFO_PETROLCAP, petrolCapPosX, petrolCapPosY, petrolCapPosZ);

	new Float:radius = floatsqroot((petrolCapPosX * petrolCapPosX) + (petrolCapPosY * petrolCapPosY));

	new Float:alphaAngle = atan(petrolCapPosX / petrolCapPosY);

	SendClientMessageToAllf(COLOR_GREEN, "X: %f Y: %f RAD: %f ANG: %f", petrolCapPosX, petrolCapPosY, radius, alphaAngle);

	new Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);

	new Float:a;
	GetVehicleZAngle(vehicleid, a);

	// a = 360.0 - a;
	a = a * (-1);
	if(petrolCapPosY < 0.0) a = a - 180.0;
	a = a + alphaAngle;

	// if(petrolCapPosY < 0.0) a = 180.0 - a;

	// if(petrolCapPosX > 0.0) a = a + alphaAngle;
	// else a = a - alphaAngle;
	

	posX = x + (radius * floatsin(a, degrees));
	posY = y + (radius * floatcos(a, degrees)); 

	posZ = z + petrolCapPosZ;
	return 1;
}

stock GetPlayerNearestVehicle(playerid)
{
	new vehicleid = -1,
		Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);

	for(new i = GetVehiclePoolSize(); i != 0; i--)
	{
		if(!IsValidVehicle(i)) continue;
		if(GetVehicleDistanceFromPoint(i, x, y, z) > 4.0) continue;
		vehicleid = i;
		break;
	}
	return vehicleid;
}

cmd:boot(playerid)
{
	new vehicleid = GetPlayerNearestVehicle(playerid);
	if(vehicleid == -1) return
		SendClientMessage(playerid, COLOR_RED, "Рядом с Вами нет ни одного автомобиля");

	new Float:x, Float:y, Float:z;

	GetVehicleBootPos(vehicleid, x, y, z);

	if(!IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z)) return
		SendClientMessage(playerid, COLOR_RED, "Вы должны находиться рядом с багажником");

	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(boot == VEHICLE_PARAMS_UNSET) boot = VEHICLE_PARAMS_OFF;

	boot = !boot;

	SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return 1;
}

cmd:vehicleitems(playerid)
{
	new vehicleid = GetPlayerNearestVehicle(playerid);

	if(vehicleid == -1) return
		SendClientMessage(playerid, COLOR_RED, "Рядом с Вами нет ни одного автомобиля");

	new Float:x, Float:y, Float:z;
	GetVehicleBootPos(vehicleid, x, y, z);

	if(!IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z)) return
		SendClientMessage(playerid, COLOR_RED, "Вы должны находиться рядом с багажником");

	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return
		SendClientMessage(playerid, COLOR_RED, "Багажник этого автомобиля закрыт");

	// if(gVehicles[vehicleid][Vehicle_IsBootUsed] == TRUE) return
	// 	SendClientMessage(playerid, COLOR_RED, "Багажником уже кто-то пользуется");

	new totalVehicleItems, dialogString[((32 + 4 + 8) * MAX_ITEMS) + 100];

	for(new i = 0; i != MAX_ITEMS; i++)
	{
		if(gVehicles[vehicleid][Vehicle_Items][i] == 0) continue;
		totalVehicleItems++;
		format(dialogString, sizeof dialogString, "%s\n%i\t%s\t%i", 
			dialogString, 
			totalVehicleItems, 
			gItems[i][Item_Title], 
			gVehicles[vehicleid][Vehicle_Items][i]
		);
	}

	strins(dialogString, "#\tПредмет\tКол-во", 0);

	if(totalVehicleItems == 0) return
		SendClientMessage(playerid, COLOR_RED, "Багажник этого автомобиля пуст");

	ShowPlayerDialog(playerid, 
		DIALOG_VEHICLE_ITEMS, 
		DIALOG_STYLE_TABLIST_HEADERS, 
		gVehicleNames[GetVehicleModel(vehicleid) - 400], 
		dialogString, 
		"Взять", "Закрыть"
	);

	SetPVarInt(playerid, "ItemsVehicleid", vehicleid);

	gVehicles[vehicleid][Vehicle_IsBootUsed] = true;
	return 1;
}

cmd:myachievements(playerid)
{
	new dialogString[(MAX_ACHIEVEMENTS * 35) + 50], totalAchievements;
	for(new i = 0; i != MAX_ACHIEVEMENTS; i++)
	{
		if(gPlayers[playerid][Player_Achievements][i] == FALSE) continue;
		strcat(dialogString, "\n");
		strcat(dialogString, gAchievements[i][Achieve_Title]);
		totalAchievements++;
	}

	if(totalAchievements == 0) return
		SendClientMessage(playerid, COLOR_RED, "У Вас нет достижений");

	ShowPlayerDialog(playerid, DIALOG_ACHIEVEMENTS, DIALOG_STYLE_LIST, "Достижения", dialogString, "Подробней", "Закрыть");
	return 1;
}

cmd:editvending(playerid)
{
	SendClientMessageEx(playerid, -1, "%i", GetPlayerVendingid(playerid));

	new vendingid = GetPlayerVendingid(playerid);

	if(vendingid == -1) return
		SendClientMessage(playerid, COLOR_RED, "Рядом с Вами нет вендинговых автоматов");

	DestroyDynamic3DTextLabel(gVendings[vendingid][Vending_Textid]);
	DestroyDynamicArea(gVendings[vendingid][Vending_Areaid]);

	EditDynamicObject(playerid, gVendings[vendingid][Vending_Objectid]);

	SetPVarInt(playerid, "Vending_IsPlayerEditVending", 1);
	SetPVarInt(playerid, "Vending_Vendingid", vendingid);
	return 1;
}

cmd:removevending(playerid)
{
	new vendingid = GetPlayerVendingid(playerid);

	if(vendingid == -1) return
		SendClientMessage(playerid, COLOR_RED, "Рядом с Вами нет вендинговых автоматов");

	if(bool:GetPVarInt(playerid, "Vending_IsRemoving") == FALSE)
	{
		SetPVarInt(playerid, "Vending_IsRemoving", 1);
		SetPVarInt(playerid, "Vending_Vendingid", vendingid);

		SendClientMessageEx(playerid, COLOR_RED, "Чтобы удалить вендинг %i, введите команду еще раз", vendingid);

		return 1;
	}

	if(bool:GetPVarInt(playerid, "Vending_IsRemoving") == TRUE)
	{
		if(GetPVarInt(playerid, "Vending_Vendingid") != vendingid)
		{
			SendClientMessage(playerid, COLOR_RED, "Неизвестная ошибка");
			DeletePVar(playerid, "Vending_IsRemoving");
			DeletePVar(playerid, "Vending_Vendingid");
			return 1;
		}

		SendClientMessageEx(playerid, COLOR_RED, "Вендинг %i удален", vendingid);
		RemoveVending(vendingid);
		DeletePVar(playerid, "Vending_IsRemoving");
		DeletePVar(playerid, "Vending_Vendingid");
	}
	return 1;
}

cmd:createvending(playerid, a[])
{
	_sscanf:a, new vendingType; else return
		SendClientMessage(playerid, -1, "Введите /createvending [тип (0 - 1)]");
	vendingType = clamp(vendingType, 0, 1);
	new vendingid = FindFreeVendingIndex();

	new Float:x,
		Float:y,
		Float:z;

	GetPosInFrontOfPlayer(playerid, 3.0, x, y, z);

	new vendingUid, bool:isVendingUidUnique;

	while(isVendingUidUnique == FALSE)
	{
		vendingUid = rand(111111, 999999);
		for(new i = 0; i != MAX_VENDINGS; i++)
		{
			if(gVendings[i][Vending_Uid] != vendingUid) continue;
			isVendingUidUnique = true;
			break;
		}
		isVendingUidUnique = !isVendingUidUnique;
	}

	gVendings[vendingid][Vending_Uid] = vendingUid;
	gVendings[vendingid][Vending_Type] = vendingType;
	gVendings[vendingid][Vending_ItemPrice] = DEFAULT_VENDING_ITEM_PRICE[vendingType];

	gVendings[vendingid][Vending_Objectid] = 
		CreateDynamicObject(DEFAULT_VENDING_MODELID[vendingType], x, y, z, 0.0, 0.0, 0.0);

	EditDynamicObject(playerid, gVendings[vendingid][Vending_Objectid]);

	SetPVarInt(playerid, "Vending_IsPlayerEditVending", 1);
	SetPVarInt(playerid, "Vending_Vendingid", vendingid);

	new query[64 + 6 + 1 + 16 + 1];
	format(query, sizeof query, "INSERT INTO VENDINGS (UID, TYPE, ITEM_PRICE) VALUES (%i, %i, %i)", 
		vendingUid, vendingType, DEFAULT_VENDING_ITEM_PRICE[vendingType]);
	db_free_result(db_query(dbHandle, query));
	return 1;
}

cmd:buyvending(playerid)
{
	new vendingid = GetPlayerVendingid(playerid);

	if(vendingid == -1) return
		SendClientMessage(playerid, COLOR_RED, "Рядом с Вами нет вендинговых автоматов");

	if(gVendings[vendingid][Vending_IsOwned] == TRUE) return
		SendClientMessage(playerid, COLOR_RED, "Этот вендинговый автомат уже куплен");

	if(playermoney(playerid) < DEFAULT_VENDING_BUY_PRICE[gVendings[vendingid][Vending_Type]]) return
		SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег для покупки этого вендингового автомата");

	if(bool:GetPVarInt(playerid, "Vending_IsBuying") == FALSE)
	{
		SetPVarInt(playerid, "Vending_IsBuying", 1);
		SetPVarInt(playerid, "Vending_Vendingid", vendingid);

		SendClientMessageEx(playerid, COLOR_GREEN, "Чтобы приобрести этот вендиговый автома за $%i, введите команду еще раз", 
			DEFAULT_VENDING_BUY_PRICE[gVendings[vendingid][Vending_Type]]);
		return 1;
	}

	if(bool:GetPVarInt(playerid, "Vending_IsBuying") == TRUE)
	{
		if(GetPVarInt(playerid, "Vending_Vendingid") != vendingid)
		{
			SendClientMessage(playerid, COLOR_RED, "Неизвестная ошибка");
			DeletePVar(playerid, "Vending_IsBuying");
			DeletePVar(playerid, "Vending_Vendingid");
			return 1;
		}

		ChangePlayerMoney(playerid, -DEFAULT_VENDING_BUY_PRICE[gVendings[vendingid][Vending_Type]]);

		gVendings[vendingid][Vending_IsOwned] = true;
		gVendings[vendingid][Vending_Owner] = gPlayers[playerid][Player_Uid];

		new textString[100];
		format(textString, sizeof textString, "%s\nСтоимость %s $%i\nДля покупки нажмите \"H\"",
			DEFAULT_VENDING_NAME[gVendings[vendingid][Vending_Type]],
			gVendings[vendingid][Vending_Type] ? "снэка" : "содовой",
			gVendings[vendingid][Vending_ItemPrice]
		);

		UpdateDynamic3DTextLabelText(gVendings[vendingid][Vending_Textid], DEFAULT_3D_TEXT_COLOR, textString);

		SendClientMessageEx(playerid, COLOR_GREEN, "Вы успешно приобрели вендинговый автомат %s за $%i",
			gVendings[vendingid][Vending_Type] ? "со снэками" : "с содовой",
			DEFAULT_VENDING_BUY_PRICE[gVendings[vendingid][Vending_Type]]
		);
		SendClientMessage(playerid, COLOR_WHITE, "Рекомендуем ознакомиться с управлением вендинговым автоматом - "H_COLOR_WHITE"/vendinghelp");

		DeletePVar(playerid, "Vending_IsBuying");
		DeletePVar(playerid, "Vending_Vendingid");

		SaveVendingData(vendingid);
	}
	return 1;
}

cmd:myitems(playerid)
{
	AddPlayerItem(playerid, BOX_SPRUNK, 4);
	AddPlayerItem(playerid, SMALL_MEDIC_KIT, 2);
	AddPlayerItem(playerid, EMPTY_FUEL_CAN, 1);
	AddPlayerItem(playerid, MIDLAND_GTX_PRO_CB, 1);

	new totalPlayerItems, dialogString[((32 + 4 + 8) * MAX_ITEMS) + 100];

	for(new i = 0; i != MAX_ITEMS; i++)
	{
		if(gPlayers[playerid][Player_Items][i] == 0) continue;
		totalPlayerItems++;
		format(dialogString, sizeof dialogString, "%s\n%i\t%s\t%i", dialogString, totalPlayerItems, gItems[i][Item_Title], gPlayers[playerid][Player_Items][i]);
	}

	strins(dialogString, "#\tПредмет\tКол-во", 0);

	ShowPlayerDialog(playerid, DIALOG_PLAYER_ITEMS, DIALOG_STYLE_TABLIST_HEADERS, "Инвентарь", dialogString, "Действия", "Закрыть");
	return 1;
}

cmd:pickup(playerid)
{
	if(!IsPlayerInAnyDynamicArea(playerid)) return 1;

	new playerAreas[1];
	GetPlayerDynamicAreas(playerid, playerAreas);

	new areaid = playerAreas[0];

	if(!IsValidDynamicArea(areaid)) return 1;

	new areaType[1];
	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, areaType);

	if(areaType[0] != AREA_TYPE_DROPPED_ITEM) return 1;

	new arrayData[4];
	Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, arrayData);

	new itemid = arrayData[1],
		objectid = arrayData[2],
		textid = arrayData[3];

	DestroyDynamicArea(areaid);
	DestroyDynamicObject(objectid);
	DestroyDynamic3DTextLabel(textid);

	OnPlayerPickupItem(playerid, itemid);
	return 1;
}

cmd:ship(playerid)
{
	SendClientMessage(playerid, COLOR_GREEN, "Корабль создан");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	new vehicleid = CreateVehicle(453, x, y, z, 0.0000, -1, -1, 100);
	PutPlayerInVehicle(playerid, vehicleid, 0);

	new objects[3];

	objects[0] = CreateDynamicObject(10230, 1.40650, -0.68150, 8.90790,   0.00000, 0.00000, 270.00000);
	objects[1] = CreateDynamicObject(10231, -0.09350, 0.23850, 10.38790,   0.00000, 0.00000, 270.00000);
	objects[2] = CreateDynamicObject(19564, -0.06580, -40.55240, 19.14650,   0.00000, 0.00000, 0.00000);

	AttachDynamicObjectToVehicle(objects[0], vehicleid, 1.40650, -0.68150, 8.90790,   0.00000, 0.00000, 270.00000);
	AttachDynamicObjectToVehicle(objects[1], vehicleid, -0.09350, 0.23850, 10.38790,   0.00000, 0.00000, 270.00000);
	AttachDynamicObjectToVehicle(objects[2], vehicleid, -0.06580, -40.55240, 19.14650,   0.00000, 0.00000, 0.00000);

	AttachCameraToDynamicObject(playerid, objects[2]);
	return 1;
}

cmd:test(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new Float:x, Float:y, Float:z;
	GetVehicleFuelCapPos(vehicleid, x, y, z);
	CreateDynamic3DTextLabel("FUEL CAP", 0xFFFFFFFF, x, y, z, 10.0);
	Streamer_Update(playerid);
	return 1;
}

@_VehicleGPSUpdate(vehicleid);
@_VehicleGPSUpdate(vehicleid)
{
	SendClientMessageToAll(COLOR_RED, "TIMER");
	SetTimerEx("@_VehicleGPSUpdate", 20, false, "i", vehicleid);

	new Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);

	new Float:destinationX = 807.6777, Float:destinationY = -1336.8499, Float:destinationZ = 13.5469;

	#pragma unused destinationZ
		
	new quart;

	if(destinationX > x && destinationY > y) quart = 1;
	if(destinationX > x && destinationY < y) quart = 2;
	if(destinationX < x && destinationY < y) quart = 3;
	if(destinationX < x && destinationY > y) quart = 4;

	SendClientMessageToAllf(COLOR_RED, "quart %i", quart);

	new Float:a, Float:b, Float:angle;

	switch(quart)
	{
		case 1:
		{
			a = destinationY - y;
			b = destinationX - x;
			angle = atan(b / a);
		}
		case 2:
		{
			a = destinationX - x;
			b = y - destinationY;
			angle = atan(b / a) + 90.0;
		}
		case 3:
		{
			a = y - destinationY;
			b = x - destinationX;
			angle = atan(b / a) + 180.0;
		}
		case 4:
		{
			a = x - destinationX;
			b = destinationY - y;
			angle = atan(b / a) + 270.0;
		}
	}

	// angle = angle * (-1) + 90.0;

	SendClientMessageToAllf(COLOR_RED, "ANGLE %f", angle);

	new Float:vehicleAngle;
	GetVehicleZAngle(vehicleid, vehicleAngle);

	vehicleAngle = 360.0 - vehicleAngle;

	angle = angle - vehicleAngle;

	angle = angle * (-1) + 90.0;

	AttachDynamicObjectToVehicle(gVehicles[vehicleid][Vehicle_ArrowObject], vehicleid, 0.0, 0.0, 1.0, 0.0, 90.0, angle);

	// DestroyDynamicObject(gVehicles[vehicleid][Vehicle_ArrowObject]);

	// SetDynamicObjectRot(gVehicles[vehicleid][Vehicle_ArrowObject], 0.0, 90.0, angle);
	return 1;
}

cmd:gps(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	gVehicles[vehicleid][Vehicle_ArrowObject] = CreateDynamicObject(19134, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

	AttachDynamicObjectToVehicle(gVehicles[vehicleid][Vehicle_ArrowObject], vehicleid, 0.0, 0.0, 1.0, 0.0, 90.0, 0.0);

	SetTimerEx("@_VehicleGPSUpdate", 20, false, "i", vehicleid);

	// new Float:x, Float:y, Float:z;
	// GetPlayerPos(playerid, x, y, z);

	// new Float:objX, Float:objY, Float:objZ;
	// GetDynamicObjectPos(arrow, objX, objY, objZ);

	// new quart;

	// if(x > objX && y > objY) quart = 1;
	// if(x > objX && y < objY) quart = 2;
	// if(x < objX && y < objY) quart = 3;
	// if(x < objX && y > objY) quart = 4;

	// SendClientMessageEx(playerid, COLOR_GREEN, "QUART %i", quart);

	// new Float:a, Float:b, Float:angle;

	// switch(quart)
	// {
	// 	case 1:
	// 	{
	// 		a = y - objY;
	// 		b = x - objX;
	// 		angle = atan(b / a);
	// 	}
	// 	case 2:
	// 	{
	// 		a = x - objX;
	// 		b = objY - y;
	// 		angle = atan(b / a) + 90.0;
	// 	}
	// 	case 3:
	// 	{
	// 		a = objY - y;
	// 		b = objX - x;
	// 		angle = atan(b / a) + 180.0;
	// 	}
	// 	case 4:
	// 	{
	// 		a = x - objX;
	// 		b = objY - y;
	// 		angle = atan(b / a) + 270.0;
	// 	}
	// }

	// SendClientMessageEx(playerid, COLOR_GREEN, "ANGLE %f", angle);

	// angle = (angle * (-1)) + 90.0;

	// SetDynamicObjectRot(arrow, 0.0, 90.0, angle);
	return 1;
}

cmd:showpass(playerid, a[])
{
	// gPlayers[playerid][Player_Name]

	_sscanf:a, new player:targetid; else return
		SendClientMessage(playerid, -1, "Введите /showpass [ID игрока]");

	if(targetid == INVALID_PLAYER_ID) return
		SendClientMessage(playerid, COLOR_RED, "Игрок с таким ID не найден");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if(!IsPlayerInRangeOfPoint(targetid, DEFAULT_DRAW_DISTANCE, x, y, z)) return
		SendClientMessage(playerid, COLOR_RED, "Этот игрок слишком далеко от Вас");

	new firstName[MAX_PLAYER_NAME], 
		lastName[MAX_PLAYER_NAME],
		underscorePos;

	underscorePos = strfind(gPlayers[playerid][Player_Name], "_");

	printf("underscore pos %i", underscorePos);

	strmid(firstName, gPlayers[playerid][Player_Name], 0, underscorePos);

	printf("first name %s", firstName);

	strmid(lastName, gPlayers[playerid][Player_Name], underscorePos + 1, strlen(gPlayers[playerid][Player_Name]));

	for(new i = 0; i != strlen(firstName); i++) firstName[i] = toupper(firstName[i]);
	for(new i = 0; i != strlen(lastName); i++) lastName[i] = toupper(lastName[i]);

	new textString[26 + MAX_PLAYER_NAME * 2];
	if(playerid == targetid)
		format(textString, sizeof textString, "%s смотрит свой паспорт", playername(playerid));
	else
		format(textString, sizeof textString, "%s показал(-а) свой паспорт %s", playername(playerid), playername(targetid));

	SendRPMessage(playerid, textString);

	SendClientMessage(targetid, COLOR_BLUE, "UNITED STATES OF AMERICA");
	SendClientMessage(targetid, COLOR_GRAY, "Given Names");
	SendClientMessageEx(targetid, COLOR_WHITE, "%s", firstName);
	SendClientMessage(targetid, COLOR_GRAY, "Surname");
	SendClientMessageEx(targetid, COLOR_WHITE, "%s", lastName);
	SendClientMessage(targetid, COLOR_GRAY, "Sex");
	SendClientMessageEx(targetid, COLOR_WHITE, "%s", gPlayers[playerid][Player_Gender] ? "M" : "F");
	SendClientMessage(targetid, COLOR_GRAY, "Place of birth");
	SendClientMessage(targetid, COLOR_WHITE, "LOS SANTOS, SAN ANDREAS");
	SendClientMessageEx(targetid, COLOR_GRAY, "P<%s<<%s<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<", firstName, lastName);
	return 1;
}

cmd:buymetal(playerid, a[])
{
	_sscanf:a, new metalType, count; else return
		SendClientMessage(playerid, -1, "Введите /buymetal [тип металла (1 - 4)] [кол-во (в унциях, 1 - 1000)]");

	if(isMetalBuyAviable == FALSE) return 
		SendClientMessage(playerid, COLOR_RED, "В данный момент продажа металла приостановлена");

	metalType = clamp(metalType, 1, 4);
	count = clamp(count, 1, 1000);

	metalType -= 1;

	if(gMetals[metalType][Metal_Count] < count) return
		SendClientMessage(playerid, COLOR_RED, "Вы не можете приобрести такое количество металла");

	gMetals[metalType][Metal_Count] -= count;
	gMetals[metalType][Metal_CurrentSales] += count;

	SendClientMessageEx(playerid, COLOR_GREEN, "AMEX: "H_COLOR_WHITE"Приобретено %s в количестве %i унций", gMetals[metalType][Metal_Title], count);
	return 1;
}

cmd:makeleader(playerid, a[])
{
	_sscanf:a, new player:targetid, fractionid; else return
		SendClientMessageEx(playerid, COLOR_GRAY, "Введите /makeleader [ID игрока] [ID фракции (1 - %i)]", MAX_FRACTIONS);

	if(targetid == INVALID_PLAYER_ID) return
		SendClientMessage(playerid, COLOR_RED, "Игрок с таким ID не найден");

	fractionid = clamp(fractionid, 1, MAX_FRACTIONS);

	gPlayers[targetid][Player_Fraction] = fractionid;
	gPlayers[targetid][Player_Rank] = MAX_RANKS[fractionid];
	gPlayers[targetid][Player_IsLeader] = true;

	SendClientMessageEx(targetid, COLOR_GREEN, "Администратор %s назначил Вас лидером фракции %s", playername(playerid), gFractionNames[fractionid]);
	return 1;
}

cmd:r(playerid, a[])
{
	if(!GetPlayerItem(playerid, MIDLAND_GTX_PRO_CB)) return 
		SendClientMessage(playerid, COLOR_RED, "У Вас нет рации");

	_sscanf:a, new string:message[128]; else return
		SendClientMessage(playerid, COLOR_GRAY, "Введите /r [сообщение]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	foreach(i)
	{
		if(!IsPlayerInRangeOfPoint(i, 3500.0, x, y, z)) continue;

		if(gPlayers[i][Player_Fraction] != gPlayers[playerid][Player_Fraction]) continue;

		if(!GetPlayerItem(playerid, MIDLAND_GTX_PRO_CB)) continue;

		if(gPlayers[i][Player_CBChannel] != gPlayers[playerid][Player_CBChannel]) continue;

		SendClientMessageEx(i, COLOR_BLUE, "[R CH:%i] %s %s: "H_COLOR_WHITE"%s",
			gPlayers[playerid][Player_CBChannel],
			gFractionRanks[gPlayers[playerid][Player_Fraction]][gPlayers[playerid][Player_Rank]],
			playername(playerid),
			message
		);
	}
	return 1;
}

cmd:beacons(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
	if(gPlayers[playerid][Player_Fraction] != FRACTION_LSPD) return 1;

	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsBeaconLightsAviable(vehicleid)) return 1;

	if(gVehicles[vehicleid][Vehicle_IsBeaconsOn] == TRUE)
	{
		DestroyDynamicObject(gVehicles[vehicleid][Vehicle_FLBeacon]);
		DestroyDynamicObject(gVehicles[vehicleid][Vehicle_FRBeacon]);
		DestroyDynamicObject(gVehicles[vehicleid][Vehicle_RLBeacon]);
		DestroyDynamicObject(gVehicles[vehicleid][Vehicle_RRBeacon]);
	}
	else
	{
		gVehicles[vehicleid][Vehicle_FLBeacon] = CreateDynamicObject(19286, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		gVehicles[vehicleid][Vehicle_RLBeacon] = CreateDynamicObject(19286, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

		gVehicles[vehicleid][Vehicle_FRBeacon] = CreateDynamicObject(19288, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		gVehicles[vehicleid][Vehicle_RRBeacon] = CreateDynamicObject(19288, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

		new vehiclemodel = GetVehicleModel(vehicleid);

		switch(vehiclemodel)
		{
			case 596: vehiclemodel = CAR_POLICE_LS;
			case 599: vehiclemodel = CAR_POLICE_RANGER;
			case 427: vehiclemodel = CAR_POLICE_ENFORCER;
		}

		AttachDynamicObjectToVehicle(gVehicles[vehicleid][Vehicle_FLBeacon], vehicleid, 
			gLightBeaconsPos[vehiclemodel][0][0],
			gLightBeaconsPos[vehiclemodel][0][1],
			gLightBeaconsPos[vehiclemodel][0][2],
			0.0, 0.0, 0.0
		);

		AttachDynamicObjectToVehicle(gVehicles[vehicleid][Vehicle_FRBeacon], vehicleid, 
			gLightBeaconsPos[vehiclemodel][1][0],
			gLightBeaconsPos[vehiclemodel][1][1],
			gLightBeaconsPos[vehiclemodel][1][2],
			0.0, 0.0, 0.0
		);

		AttachDynamicObjectToVehicle(gVehicles[vehicleid][Vehicle_RLBeacon], vehicleid, 
			gLightBeaconsPos[vehiclemodel][2][0],
			gLightBeaconsPos[vehiclemodel][2][1],
			gLightBeaconsPos[vehiclemodel][2][2],
			0.0, 0.0, 0.0
		);

		AttachDynamicObjectToVehicle(gVehicles[vehicleid][Vehicle_RRBeacon], vehicleid, 
			gLightBeaconsPos[vehiclemodel][3][0],
			gLightBeaconsPos[vehiclemodel][3][1],
			gLightBeaconsPos[vehiclemodel][3][2],
			0.0, 0.0, 0.0
		);
	}

	gVehicles[vehicleid][Vehicle_IsBeaconsOn] = !gVehicles[vehicleid][Vehicle_IsBeaconsOn];

	SendClientMessageEx(playerid, COLOR_WHITE, "Проблесковые маячки %s", 
		gVehicles[vehicleid][Vehicle_IsBeaconsOn] ? ""H_COLOR_GREEN"включены" : ""H_COLOR_RED"отключены"
	);
	return 1;
}

cmd:cput(playerid, a[])
{
	_sscanf:a, new player:targetid; else return
		SendClientMessage(playerid, COLOR_GRAY, "Введите /cput [ID игрока]");

	if(targetid == INVALID_PLAYER_ID) return
		SendClientMessage(playerid, COLOR_RED, "Игрок с таким ID не найден");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if(!IsPlayerInRangeOfPoint(targetid, DEFAULT_DRAW_DISTANCE, x, y, z)) return 
		SendClientMessage(playerid, COLOR_RED, "Этот игрок слишком далеко от Вас");

	new vehicleid = -1,
		Float:distance;

	for(new i = gLSPDVehicle[0]; i != gLSPDVehicle[sizeof gLSPDVehicle - 1]; i++)
	{
		if(GetVehicleModel(i) != 596) continue;

		distance = GetVehicleDistanceFromPoint(i, x, y, z);

		if(distance > 5.0) continue;

		vehicleid = i;
		break;
	}

	if(vehicleid == -1) return 
		SendClientMessage(playerid, COLOR_RED, "Рядом с Вами нет патрульного автомобиля");

	new freeSeat = GetFreeBackSeat(vehicleid);

	if(freeSeat == -1) return 
		SendClientMessage(playerid, COLOR_RED, "В этот патрульный автомобиль нельзя посадить арестованного");

	PutPlayerInVehicle(targetid, vehicleid, freeSeat);

	PC_EmulateCommand(playerid, "/me открыл(-а) заднюю дверь патрульного автомобиля");
	PC_EmulateCommand(playerid, "/me посадил(-а) арестованного человека на заднее сиденье патрульного автомобиля");
	PC_EmulateCommand(playerid, "/me посадил(-а) закрыл(-а) заднюю дверь патрульного автомобиля");

	PC_EmulateCommand(targetid, "/do арестованный человек находится на заднем сиденье патрульного автомобиля");
	return 1;
}

cmd:me(playerid, a[])
{
	_sscanf:a, new string:action[128]; else return
		SendClientMessage(playerid, COLOR_GRAY, "Введите /me [действие]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	foreach(i)
	{
		if(!IsPlayerInRangeOfPoint(i, DEFAULT_DRAW_DISTANCE, x, y, z)) continue;
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;
		if(GetPlayerInterior(playerid) != GetPlayerInterior(i)) continue;

		SendClientMessageEx(i, COLOR_PINK, "%s %s", playername(playerid), action);
	}

	SetPlayerChatBubble(playerid, action, COLOR_PINK, DEFAULT_DRAW_DISTANCE, DEFAULT_EXPIRE_TIME);
	return 1;
}

cmd:do(playerid, a[])
{
	_sscanf:a, new string:action[128]; else return
		SendClientMessage(playerid, COLOR_GRAY, "Введите /do [действие]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	foreach(i)
	{
		if(!IsPlayerInRangeOfPoint(i, DEFAULT_DRAW_DISTANCE, x, y, z)) continue;
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;
		if(GetPlayerInterior(playerid) != GetPlayerInterior(i)) continue;

		SendClientMessageEx(i, COLOR_GRAY, "* %s (%s)", action, playername(playerid));
	}
	return 1;
}

cmd:try(playerid, a[])
{
	_sscanf:a, new string:action[128]; else return
		SendClientMessage(playerid, COLOR_GRAY, "Введите /try [действие]");

	new textString[144],
		bool:isSuccess = bool:chance(40);

	format(textString, sizeof textString, "%s %s "H_COLOR_PINK"%s", 
		playername(playerid), 
		isSuccess ? ""H_COLOR_GREEN"удачно" : ""H_COLOR_RED"неудачно", 
		action
	);

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	foreach(i)
	{
		if(!IsPlayerInRangeOfPoint(i, DEFAULT_DRAW_DISTANCE, x, y, z)) continue;
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;
		if(GetPlayerInterior(playerid) != GetPlayerInterior(i)) continue;
		SendClientMessageEx(i, COLOR_PINK, "%s %s", textString, action);
	}

	SetPlayerChatBubble(playerid, textString, COLOR_PINK, DEFAULT_DRAW_DISTANCE, DEFAULT_EXPIRE_TIME);
	return 1;
}

stock GetFreeBackSeat(vehicleid)
{
	new freeSeat = -1, 
		playersInCar, 
		bool:isRRSeatFree = true, 
		bool:isRLSeatFree = true, 
		playerVehicleSeat;

	foreach(i)
	{
		if(playersInCar == 2) break;

		if(!IsPlayerInVehicle(i, vehicleid)) continue;

		playerVehicleSeat = GetPlayerVehicleSeat(i);

		if(playerVehicleSeat == 2 || playerVehicleSeat == 3)
		{
			playersInCar++;

			if(playerVehicleSeat == 2) isRRSeatFree = false;
			if(playerVehicleSeat == 3) isRLSeatFree = false;
		}
	}

	if(isRRSeatFree == true) freeSeat = 2;
	if(isRLSeatFree == true) freeSeat = 3;

	return freeSeat;
}

cmd:buy(playerid, a[])
{
	_sscanf:a, new count; else return
		SendClientMessage(playerid, COLOR_GRAY, "Введите /buy [count (1 - 1000)]");

	count = clamp(count, 1, 1000);

	if(gMetals[METAL_GOLD][Metal_Count] == 0) return 
		SendClientMessage(playerid, COLOR_RED, "В настоящее время покупка этого металла ограничена");

	if(count > gMetals[METAL_GOLD][Metal_Count]) return 
		SendClientMessageEx(playerid, COLOR_RED, "В данный момент максимальное количество, доступное для покупки - %i", gMetals[METAL_GOLD][Metal_Count]);

	gMetals[METAL_GOLD][Metal_Count] -= count;
	gMetals[METAL_GOLD][Metal_CurrentSales] += count;


	SendClientMessageEx(playerid, COLOR_GREEN, "Куплено %i металла", count);
	return 1;
}

cmd:radio(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

	new vehicleid = GetPlayerVehicleID(playerid);

	if(IsVehicleRadioAviable(vehicleid) == FALSE) return 
		SendClientMessage(playerid, COLOR_RED, "В этой машине радио не предусмотрено");

	ShowPlayerDialog(playerid, DIALOG_VEHICLE_RADIO, DIALOG_STYLE_TABLIST_HEADERS, "Радио", gRadiosString, "Выбрать", "Отмена");
	return 1;
}