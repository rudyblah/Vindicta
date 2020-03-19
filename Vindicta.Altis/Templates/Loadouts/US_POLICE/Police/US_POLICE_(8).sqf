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

private _optics = [
	"",
	"optic_aco_smg",
	"optic_holosight_smg_blk_f"
];

private _grips = [
	"",
	"rhsusf_acc_grip2",
	"rhsusf_acc_grip1",
	"rhsusf_acc_grip3"
];

private _PistolsAndAmmo = [
	["rhsusf_weap_m1911a1",		"rhsusf_mag_7x45acp_MHP"],
	["rhsusf_weap_m9",			"rhsusf_mag_15Rnd_9x19_FMJ"],
	["rhsusf_weap_glock17g4",	"rhsusf_mag_17Rnd_9x19_FMJ"]
];
(selectRandom _PistolsAndAmmo) params ["_pistol", "_pammo"];

private _PrimaryAndAmmo = [
	["SMG_05_F",			"30Rnd_9x21_Mag_SMG_02"],
	["rhsusf_weap_MP7A2",	"rhsusf_mag_40Rnd_46x30_FMJ"],
	["SMG_03C_black",		"50Rnd_570x28_SMG_03"]
];
(selectRandom _PrimaryAndAmmo) params ["_primary", "_ammo"];


comment "Add weapons";
this addWeapon _primary;
this addPrimaryWeaponItem selectRandom _optics;
this addPrimaryWeaponItem _ammo;
this addPrimaryWeaponItem selectRandom _grips;
this addWeapon _pistol;
this addHandgunItem _pammo;
this addWeapon "Binocular";
comment "Add containers";
this forceAddUniform "U_B_GEN_Soldier_F";
this addVest "V_TacVest_blk_POLICE";

comment "Add items to containers";
for "_i" from 1 to 3 do {this addItemToUniform _pammo;};
this addItemToUniform _ammo;
for "_i" from 1 to 10 do {this addItemToVest "ACE_fieldDressing";};
for "_i" from 1 to 2 do {this addItemToVest "ACE_epinephrine";};
for "_i" from 1 to 4 do {this addItemToVest "ACE_morphine";};
this addItemToVest "ACE_splint";
this addItemToVest "ACE_tourniquet";
for "_i" from 1 to 2 do {this addItemToVest "SmokeShell";};
for "_i" from 1 to 6 do {this addItemToVest _ammo;};
this addHeadgear selectRandom _headwear;
this addGoggles selectRandom _goggles;

comment "Add items";
this linkItem "ItemGPS";
