removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

[this, "", "ace_novoice"] call BIS_fnc_setIdentity;

private _uniforms = [
	"tg_u_dadpat_floral",
	"tg_u_dadpat_tacky",
	"tg_u_dadpat_blue_hi",
	"tg_u_dadpat_red_hi",
	"tg_u_dadpat_grn_palm",
	"tg_u_dadpat_prp_palm",
    "tg_u_dadpat_blue_plaid",
    "tg_u_dadpat_grn_plaid",
    "tg_u_dadpat_orng_plaid",
    "tg_u_dadpat_red_plaid",
    "tg_u_dadpat_shorts_floral",
    "tg_u_dadpat_shorts_tacky",
    "tg_u_dadpat_shorts_blue_hi",
    "tg_u_dadpat_shorts_red_hi",
    "tg_u_dadpat_shorts_grn_palm",
    "tg_u_dadpat_shorts_prp_palm",
    "tg_u_dadpat_shorts_blue_plaid",
    "tg_u_dadpat_shorts_grn_plaid",
    "tg_u_dadpat_shorts_orng_plaid",
    "tg_u_dadpat_shorts_red_plaid",
    "tg_u_dadpat_tactical_floral",
    "tg_u_dadpat_tactical_tacky",
    "tg_u_dadpat_tactical_blue_hi",
    "tg_u_dadpat_tactical_red_hi",
    "tg_u_dadpat_tactical_grn_palm",
    "tg_u_dadpat_tactical_prp_palm",
    "tg_u_dadpat_tactical_blue_plaid",
    "tg_u_dadpat_tactical_grn_plaid",
    "tg_u_dadpat_tactical_orng_plaid",
    "tg_u_dadpat_tactical_red_plaid"
];

private _headwear = [
	"H_Cap_blk",
	"H_Cap_blu",
	"H_Cap_grn",
	"H_Cap_oli",
	"H_Cap_red",
	"H_Cap_surfer",
	"H_Cap_tan"
];

private _gunsAndAmmo = [
	// pistols
	["rhsusf_weap_m1911a1",		"rhsusf_mag_7x45acp_MHP", 		true],	1,
	["rhsusf_weap_m9",			"rhsusf_mag_15Rnd_9x19_FMJ",	true],	0.9,
	["rhsusf_weap_glock17g4",	"rhsusf_mag_17Rnd_9x19_FMJ", 	true],	0.8,
	["rhs_weap_pp2000_folded", 	"rhs_mag_9x19mm_7n31_20", 		true],	0.1
];


this forceAddUniform selectRandom _uniforms;
this addItem "ACRE_PRC343";
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

this addHeadgear selectRandom _headwear;

if(random 5 < 1) then {
	this addGoggles selectRandomWeighted [
		"G_Spectacles", 		1,
		"G_Sport_Red", 			1,
		"G_Squares_Tinted", 	1,
		"G_Squares", 			1,
		"G_Spectacles_Tinted", 	1,
		"G_Shades_Black", 		1,
		"G_Shades_Blue", 		1,
		"G_Aviator", 			1
	];
};

this linkItem "ItemMap";
this linkItem "ItemCompass";
this linkItem "ItemWatch";
