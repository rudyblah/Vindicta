/*
Building positions suitable for specific roles.

Each building position is structered:
	[_buildingPosID, _direction]
		_buildingPosID - number of the building position returned by buildingPos command.
		_direction - hte direction where the unit must be heading relative to the building's position.
	OR it can be specified in cylindrical coordinates relative to building's center:
	[_offset, _offsetDirection, _offsetHeight, _direction]
		_offset - the magnitude of the offset projected onto horizontal plane.
		_offsetDirection - the direction of the offset.
		_offsetHeight - the height of the offset.
		_direction - direction where the unit must be heading relative to the building's position.

The structure of each array with positions for specific type is:
	[[_typesArray, _positionArray], [_typesArray, _positionArray], ...]
		_typesArray - the array of types (typeOf ...) of this building sharing the same building positions. For example, different variants of the same watchtower.
		_positioArray - the array of positions in the form [_buildingPosID, _direction] or [_offset, _offsetDirection, _offsetHeight, _direction]
*/

//Positions where a high GMG or a high HMG can be placed and operated from.
location_bp_HGM_GMG_high =
[
	[ //The giant military tower
		["Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"],
		[[11, 90], [13, 0], [14, 0], [16, 180], [17, 180]]
	],
	[ //The small military watchtower
		["Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F"],
		[[1.9, 220, 4.4, 180], [1.9, 130, 4.4, 180]]
	]

	/*
	[ //The military HQ
		["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F"],
		[[4, 90], [5, 0], [6, -45], [7, 225], [8, 180]]
	]
	*/
];

//Positions where soldiers can freely shoot from.
//Note that soldiers can also shoot well from HMG positions.
location_bp_sentry =
[
	[ //The giant military tower
		["Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"],
		[[0, 0], [1, 0], [10, 180], [12, 0], [15, 270], [2, 0], [4, 180], [7, 90], [8, 270]]
	],
	[ //The small military watchtower
		["Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F"],
		[[0, 180], [1, 180]]
	],
	[ //The military HQ
		["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F"],
		[[4, 90], [5, 0], [6, -45], [7, 225], [8, 180]]
	],
	//Global Mobilization
	[ 
		["land_gm_tower_bt_6_fuest_80"],
		[[2, 280], [3, 180], [4, 0]]
	],
	[ 
		["land_gm_tower_bt_11_60"],
		[[0, 180], [1, 180]]
	]	
];

// Capacities of buildings for infantry
// Typically a building's inf capacity is amount of its buildingPos, however for some buildings we can override that here
location_b_capacity =
[
	[ //The giant military tower
		["Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"],
		14
	],
	[ //The small military watchtower
		["Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F"],
		2
	],
	[ //The military HQ
		["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F"],
		10
	],
	[ //The military metal box
		["Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F"],
		4
	],
	// Tents
	[
		["Land_MedicalTent_01_wdl_generic_inner_F",
		"Land_MedicalTent_01_aaf_generic_inner_F",
		"Land_MedicalTent_01_CSAT_brownhex_generic_inner_F",
		"Land_MedicalTent_01_NATO_generic_inner_F",
		"Land_MedicalTent_01_CSAT_greenhex_generic_inner_F",
		"Land_MedicalTent_01_NATO_tropic_generic_inner_F"],
		8
	],
	// WW2 & CUP
	[
		["Land_WW2_Mil_Barracks","Land_WW2_Mil_Barracks_L","Land_Mil_Barracks_L","Land_Mil_Barracks_no_interior_CUP"],
		10
	],
	[
		["Land_I44_Object_Tent_Us_Small"],
		2
	],
	// Global Mobilization
	[
		["gm_gc_tent_5x5m"],
		8
	]
	
];

