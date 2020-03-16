/*
custom Livonian Police for ARMA III - Representing a nation in a time of equipment flux(RHS)
*/

_array = [];

_array set [T_SIZE-1, nil];									//Make an array having the size equal to the number of categories first

// Name, description, faction, addons, etc
_array set [T_NAME, "tRHS_LDF_NATO_police"];
_array set [T_DESCRIPTION, "NATO aligned LDF Police. Uses RHS. Made by Straker27"];
_array set [T_DISPLAY_NAME, "RHS LDF NATO Police"];
_array set [T_FACTION, T_FACTION_Police];
_array set [T_REQUIRED_ADDONS, [
								"rhs_c_troops",		// RHS AFRF
								"rhsusf_c_troops",	// RHS USAF
								"rhssaf_c_troops",	// RHS SAF
								"rhsgref_c_troops"	// RHS GREF
								]];

//==== Infantry ====
_inf = [];
_inf resize T_INF_SIZE;
_inf set [T_INF_default, ["I_soldier_F"]];					//Default infantry if nothing is found

_inf set [T_INF_officer, ["RHS_LDF_NATO_police_TL_SMG","RHS_LDF_NATO_police_TL_rifle","RHS_LDF_NATO_police_TL_shotgun","RHS_LDF_NATO_police_SMG","RHS_LDF_NATO_police_shotgun","RHS_LDF_NATO_police_rifle"]];
_inf set [T_INF_rifleman, ["RHS_LDF_NATO_police_SMG","RHS_LDF_NATO_police_shotgun","RHS_LDF_NATO_police_rifle"]];
_inf set [T_INF_SL, ["RHS_LDF_NATO_police_TL_SMG","RHS_LDF_NATO_police_TL_rifle","RHS_LDF_NATO_police_TL_shotgun","RHS_LDF_NATO_police_SMG","RHS_LDF_NATO_police_shotgun","RHS_LDF_NATO_police_rifle"]];
/*
_inf set [T_INF_TL, ["B_GEN_Soldier_F"]];
_inf set [T_INF_SL, ["B_GEN_Soldier_F"]];
_inf set [T_INF_GL, ["B_GEN_Soldier_F"]];
_inf set [T_INF_marksman, ["B_GEN_Soldier_F"]];
_inf set [T_INF_sniper, ["B_GEN_Soldier_F"]];
_inf set [T_INF_spotter, ["B_GEN_Soldier_F"]];
_inf set [T_INF_exp, ["B_GEN_Soldier_F"]];
_inf set [T_INF_ammo, ["B_GEN_Soldier_F"]];
_inf set [T_INF_LAT, ["B_GEN_Soldier_F"]];
_inf set [T_INF_AT, ["B_GEN_Soldier_F"]];
_inf set [T_INF_AA, ["B_GEN_Soldier_F"]];
_inf set [T_INF_LMG, ["B_GEN_Soldier_F"]];
_inf set [T_INF_HMG, ["B_GEN_Soldier_F"]];
_inf set [T_INF_medic, ["B_GEN_Soldier_F"]];
_inf set [T_INF_engineer, ["B_GEN_Soldier_F"]];
_inf set [T_INF_crew, ["B_GEN_Soldier_F"]];
_inf set [T_INF_crew_heli, ["B_GEN_Soldier_F"]];
_inf set [T_INF_pilot, ["B_GEN_Soldier_F"]];
_inf set [T_INF_pilot_heli, ["B_GEN_Soldier_F"]];
_inf set [T_INF_survivor, ["B_GEN_Soldier_F"]];
_inf set [T_INF_unarmed, ["B_GEN_Soldier_F"]];
*/

//==== Vehicles ====
_veh = +(tDefault select T_VEH);
_veh set [T_VEH_DEFAULT, ["I_E_Offroad_01_F"]]; //TODO: change skin to forest ranger
_veh set [T_VEH_car_unarmed, ["I_E_Offroad_01_F", "I_E_Offroad_01_comms_F", "I_E_Offroad_01_covered_F"]];

//==== Drones ====
_drone = +(tDefault select T_DRONE);
/*
_drone set [T_DRONE_SIZE-1, nil];
_drone set [T_DRONE_DEFAULT, ["O_UAV_01_F"]];
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
_cargo = +(tDefault select T_CARGO);

//==== Groups ====
_group = +(tDefault select T_GROUP);
_group set [T_GROUP_DEFAULT, [[[T_INF, T_INF_officer], [T_INF, T_INF_rifleman]]]];


//==== Set arrays ====
_array set [T_INF, _inf];
_array set [T_VEH, _veh];
_array set [T_DRONE, _drone];
_array set [T_CARGO, _cargo];
_array set [T_GROUP, _group];

_array
