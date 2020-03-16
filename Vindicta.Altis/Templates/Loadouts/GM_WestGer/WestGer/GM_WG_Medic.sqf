removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

//	==== Head Gear ====
this addHeadgear "gm_ge_headgear_m62_net";

//	==== Uniform ====
this forceAddUniform "gm_ge_army_uniform_soldier_80_ols"; 
this addItemToUniform "FirstAidKit";
this addItemToUniform "gm_ge_facewear_m65";
this addItemToUniform "gm_ge_headgear_hat_80_oli";

//	==== Vest ====
this addVest "gm_ge_army_vest_80_medic";
for "_i" from 1 to 2 do {this addItemToVest "gm_smokeshell_wht_dm25";};
for "_i" from 1 to 2 do {this addItemToVest "gm_smokeshell_grn_dm21";};

//	==== Backpack ====
this addBackpack "gm_ge_army_backpack_80_oli";
for "_i" from 1 to 4 do {this addItemToVest "FirstAidKit";};
for "_i" from 1 to 2 do {this addItemToVest "gm_ge_army_medkit_80";};

//	==== Weapons ====
private _guns = [
	["gm_g3a3_oli"], 0.5,
	["gm_g3a3_blk"], 0.5,
	["gm_g3a3_grn"], 0.5,
	["gm_g3a3_des"], 0.1
];

(selectRandomWeighted _guns) params ["_gun"];
this addWeapon _gun;
this addPrimaryWeaponItem "gm_20Rnd_762x51mm_B_T_DM21_g3_blk";
for "_i" from 1 to 6 do {this addItemToVest "gm_20Rnd_762x51mm_B_T_DM21_g3_blk";}; 

this addWeapon "gm_p1_blk";
this addHandgunItem "gm_8Rnd_9x19mm_B_DM51_p1_blk";
for "_i" from 1 to 2 do {this addItemToVest "gm_8Rnd_9x19mm_B_DM51_p1_blk";};

//	==== Misc Items ====
this linkItem "ItemMap"; 			// Map
this linkItem "gm_watch_kosei_80"; 	// Watch
this linkItem "gm_ge_army_conat2"; 	// Compass