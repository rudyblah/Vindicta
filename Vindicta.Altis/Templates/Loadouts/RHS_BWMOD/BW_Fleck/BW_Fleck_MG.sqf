removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

_RandomHeadgear = selectRandom ["BWA3_OpsCore_Fleck"];
this addHeadgear _RandomHeadgear;
_RandomGoggles = selectRandom ["rhs_googles_black","rhs_googles_clear","rhs_googles_yellow","rhs_googles_orange","rhs_ess_black"];
this addGoggles _RandomGoggles;
this forceAddUniform "BWA3_Uniform_sleeves_Fleck";
_RandomVest = selectRandom ["BWA3_Vest_MachineGunner_Fleck"];
this addVest _RandomVest;
this addBackpack "BWA3_Kitbag_Fleck";

this addWeapon "BWA3_MG3";
this addPrimaryWeaponItem "BWA3_acc_VarioRay_irlaser_black";
this addPrimaryWeaponItem "BWA3_120Rnd_762x51_soft";

this addItemToUniform "FirstAidKit";
for "_i" from 1 to 2 do {this addItemToVest "BWA3_120Rnd_762x51_soft";};
for "_i" from 1 to 2 do {this addItemToBackpack "BWA3_120Rnd_762x51_Tracer_soft";};
this linkItem "ItemMap";
this linkItem "ItemCompass";
this linkItem "ItemWatch";
this linkItem "ItemRadio";
