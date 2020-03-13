_array = [];

_array set [T_SIZE-1, nil];									//Make an array having the size equal to the number of categories first

// Name, description, faction, addons, etc
_array set [T_NAME, "tWW2_Heer_police"];
_array set [T_DESCRIPTION, "WW2 German units. 1939-1945. Made by MatrikSky"];
_array set [T_DISPLAY_NAME, "WW2 Heer Police"];
_array set [T_FACTION, T_FACTION_Police];
_array set [T_REQUIRED_ADDONS, ["ww2_assets_c_characters_core_c", "lib_weapons", "geistl_main", "fow_weapons", "sab_boat_c", "ifa3_comp_ace_main", "geistl_fow_main", "ifa3_comp_fow", "ifa3_comp_fow_ace_settings", "sab_compat_ace"]];

//==== Infantry ====
_inf = []; _inf resize T_INF_size;
_inf set [T_INF_SIZE-1, nil]; 								//Make an array full of nil
_inf set [T_INF_DEFAULT, ["SG_sturmtrooper_rifleman"]];					//Default infantry if nothing is found

_inf set [T_INF_SL, ["WW2_Heer_police_rifleman", "WW2_Heer_police_rifleman_2", "WW2_Heer_police_rifleman_3", "WW2_Heer_police_rifleman_4", "SG_sturmtrooper_unterofficer", "SG_sturmtrooper_lieutenant", "SG_sturmtrooper_smgunner", "SG_sturmtrooper_ober_rifleman", "SG_sturmtrooper_rifleman", "SG_sturmtrooper_LAT_rifleman", "SG_sturmtrooper_medic"]];
_inf set [T_INF_TL, ["WW2_Heer_police_rifleman", "WW2_Heer_police_rifleman_2", "WW2_Heer_police_rifleman_3", "WW2_Heer_police_rifleman_4", "SG_sturmtrooper_unterofficer", "SG_sturmtrooper_lieutenant", "SG_sturmtrooper_smgunner", "SG_sturmtrooper_ober_rifleman", "SG_sturmtrooper_rifleman", "SG_sturmtrooper_LAT_rifleman", "SG_sturmtrooper_medic"]];
_inf set [T_INF_officer, ["WW2_Heer_police_rifleman", "WW2_Heer_police_rifleman_2", "WW2_Heer_police_rifleman_3", "WW2_Heer_police_rifleman_4", "SG_sturmtrooper_unterofficer", "SG_sturmtrooper_lieutenant", "SG_sturmtrooper_smgunner", "SG_sturmtrooper_ober_rifleman", "SG_sturmtrooper_rifleman", "SG_sturmtrooper_LAT_rifleman", "SG_sturmtrooper_medic"]];
/*
_inf set [T_INF_GL, [""]];
_inf set [T_INF_rifleman, [""]];
_inf set [T_INF_marksman, []];
_inf set [T_INF_sniper, [""]];
_inf set [T_INF_exp, [""]];
_inf set [T_INF_LAT, [""]];
_inf set [T_INF_AT, [""]];
_inf set [T_INF_LMG, [""]];
_inf set [T_INF_HMG, [""]];
_inf set [T_INF_medic, [""]];
_inf set [T_INF_engineer, [""]];
_inf set [T_INF_crew, [""]];
_inf set [T_INF_crew_heli, [""]];
_inf set [T_INF_pilot, [""]];
_inf set [T_INF_pilot_heli, [""]];
_inf set [T_INF_survivor, [""]];
_inf set [T_INF_unarmed, [""]];
_inf set [T_INF_AA, [""]];
_inf set [T_INF_ammo, [""]];
_inf set [T_INF_spotter, [""]];
*/
//==== Vehicles ====
_veh = +(tDefault select T_VEH);
_veh set [T_VEH_DEFAULT, ["LIB_Kfz1_sernyt"]];
_veh set [T_VEH_car_unarmed, ["ifa3_gaz55_ger", "LIB_GER_GazM1", "LIB_Kfz1_sernyt", "LIB_Kfz1", "LIB_Kfz1_camo", "LIB_Kfz1_Hood_sernyt", "LIB_Kfz1_Hood", "LIB_Kfz1_Hood_camo"]];


//==== Drones ====
_drone = +(tDefault select T_DRONE);
_drone set [T_DRONE_SIZE-1, nil];
//_drone set [T_DRONE_DEFAULT, ["O_UAV_01_F"]];
/*
_drone set [T_DRONE_UGV_unarmed, ["O_UGV_01_F"]];
_drone set [T_DRONE_UGV_armed, ["O_UGV_01_rcws_F"]];
_drone set [T_DRONE_plane_attack, ["O_UAV_02_dynamicLoadout_F"]];
_drone set [T_DRONE_plane_unarmed, ["O_UAV_02_dynamicLoadout_F"]];
_drone set [T_DRONE_heli_attack, ["O_T_UAV_04_CAS_F"]];
_drone set [T_DRONE_quadcopter, ["O_UAV_01_F"]];
_drone set [T_DRONE_designator, ["O_Static_Designator_02_F"]];
_drone set [T_DRONE_stat_HMG_low, ["O_HMG_01_A_F"]];
_drone set [T_DRONE_stat_GMG_low, ["O_GMG_01_A_F"]];
_drone set [T_DRONE_stat_AA, ["O_SAM_System_04_F"]];
*/
//==== Cargo ====
_cargo = [];

_cargo set [T_CARGO_default,	["LIB_BasicAmmunitionBox_GER"]];
_cargo set [T_CARGO_box_small,	["LIB_BasicAmmunitionBox_GER"]];
_cargo set [T_CARGO_box_medium,	["LIB_BasicWeaponsBox_GER"]];
_cargo set [T_CARGO_box_big,	["LIB_WeaponsBox_Big_GER"]];

//==== Groups ====
_group = +(tDefault select T_GROUP);


//==== Set arrays ====
_array set [T_INF, _inf];
_array set [T_VEH, _veh];
_array set [T_DRONE, _drone];
_array set [T_CARGO, _cargo];
_array set [T_GROUP, _group];
_array set [T_NAME, "tWW2_Heer_police"];

_array