// Positions for cargo boxes
location_bp_cargo_medium =
[
	[
		["Land_i_House_Small_01_V3_F", "Land_i_House_Small_01_V1_F", "Land_i_House_Small_01_V2_F", "Land_u_House_Small_01_V1_F"],
		[[2.07516,262.755,0.29788], [3.47262,218.056,0.29805]]
	],
	[
		["Land_i_House_Big_01_V1_F", "Land_i_House_Big_01_V2_F", "Land_i_House_Big_01_V3_F", "Land_u_House_Big_01_V1_F"],
		[[1.64695,117.933,0.498999], [5.47226,166.207,0.498999]]
	],
	[
		["Land_i_Stone_HouseBig_V1_F", "Land_i_Stone_HouseBig_V2_F", "Land_i_Stone_HouseBig_V3_F", "Land_u_Stone_HouseBig_V3_F"],
		[[0.439735,11.0105,3.059], [3.10748,83.2502,3.059]]
	],
	[
		["Land_i_Stone_HouseSmall_V1_F", "Land_i_Stone_HouseSmall_V2_F", "Land_i_Stone_HouseSmall_V3_F", "Land_u_Stone_HouseSmall_V1_F"],
		[[7.5625,69.7211,1.26548], [4.66482,54.9392,1.2517]]
	],
	[
		["Land_i_House_Small_02_V1_F", "Land_i_House_Small_02_V2_F", "Land_i_House_Small_02_V3_F", "Land_u_House_Small_02_V1_F"],
		[[3.10205,87.7267,0.418344], [5.15135,88.892,0.420984]]
	],
	[
		["Land_i_Shop_01_V1_F", "Land_i_Shop_01_V2_F", "Land_i_Shop_01_V3_F", "Land_u_Shop_01_V1_F"],
		[[1.14865,286.802,0.302086], [3.6354,341.39,0.302084]]
	],
	[
		["Land_i_House_Big_02_V1_F", "Land_i_House_Big_02_V2_F", "Land_i_House_Big_02_V3_F", "Land_u_House_Big_02_V1_F"],
		[[3.55678,42.062,0.258254], [3.1946,326.951,0.258255]]
	],
	//Livonia
	[
		["Land_House_2B04_F"],
		[[5.99253,59.4126,0.864166], [3.9745,38.706,0.691895], [4.59203,319.578,0.42363]]
	],
	[
		["Land_PoliceStation_01_F"],
		[[2.60131,61.8427,1.29491], [7.02257,323.042,0.777817], [4.66018,296.356,0.788269], [7.448,319.591,4.42163], [8.1648,252.885,4.26756]]
	],
	//WW2 Staszow
	[
		["Land_WW2_Admin"],
		[[2.64597,143.778,0.32269], [3.85001,153.389,0.32269], [5.09535,16.3686,0.32269], [3.9212,24.0332,0.32269]]
	],
	[
		["Land_WW2_Admin2"],
		[[4.82119,44.2476,0.233089], [4.11613,54.6484,0.233089], [4.62721,-40.6715,0.233089], [5.48119,-33.2937,0.233089], [4.23542,-133.858,0.233089], [5.042,-142.623,0.233089], [4.92659,-226.911,0.233089], [4.27249,-237.533,0.233089]]
	],
	// Beketov
	[
		["Land_HouseV2_02_Interier"],
		[[4.21436,76.2874,0.973242], [6.86528,57.0615,0.973242], [6.2304,306.133,0.973242], [7.66948,288.97,0.973242]]
	],
	// Global Mobilization
	[
		["land_gm_euro_house_07_e",	"land_gm_euro_house_07_w",	"land_gm_euro_house_07_d"],
		[[1.80399,83.2539,0.326653,0.000132318], [2.01474,48.7239,0.336693,359.999], [2.47671,257.29,0.261368,359.999], [2.50627,292.908,0.280899,0.000150937]]
	]
];

// Buildings which can be used as police stations
location_bt_police = 
[
	// Altis
	"Land_i_Shop_01_V2_F",
	"Land_i_Shop_01_V3_F",
	"Land_u_Shop_01_V1_F",
	"Land_i_House_Small_01_V3_F",
	"Land_u_House_Small_01_V1_F",
	"Land_i_House_Small_01_V2_F",
	"Land_u_House_Big_02_V1_F",
	"Land_i_Stone_HouseBig_V3_F",
	"Land_i_Stone_HouseBig_V2_F",
	"Land_i_Stone_HouseBig_V1_F",
	"Land_u_House_Small_02_V1_F",
	"Land_i_House_Small_02_V1_F",
	"Land_i_House_Small_02_V3_F",
	"Land_i_House_Small_02_V2_F",
	"Land_i_House_Big_02_V3_F",
	"Land_i_House_Big_02_V2_F",
	"Land_i_House_Big_02_V1_F",
	"Land_i_Stone_HouseSmall_V3_F",
	"Land_i_Stone_HouseSmall_V1_F",
	"Land_i_Stone_HouseSmall_V2_F",
	"Land_i_House_Big_01_V1_F",
	"Land_i_House_Big_01_V2_F",
	"Land_u_House_Big_01_V1_F",
	"Land_i_House_Big_01_V3_F",

	//Livonia
	"Land_PoliceStation_01_F",
	"Land_House_2B04_F",

	// WW2 Staszo
	"Land_WW2_Admin",
	"Land_WW2_Admin2",
	
	// Beketov - CUP
	"Land_HouseV2_02_Interier",

	// Global Mobilization
	"land_gm_euro_house_07_e",
	"land_gm_euro_house_07_w",
	"land_gm_euro_house_07_d"
];

