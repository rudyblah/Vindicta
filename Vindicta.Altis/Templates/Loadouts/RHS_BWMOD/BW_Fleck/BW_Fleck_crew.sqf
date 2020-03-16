removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

_RandomHeadgear = selectRandom ["BWA3_CrewmanKSK_Fleck_Headset"];
this addHeadgear _RandomHeadgear;
_RandomGoggles = selectRandom ["rhs_googles_black","rhs_googles_clear","rhs_googles_yellow","rhs_googles_orange","rhs_ess_black"];
this addGoggles _RandomGoggles;
this forceAddUniform "BWA3_Uniform_Crew_Fleck";
this addVest "V_TacVest_camo";

this addWeapon "BWA3_MP7";
this addPrimaryWeaponItem "BWA3_40Rnd_46x30_MP7";

this addItemToUniform "FirstAidKit";
this addItemToUniform "BWA3_DM25";
this addItemToUniform "BWA3_DM32_Green";
this addItemToUniform "BWA3_DM32_Orange";
this addItemToUniform "BWA3_DM32_Red";
for "_i" from 1 to 2 do {this addItemToVest "BWA3_40Rnd_46x30_MP7";};
this linkItem "ItemMap";
this linkItem "ItemCompass";
this linkItem "ItemWatch";
this linkItem "ItemRadio";
