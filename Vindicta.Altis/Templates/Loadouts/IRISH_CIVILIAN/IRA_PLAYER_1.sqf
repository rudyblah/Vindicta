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
	["UK3CB_BAF_L9A1", 		"UK3CB_BAF_9_13Rnd", 		true],	1,
	["UK3CB_BAF_L107A1", 	"UK3CB_BAF_L107A1", 		true],	0.9,
	["UK3CB_BAF_L117A2", 	"UK3CB_BAF_9_15Rnd", 		true],	0.8,
	["UK3CB_BAF_L131A1", 	"UK3CB_BAF_9_17Rnd", 		true],	0.7
];


this forceAddUniform selectRandom _uniforms;
this addItem "ACRE_PRC343";
(selectRandomWeighted _gunsAndAmmo) params ["_gun", "_ammo", "_isPistol"];

this addWeapon _gun;

if(_isPistol) then {
	this addHandgunItem _ammo;
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