location_decorations_police =
[
	[
		["Land_i_House_Small_02_V1_F","Land_u_House_Small_02_V1_F","Land_i_House_Small_02_V3_F","Land_i_House_Small_02_V2_F"],
		// Array of [_offset, _vectorDirAndUp]
		[[[2.3125,-3.76367,1.24133],[[0,1,0],[0,0,1]]],[[-4.01563,-0.691406,0.952689],[[0.999999,-0.00148479,0],[0,0,1]]],[[1.54102,3.30469,1.36593],[[-0.000931589,-1,0],[0,0,1]]]]
	],
	[
		["Land_u_Shop_01_V1_F"],
		[[[-0.4375,-2.74609,-0.0292983],[[0.0156359,0.999878,0],[0,0,1]]],[[-0.916016,7.36133,-0.708581],[[-0.0169196,-0.999857,0],[0,0,1]]]]
	],
	[
		["Land_i_Shop_01_V2_F","Land_i_Shop_01_V3_F","Land_i_Shop_01_V1_F"],
		[[[1.24414,-3.11523,0.059587],[[0,1,0],[0,0,1]]],[[1.15625,7.02734,-1.00797],[[-8.74228e-008,-1,0],[0,0,1]]]]
	],
	[
		["Land_u_House_Big_02_V1_F","Land_i_House_Big_02_V3_F","Land_i_House_Big_02_V1_F","Land_i_House_Big_02_V2_F"],
		[[[1.64258,5.54883,-0.478913],[[-0.0169196,-0.999857,0],[0,0,1]]],[[3.3125,-4.49414,-0.789048],[[0.012478,0.999922,0],[0,0,1]]]]
	],
	[
		["Land_i_Stone_HouseSmall_V2_F","Land_i_Stone_HouseSmall_V1_F","Land_i_Stone_HouseSmall_V3_F"],
		[[[0.0566406,-1.37891,0.052608],[[0.012478,0.999922,0],[0,0,1]]],[[0.00585938,5.63672,-0.168258],[[-0.00766302,-0.999971,0],[0,0,1]]]]
	],
	[
		["Land_i_Stone_HouseBig_V3_F","Land_i_Stone_HouseBig_V2_F","Land_i_Stone_HouseBig_V1_F"],
		[[[0.625,-2.00195,0.0724616],[[0.012478,0.999922,0],[0,0,1]]],[[-2.53711,3.22266,2.22565],[[0.99987,-0.0161541,0],[0,0,1]]]]
	],
	[
		["Land_i_House_Big_01_V3_F","Land_i_House_Big_01_V1_F","Land_i_House_Big_01_V2_F","Land_u_House_Big_01_V1_F"],
		[[[-4.81445,2.83203,-1.1514],[[0.999867,-0.0163374,0],[0,0,1]]],[[5.1543,0.775391,-0.706075],[[-0.999981,0.00623509,0],[0,0,1]]]]
	],
	[
		["Land_u_House_Small_01_V1_F","Land_i_House_Small_01_V3_F","Land_i_House_Small_01_V1_F","Land_i_House_Small_01_V2_F"],
		[[[-1.12695,-4.81641,1.56931],[[0.012478,0.999922,0],[0,0,1]]],[[1.53125,5.28711,1.06545],[[-0.01174,-0.999931,0],[0,0,1]]]]
	],
	//WW2 Staszow
	[
		["Land_WW2_Admin"],
		[[[-3.85253,1.72632,1.65646],[[1,-4.37114e-008,0],[0,0,1]]]]	
	],
	[
		["Land_WW2_Admin2"],
		[[[2.28076,6.48145,1.68778],[[-8.74228e-008,-1,0],[0,0,1]]]]	
	],
	// Beketov
	[
		["Land_HouseV2_02_Interier"],
		[[[0.00195313,-8.37939,-2.86904],[[0,1,0],[0,0,1]]],[[-0.0200195,8.30127,-2.89629],[[-8.74228e-008,-1,0],[0,0,1]]]]
	],
	// Global Mobilization
	[
		["land_gm_euro_house_07_e",	"land_gm_euro_house_07_w",	"land_gm_euro_house_07_d"],
		[[[-1.23242,-3.00391,1.62851],[[0,1,0],[0,0,1]]]]
	]
];

