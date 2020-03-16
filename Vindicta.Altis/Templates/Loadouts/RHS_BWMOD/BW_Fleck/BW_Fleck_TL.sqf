removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

_RandomHeadgear = selectRandom ["BWA3_Booniehat_Fleck"];
this addHeadgear _RandomHeadgear;
_RandomGoggles = selectRandom ["rhs_googles_black","rhs_googles_clear","rhs_googles_yellow","rhs_googles_orange","rhs_ess_black"];
this addGoggles _RandomGoggles;
this forceAddUniform "BWA3_Uniform_sleeves_Fleck";
_RandomVest = selectRandom ["BWA3_Vest_Leader_Fleck"];
this addVest _RandomVest;
this addBackpack "BWA3_Kitbag_Fleck";

this addWeapon "BWA3_G36A3";
this addPrimaryWeaponItem "BWA3_acc_VarioRay_irlaser";
this addPrimaryWeaponItem "BWA3_optic_ZO4x30i_MicroT2";
this addPrimaryWeaponItem "BWA3_30Rnd_556x45_G36";
this addWeapon "BWA3_P8";
this addHandgunItem "BWA3_acc_LLM01_irlaser";
this addHandgunItem "BWA3_15Rnd_9x19_P8";
this addWeapon "BWA3_Vector";

this addItemToUniform "FirstAidKit";
this addItemToUniform "rhsusf_ANPVS_14";
for "_i" from 1 to 2 do {this addItemToUniform "Chemlight_green";};
for "_i" from 1 to 2 do {this addItemToUniform "BWA3_15Rnd_9x19_P8";};
for "_i" from 1 to 5 do {this addItemToVest "BWA3_30Rnd_556x45_G36";};
for "_i" from 1 to 2 do {this addItemToVest "BWA3_DM51A1";};
this addItemToBackpack "BWA3_DM25";
this addItemToBackpack "BWA3_DM32_Green";
this addItemToBackpack "BWA3_DM32_Orange";
this addItemToBackpack "BWA3_DM32_Red";
this linkItem "ItemMap";
this linkItem "ItemCompass";
this linkItem "ItemWatch";
this linkItem "ItemRadio";
this linkItem "ItemGPS";
