removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

[this, selectRandom gVanillaFaces, "ace_novoice"] call BIS_fnc_setIdentity;

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

private _gunsAndAmmo = [
	// pistols
	["UK3CB_BAF_L9A1", 		"UK3CB_BAF_9_13Rnd", 		true],	1,
	["UK3CB_BAF_L107A1", 	"UK3CB_BAF_L107A1", 		true],	0.9,
	["UK3CB_BAF_L117A2", 	"UK3CB_BAF_9_15Rnd", 		true],	0.8,
	["UK3CB_BAF_L131A1", 	"UK3CB_BAF_9_17Rnd", 		true],	0.7,
	// longs
	["UK3CB_BAF_L91A1", 	"UK3CB_BAF_9_30Rnd", 		false],	0.1,
	["UK3CB_BAF_L92A1", 	"UK3CB_BAF_9_30Rnd",		false],	0.1,
	["UK3CB_BAF_L128A1", 	"UK3CB_BAF_12G_Slugs", 		false],	0.1,
	["UK3CB_BAF_L119A1", 	"UK3CB_BAF_556_30Rnd", 		false],	0.1
];

this forceAddUniform selectRandom _uniforms;

(selectRandomWeighted _gunsAndAmmo) params ["_gun", "_ammo", "_isPistol"];

this addWeapon _gun;

if(_isPistol) then {
	this addHandgunItem _ammo;
} else {
	this addWeaponItem [_gun, _ammo];
};

for "_i" from 1 to 5 do { this addItemToUniform _ammo };

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
