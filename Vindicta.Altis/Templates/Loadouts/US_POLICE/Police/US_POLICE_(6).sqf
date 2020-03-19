removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

private _headwear = [
	"H_Cap_police",
	"H_Cap_police",
	"H_PASGT_basic_blue_F"
];

private _goggles = [
		"G_Spectacles", 
		"G_Sport_Red",
		"G_Squares_Tinted",
		"G_Squares",
		"G_Spectacles_Tinted",
		"G_Shades_Black",
		"G_Shades_Blue",
		"G_Aviator",
		""
];

private _PistolsAndAmmo = [
	["rhsusf_weap_m1911a1",		"rhsusf_mag_7x45acp_MHP"],
	["rhsusf_weap_m9",			"rhsusf_mag_15Rnd_9x19_FMJ"],
	["rhsusf_weap_glock17g4",	"rhsusf_mag_17Rnd_9x19_FMJ"]
];
(selectRandom _PistolsAndAmmo) params ["_pistol", "_pammo"];


comment "Add weapons";
this addWeapon _pistol;
this addHandgunItem _pammo;
this addWeapon "Binocular";
comment "Add containers";
this forceAddUniform "U_B_GEN_Soldier_F";
this addVest "V_TacVest_blk_POLICE";
this addBackpack "B_FieldPack_blk";

comment "Add items to containers";
for "_i" from 1 to 3 do {this addItemToUniform _pammo;};
for "_i" from 1 to 10 do {this addItemToVest "ACE_fieldDressing";};
for "_i" from 1 to 2 do {this addItemToVest "ACE_epinephrine";};
for "_i" from 1 to 4 do {this addItemToVest "ACE_morphine";};
this addItemToVest "ACE_splint";
this addItemToVest "ACE_tourniquet";
for "_i" from 1 to 2 do {this addItemToVest "SmokeShell";};
for "_i" from 1 to 40 do {this addItemToBackpack "ACE_elasticBandage";};
for "_i" from 1 to 10 do {this addItemToBackpack "ACE_adenosine";};
for "_i" from 1 to 10 do {this addItemToBackpack "ACE_epinephrine";};
for "_i" from 1 to 10 do {this addItemToBackpack "ACE_morphine";};
for "_i" from 1 to 2 do {this addItemToBackpack "ACE_personalAidKit";};
for "_i" from 1 to 5 do {this addItemToBackpack "ACE_salineIV";};
for "_i" from 1 to 4 do {this addItemToBackpack "ACE_splint";};
for "_i" from 1 to 3 do {this addItemToBackpack "ACE_tourniquet";};
this addHeadgear selectRandom _headwear;
this addGoggles selectRandom _goggles;

comment "Add items";
this linkItem "ItemGPS";

