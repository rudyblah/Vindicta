fnc_selectPlayerSpawnLoadout = {
	call (selectRandom T_SpawnPlayerVariants);
};

T_SpawnPlayerVariants = [
	{
		comment "Exported from Arsenal by william.woodbury";

		comment "[!] UNIT MUST BE LOCAL [!]";
		if (!local _this) exitWith {};

		comment "Remove existing items";
		removeAllWeapons _this;
		removeAllItems _this;
		removeAllAssignedItems _this;
		removeUniform _this;
		removeVest _this;
		removeBackpack _this;
		removeHeadgear _this;
		removeGoggles _this;

		comment "Add containers";
		_this forceAddUniform "U_C_Poloshirt_blue";
		_this addItemToUniform "ACRE_PRC343";
		for "_i" from 1 to 10 do {_this addItemToUniform "11Rnd_45ACP_Mag";};
		_this addHeadgear "H_Bandanna_gry";

		comment "Add weapons";
		_this addWeapon "hgun_Pistol_heavy_01_F";
		_this addHandgunItem "acc_flashlight_pistol";

		comment "Add items";
		_this linkItem "ItemMap";
		_this linkItem "ItemCompass";
		_this linkItem "ItemWatch";

		comment "Set identity";
		//[_this,"Default","male01gre"] call BIS_fnc_setIdentity;
	},
	{
		comment "Exported from Arsenal by william.woodbury";

		comment "[!] UNIT MUST BE LOCAL [!]";
		if (!local _this) exitWith {};

		comment "Remove existing items";
		removeAllWeapons _this;
		removeAllItems _this;
		removeAllAssignedItems _this;
		removeUniform _this;
		removeVest _this;
		removeBackpack _this;
		removeHeadgear _this;
		removeGoggles _this;

		comment "Add containers";
		_this forceAddUniform "U_C_Poloshirt_redwhite";
		_this addItemToUniform "ACRE_PRC343";
		for "_i" from 1 to 10 do {_this addItemToUniform "9Rnd_45ACP_Mag";};
		_this addHeadgear "H_Bandanna_gry";

		comment "Add weapons";
		_this addWeapon "hgun_ACPC2_F";
		_this addHandgunItem "acc_flashlight_pistol";

		comment "Add items";
		_this linkItem "ItemMap";
		_this linkItem "ItemCompass";
		_this linkItem "ItemWatch";

		comment "Set identity";
		//[_this,"Default","male01gre"] call BIS_fnc_setIdentity;
	},
	{
		comment "Exported from Arsenal by william.woodbury";

		comment "[!] UNIT MUST BE LOCAL [!]";
		if (!local _this) exitWith {};

		comment "Remove existing items";
		removeAllWeapons _this;
		removeAllItems _this;
		removeAllAssignedItems _this;
		removeUniform _this;
		removeVest _this;
		removeBackpack _this;
		removeHeadgear _this;
		removeGoggles _this;

		comment "Add containers";
		_this forceAddUniform "U_C_HunterBody_grn";
		_this addItemToUniform "ACRE_PRC343";
		for "_i" from 1 to 10 do {_this addItemToUniform "9Rnd_45ACP_Mag";};
		_this addHeadgear "H_Bandanna_gry";

		comment "Add weapons";
		_this addWeapon "hgun_ACPC2_F";
		_this addHandgunItem "acc_flashlight_pistol";

		comment "Add items";
		_this linkItem "ItemMap";
		_this linkItem "ItemCompass";
		_this linkItem "ItemWatch";

		comment "Set identity";
		//[_this,"Default","male01gre"] call BIS_fnc_setIdentity;
	},
	{
		comment "Exported from Arsenal by william.woodbury";

		comment "[!] UNIT MUST BE LOCAL [!]";
		if (!local _this) exitWith {};

		comment "Remove existing items";
		removeAllWeapons _this;
		removeAllItems _this;
		removeAllAssignedItems _this;
		removeUniform _this;
		removeVest _this;
		removeBackpack _this;
		removeHeadgear _this;
		removeGoggles _this;

		comment "Add containers";
		_this forceAddUniform "U_OrestesBody";
		_this addItemToUniform "ACRE_PRC343";
		for "_i" from 1 to 10 do {_this addItemToUniform "9Rnd_45ACP_Mag";};
		_this addHeadgear "H_Bandanna_gry";

		comment "Add weapons";
		_this addWeapon "hgun_ACPC2_F";
		_this addHandgunItem "acc_flashlight_pistol";
		_this addHandgunItem "9Rnd_45ACP_Mag";

		comment "Add items";
		_this linkItem "ItemMap";
		_this linkItem "ItemCompass";
		_this linkItem "ItemWatch";

		comment "Set identity";
		//[_this,"Default","male01gre"] call BIS_fnc_setIdentity;
	},
	{
		comment "Exported from Arsenal by william.woodbury";

		comment "[!] UNIT MUST BE LOCAL [!]";
		if (!local _this) exitWith {};

		comment "Remove existing items";
		removeAllWeapons _this;
		removeAllItems _this;
		removeAllAssignedItems _this;
		removeUniform _this;
		removeVest _this;
		removeBackpack _this;
		removeHeadgear _this;
		removeGoggles _this;

		comment "Add containers";
		_this forceAddUniform "U_Marshal";
		_this addItemToUniform "ACRE_PRC343";
		for "_i" from 1 to 10 do {_this addItemToUniform "6Rnd_45ACP_Cylinder";};
		_this addHeadgear "H_Bandanna_gry";

		comment "Add weapons";
		_this addWeapon "hgun_Pistol_heavy_02_F";
		_this addHandgunItem "acc_flashlight_pistol";

		comment "Add items";
		_this linkItem "ItemMap";
		_this linkItem "ItemCompass";
		_this linkItem "ItemWatch";

		comment "Set identity";
		//[_this,"Default","male01gre"] call BIS_fnc_setIdentity;
	}
];

