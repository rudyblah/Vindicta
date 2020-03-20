removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

[this, selectRandom gVanillaFaces, "ace_novoice"] call BIS_fnc_setIdentity;

private _headwear = [
	"H_Cap_blk",
	"H_Cap_blu",
	"H_Cap_grn",
	"H_Cap_oli",
	"H_Cap_red",
	"H_Cap_surfer",
	"H_Cap_tan",
	"H_PASGT_basic_black_F",
	"H_PASGT_basic_blue_F",
	"H_PASGT_basic_olive_F",
	""
];

private _uniforms = [
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_burgundy",
	"U_C_Poloshirt_redwhite",
	"U_C_Poloshirt_salmon",
	"U_C_Poloshirt_stripped",
	"U_C_Poloshirt_tricolour",
	"U_Marshal",
	"U_I_C_Soldier_Bandit_5_F",
	"U_I_C_Soldier_Bandit_3_F",
	"U_C_Man_casual_1_F",
	"U_C_Man_casual_2_F",
	"U_C_Man_casual_3_F",
	"U_C_man_sport_2_F",
	"U_C_Man_casual_6_F",
	"U_C_Man_casual_4_F",
	"U_C_Man_casual_5_F",
	"U_C_Uniform_Farmer_01_F",
	"U_C_E_LooterJacket_01_F",
	"U_I_L_Uniform_01_tshirt_black_F",
	"U_I_L_Uniform_01_tshirt_skull_F",
	"U_I_L_Uniform_01_tshirt_sport_F",
	"U_C_Uniform_Scientist_01_formal_F",
	"U_C_Uniform_Scientist_01_F",
	"U_C_Uniform_Scientist_02_formal_F",
	"U_O_R_Gorka_01_black_F",
	"U_C_Mechanic_01_F"
];

private _vests = [
	"V_TacVest_blk",
	"V_TacVest_brn",
	"V_TacVest_camo",
	"V_TacVest_khk",
	"V_TacVest_oli",
	"V_TacVest_blk_POLICE",
	"V_I_G_resistanceLeader_F"
];

private _backpacks = [
	"B_FieldPack_blk",
	"B_FieldPack_cbr",
	"B_FieldPack_khk",
	"B_FieldPack_oli"
];

private _gunsAndAmmo = [
	// pistols
	["rhsusf_weap_m1911a1",		"rhsusf_mag_7x45acp_MHP", 		true],	0.8,
	["rhsusf_weap_m9",			"rhsusf_mag_15Rnd_9x19_FMJ",	true],	0.6,
	["rhsusf_weap_glock17g4",	"rhsusf_mag_17Rnd_9x19_FMJ", 	true],	0.4,
	["rhs_weap_m3a1",			"rhsgref_30rnd_1143x23_M1911B_SMG",	false],	0.3,
	["rhs_weap_m1garand_sa43",	"rhsgref_8Rnd_762x63_M2B_M1rifle",	false],	0.3,
	["rhs_weap_pp2000_folded", 	"rhs_mag_9x19mm_7n31_20", 		true],	0.2,
	["SMG_05_F",				"30Rnd_9x21_Mag_SMG_02",		false],	0.2,
	["rhsusf_weap_MP7A2",		"rhsusf_mag_40Rnd_46x30_FMJ",	false],	0.2,
	["rhs_weap_M590_8RD",		"rhsusf_8Rnd_Slug",				false],	0.1,
	["rhs_weap_M590_5RD",		"rhsusf_5Rnd_Slug",				false],	0.1,
	["srifle_DMR_06_hunter_F",	"20Rnd_762x51_Mag",				false],	0.1,
	["rhs_weap_m4a1_carryhandle",	"rhs_mag_30Rnd_556x45_M855A1_Stanag",				false],	0.1
];


this forceAddUniform selectRandom _uniforms;
this addHeadgear selectRandom _headwear;
(selectRandomWeighted _gunsAndAmmo) params ["_gun", "_ammo", "_isPistol"];

this addWeapon _gun;

if(_isPistol) then {
	this addHandgunItem _ammo;
	if (_gun == "rhs_weap_pp2000_folded") then {
		this addHandgunItem "optic_yorris"
	};
} else {
	this addWeaponItem [_gun, _ammo];
};

for "_i" from 1 to 5 do { this addItemToUniform _ammo };
if(ceil random 100 <= 70) then {
	this addVest selectRandom _vests;
	for "_i" from 1 to 6 do {	this addItemToVest _ammo};
};
if(ceil random 100 <= 70) then {
	this addBackpack selectRandom _backpacks;
	switch (ceil random 3) do {
		case 1: {for "_i" from 1 to 20 do {this addItemToBackpack "_ammo";};};
		case 2: { switch (ceil random 3) do {
				case 1: {
					this addItemToBackpack "ACE_Cellphone";
					for "_i" from 1 to 4 do {this addItemToBackpack "IEDLandSmall_Remote_Mag";};
					for "_i" from 1 to 2 do {this addItemToBackpack "rhs_ec400_sand_mag";};
				};
				case 2: {
					this addItemToBackpack "ACE_Cellphone";
					for "_i" from 1 to 2 do {this addItemToBackpack "IEDUrbanBig_Remote_Mag";};
					for "_i" from 1 to 2 do {this addItemToBackpack "rhs_ec400_sand_mag";};
				};
				case 3: {
					this addItemToBackpack "ACE_Cellphone";
					for "_i" from 1 to 9 do {this addItemToBackpack "DemoCharge_Remote_Mag";};
					this addItemToBackpack "rhs_ec200_sand_mag";
				};
			};
		};
		case 3: {
			for "_i" from 1 to 40 do {this addItemToBackpack "ACE_elasticBandage";};
			for "_i" from 1 to 4 do {this addItemToBackpack "ACE_adenosine";};
			for "_i" from 1 to 6 do {this addItemToBackpack "ACE_epinephrine";};
			for "_i" from 1 to 6 do {this addItemToBackpack "ACE_morphine";};
			for "_i" from 1 to 8 do {this addItemToBackpack "ACE_salineIV";};
			for "_i" from 1 to 4 do {this addItemToBackpack "ACE_tourniquet";};
			for "_i" from 1 to 5 do {this addItemToBackpack "ACE_splint";};
			for "_i" from 1 to 5 do {this addItemToBackpack "ACE_personalAidKit";};
		};
	};
};
if(random 5 < 1) then {
	this addGoggles selectRandomWeighted [
		"G_Spectacles", 		1,
		"G_Sport_Red", 			1,
		"G_Squares_Tinted", 	1,
		"G_Squares", 			1,
		"G_Spectacles_Tinted", 	1,
		"G_Shades_Black", 		1,
		"G_Shades_Blue", 		1
	];
};
