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
		"G_Aviator"
];

private _optics = [
	"",
	"optic_aco_smg",
	"optic_holosight_smg_blk_f"
];

comment "Add weapons";
this addWeapon "UK3CB_BAF_L91A1";
this addPrimaryWeaponItem selectRandom _optics;
this addPrimaryWeaponItem "UK3CB_BAF_9_30Rnd";
this addWeapon "UK3CB_BAF_L131A1";
this addHandgunItem "UK3CB_BAF_9_17Rnd";

comment "Add containers";
this forceAddUniform "U_B_GEN_Soldier_F";
this addVest "V_TacVest_blk_POLICE";

comment "Add items to containers";
for "_i" from 1 to 3 do {this addItemToUniform "UK3CB_BAF_9_17Rnd";};
this addItemToUniform "UK3CB_BAF_9_30Rnd";
for "_i" from 1 to 10 do {this addItemToVest "ACE_fieldDressing";};
for "_i" from 1 to 2 do {this addItemToVest "ACE_epinephrine";};
for "_i" from 1 to 4 do {this addItemToVest "ACE_morphine";};
this addItemToVest "ACE_splint";
this addItemToVest "ACE_tourniquet";
for "_i" from 1 to 2 do {this addItemToVest "SmokeShell";};
for "_i" from 1 to 6 do {this addItemToVest "UK3CB_BAF_9_30Rnd";};
this addHeadgear selectRandom _headwear;
this addGoggles selectRandom _goggles;

comment "Add items";
this linkItem "ItemMap";
this linkItem "ItemCompass";
this linkItem "ItemWatch";
this linkItem "ItemGPS";

