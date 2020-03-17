removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

comment "Add weapons";
this addWeapon "rhsusf_weap_MP7A2";
this addPrimaryWeaponItem "rhsusf_mag_40Rnd_46x30_FMJ";
this addWeapon "UK3CB_BAF_L131A1";
this addHandgunItem "UK3CB_BAF_9_17Rnd";

comment "Add containers";
this forceAddUniform "U_B_GEN_Soldier_F";
this addVest "V_TacVest_blk_POLICE";

comment "Add items to containers";
for "_i" from 1 to 3 do {this addItemToUniform "UK3CB_BAF_9_17Rnd";};
this addItemToUniform "rhsusf_mag_40Rnd_46x30_FMJ";
for "_i" from 1 to 10 do {this addItemToVest "ACE_fieldDressing";};
for "_i" from 1 to 2 do {this addItemToVest "ACE_epinephrine";};
for "_i" from 1 to 4 do {this addItemToVest "ACE_morphine";};
this addItemToVest "ACE_splint";
this addItemToVest "ACE_tourniquet";
for "_i" from 1 to 2 do {this addItemToVest "SmokeShell";};
for "_i" from 1 to 3 do {this addItemToVest "UK3CB_BAF_12G_Pellets";};
for "_i" from 1 to 4 do {this addItemToVest "rhsusf_mag_40Rnd_46x30_FMJ";};
this addHeadgear "H_Cap_police";

comment "Add items";
this linkItem "ItemMap";
this linkItem "ItemCompass";
this linkItem "ItemWatch";
this linkItem "ItemGPS";