// Buildings which add radio functionality to the location
location_bt_radio =
[
	"Land_TBox_F",				// Transmitter box which can be created through build UI
	// "Land_TTowerSmall_1_F",	// Not sure, looks like some small mobile phone antenna
	"Land_TTowerSmall_2_F",		// Verticall array of small dipoles
	"Land_TTowerBig_1_F",		// A-like transmitter tower
	"Land_TTowerBig_2_F",		// Tall I-like transmitter tower
	"Land_Communication_F",		// Tall tower with antennas on top, often found at military outposts
	
	// WW2
	"Land_wx_radiomast", 		// WW2 radio mast.

	//Global Mobilization
	"land_gm_radiotower_01"
];

// Objects which heal units
location_bt_medical =
[
	"Land_MedicalTent_01_NATO_generic_outer_F",
	"Land_MedicalTent_01_NATO_generic_inner_F",
	"Land_DeconTent_01_NATO_F",

	"Land_MedicalTent_01_NATO_tropic_generic_outer_F",
	"Land_MedicalTent_01_wdl_generic_inner_F",
	"Land_DeconTent_01_NATO_tropic_F",

	"Land_MedicalTent_01_white_generic_outer_F",
	"Land_MedicalTent_01_white_generic_inner_F",
	"Land_DeconTent_01_white_F"
];

/*
_newdir = direction b + 180;
(vehicle player) setDir _newDir;
vehicle player setPos ((b getPos [1.5, (direction b) + 240]) vectorAdd [0, 0, 4.4]);
*/

/*
// Code to get the coordinates in cylindrical form
_b = gBuilding;
_o = cursorObject;

_bPos = getPosATL _b;
_oPos = getPosATL _o;

_dirRel = (_bPos getDir _oPos) - (direction _b);
_zRel = _oPos#2 - _bPos#2;
_distRel = _bPos distance2D _oPos;

[_distRel, _dirRel, _zRel]
*/

/*
// Same code as above, also gives the direction of object relative to direction of house
_b = gBuilding;
_o = cursorObject;

_bPos = getPosATL _b;
_oPos = getPosATL _o;

_dirRel = (_bPos getDir _oPos) - (direction _b);
_zRel = _oPos#2 - _bPos#2;
_distRel = _bPos distance2D _oPos;

_objDir = (direction _o) - (direction _b);

[_distRel, _dirRel, _zRel, _objDir]
*/


/*
// Code to export texture offsets right from the editor, in cylindrical coordinates
// Must select house and texture objects

_objects = get3DENSelected "object";
_house = _objects select {_x isKindOf "House"} select 0;
_textures = _objects select {_x isKindOf "UserTexture1m_F"};

_arrayExport = []; // dist, posDir, zrel, dir

{
_b = _house; 
_o = _x; 
 
_bPos = getPosATL _b; 
_oPos = getPosATL _o; 
 
_dirRel = (_bPos getDir _oPos) - (direction _b); 
_zRel = _oPos#2 - _bPos#2; 
_distRel = _bPos distance2D _oPos; 
 
_objDir = (direction _o) - (direction _b); 
 
_arrayExport pushBack [_distRel, _dirRel, _zRel, round _objDir];
} forEach _textures;

_arrayExport
*/



/*
// Code to export objects from editor in [_pos, [_vectorDir, _vectorUp]]

_objects = get3DENSelected "object"; 
_house = _objects select {_x isKindOf "House"} select 0; 
_textures = _objects select {_x isKindOf "UserTexture1m_F"}; 
 
_arrayExport = []; // dist, posDir, zrel, dir 
 
{ 
_b = _house;  
_o = _x;  
_posModel = _b worldToModel (position _o);
_vdir = vectorDir _o;
_vup = vectorUp _o;
_arrayExport pushBack [_posModel, [_b vectorWorldToModel _vdir, _b vectorWorldToModel _vup]]; 
} forEach _textures; 
 
_arrayExport
*/



/*
//Code to get class names of all selected eden objects
(get3DENSelected "object") apply {typeof _x}
*/

gMilitaryBuildingModels = [];
gMilitaryBuildingTypes = [];
{
	gMilitaryBuildingModels pushBack (_x#0);
	gMilitaryBuildingTypes pushBack (_x#1);
} forEach (call compile preprocessFileLineNumbers "Location\militaryBuildings.sqf");